#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#define HEADER_SIZE 44

// --- COMPRESSION ---
int get_sign(int sample) { return (sample >= 0) ? 1 : 0; }
unsigned int get_magnitude(int sample) { return (sample < 0) ? -sample : sample; }

unsigned char ulaw_compress(int sample) {
    int sign = get_sign(sample);
    unsigned int mag = get_magnitude(sample);
    
    // Clamp to maximum allowed speech sample value
    if (mag > 8159) mag = 8159;
    
    // Add the +33 bias
    mag += 33;

    int chord = 0;
    int step = 0;

    // Optimized CLZ implementation to determine chord and step in O(1) time
    if (mag >= 64) {
        // __builtin_clz returns the number of leading zeros in a 32-bit int.
        // 26 - clz maps the position of the highest '1' bit to chords 1 through 7.
        chord = 26 - __builtin_clz(mag);
        step = (mag >> (chord + 1)) & 0xF;
    } else {
        // Range [0...63] is always Chord 0
        chord = 0;
        step = (mag >> 1) & 0xF;
    }

    // Assemble sign (1 bit), chord (3 bits), and step (4 bits)
    unsigned char codeword = (sign << 7) | (chord << 4) | step;
    
    // Bitwise inversion per the standard
    return ~codeword;
}

// --- DECOMPRESSION ---
int ulaw_expand(unsigned char codeword) {
    // 1. Invert the codeword back
    unsigned char inverted = ~codeword;

    // 2. Extract sign, chord, and step bits
    int sign = (inverted >> 7) & 0x01;
    int chord = (inverted >> 4) & 0x07;
    int step = inverted & 0x0F;

    // 3. Reconstruct the magnitude using the decoding table pattern
    int magnitude = ((step << 1) + 33) << chord;

    // 4. Remove the +33 bias
    magnitude -= 33;

    // 5. Apply the original sign
    return (sign == 1) ? magnitude : -magnitude;
}

// --- TEST BENCH ---
int main() {
    FILE *file_in = fopen("voice.wav", "rb");
    FILE *file_out = fopen("output_tone.wav", "wb");

    if (file_in == NULL || file_out == NULL) {
        printf("Error: Could not open file.\n");
        return 1;
    }

    // 1. Copy the 44-byte WAV header untouched
    unsigned char header[HEADER_SIZE];
    fread(header, sizeof(unsigned char), HEADER_SIZE, file_in);
    fwrite(header, sizeof(unsigned char), HEADER_SIZE, file_out);

    // 2. Process the audio data sample by sample
    short sample;
    int samples_processed = 0;

    // Read 2 bytes (one 16-bit short) at a time
    while (fread(&sample, sizeof(short), 1, file_in) == 1) {
        // Compress
        unsigned char compressed = ulaw_compress(sample);
        
        // Decompress
        short decompressed = (short)ulaw_expand(compressed);
        
        // Write the decompressed value to the output file
        fwrite(&decompressed, sizeof(short), 1, file_out);
        samples_processed++;
    }

    fclose(file_in);
    fclose(file_out);

    printf("Processing complete! %d samples compressed and decompressed.\n", samples_processed);
    
    return 0;
}