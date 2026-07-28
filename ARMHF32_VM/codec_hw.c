#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#define HEADER_SIZE 44

// --- HARDWARE-ACCELERATED COMPRESSION ---
// This replaces the entire software algorithm by calling our custom Verilog ALU
unsigned char ulaw_compress(short sample) {
    unsigned int codeword;
    
    // Execute the custom hardware instruction directly
    // "mulaw [destination], [source]"
    __asm__ volatile (
        "mulaw %0, %1" 
        : "=r" (codeword)  // Output operand
        : "r" (sample)     // Input operand
    );
    
    return (unsigned char)codeword;
}

// --- DECOMPRESSION ---
int ulaw_expand(unsigned char codeword) {
    unsigned char inverted = ~codeword;
    int sign = (inverted >> 7) & 0x01;
    int chord = (inverted >> 4) & 0x07;
    int step = inverted & 0x0F;
    int magnitude = ((step << 1) + 33) << chord;
    magnitude -= 33;
    return (sign == 1) ? magnitude : -magnitude;
}

// --- TEST BENCH ---
int main() {
    FILE *file_in = fopen("voice.wav", "rb");
    FILE *file_out = fopen("output_tone_hw.wav", "wb");

    if (file_in == NULL || file_out == NULL) {
        printf("Error: Could not open file.\n");
        return 1;
    }

    unsigned char header[HEADER_SIZE];
    fread(header, sizeof(unsigned char), HEADER_SIZE, file_in);
    fwrite(header, sizeof(unsigned char), HEADER_SIZE, file_out);

    short sample;
    int samples_processed = 0;

    while (fread(&sample, sizeof(short), 1, file_in) == 1) {
        // Now calls the hardware-accelerated inline assembly!
        unsigned char compressed = ulaw_compress(sample);
        short decompressed = (short)ulaw_expand(compressed);
        fwrite(&decompressed, sizeof(short), 1, file_out);
        samples_processed++;
    }

    fclose(file_in);
    fclose(file_out);

    return 0;
}