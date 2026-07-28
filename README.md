# $\mu$-law Audio Compression: Hardware/Software Co-Design

## Overview
This repository contains the final project for SENG 440 (Embedded Systems). The objective is to design, implement, and optimize a $\mu$-law audio compression and decompression codec for a 32-bit ARM processor. 

The project explores a complete hardware/software co-design pipeline. It begins with a pure software implementation in C, analyzes its assembly for performance bottlenecks, and ultimately resolves those bottlenecks by designing a custom hardware datapath (Verilog) mapped to a custom instruction. 

## Project Objectives
*   Record a 10-second voice sample and save it as a WAV file.
*   Implement $\mu$-law compression and decompression algorithms in C.
*   Compare the uncompressed audio with the lossy decompressed audio to verify algorithmic correctness.
*   Optimize the C code and analyze the generated ARM assembly to determine instruction count and processing time.
*   Provide architectural support by defining a new custom instruction (`muLaw`) and implementing the corresponding functional unit in hardware.
*   Rewrite the software implementation using inline assembly to utilize the custom hardware instruction.
*   Compare the performance of the software-only solution versus the hardware-accelerated solution.

## Repository Structure
*   **`voice.wav`**: The original 10-second, uncompressed audio recording (8 kHz, 16-bit Mono).
*   **`codec.c`**: The baseline software implementation of the $\mu$-law compression and decompression algorithms.
*   **`codec_hw.c`**: The hardware-accelerated implementation utilizing the custom `muLaw` instruction via ARM inline assembly.
*   **`tb_mulaw_custom.v`**: The custom hardware logic (Verilog) implementing the $\mu$-law datapath using a priority encoder and barrel shifter.
*   **`fixed_tone.wav`**: The final audio file demonstrating the successful compression and decompression of the original voice sample, complete with the expected lossy acoustic characteristics.

## Performance Comparison
A critical component of this project was analyzing the performance improvements gained by migrating computational complexity from software to custom hardware.

*   **Software Implementation (`codec.c`):** 
    Utilized the `__builtin_clz` compiler intrinsic to optimize the process of finding the chord and step values. Despite this optimization, the loop required multiple bitwise shifts, masks, and branch instructions, resulting in a worst-case processing time of **25 clock cycles** per sample.
*   **Hardware Implementation (`tb_mulaw_custom.v` & `codec_hw.c`):** 
    By offloading the chord detection and bit manipulation to a dedicated Verilog priority encoder and multiplexer, the entire $\mu$-law compression calculation was reduced to pure combinational logic. Utilizing the custom `muLaw` instruction allowed the calculation to be completed in **1 clock cycle**, representing a massive improvement in processing time and power efficiency.

## Technologies Used
*   **C / ARM Assembly:** Software implementation and optimization.
*   **Verilog:** Custom hardware datapath design.
*   **QEMU (ARMHF32):** Local 32-bit ARM virtual environment for testing and simulation.
*   **Python:** Scripting for WAV header repair and binary file extraction.