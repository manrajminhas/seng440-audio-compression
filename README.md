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
*   **`fix_audio.py`**: Python utility script to repair WAV headers truncated by standard C file I/O operations.
*   **`fixed_tone.wav`**: The final audio file demonstrating the successful compression and decompression of the original voice sample, complete with the expected lossy acoustic characteristics.

## Performance Comparison
A critical component of this project was analyzing the performance improvements gained by migrating computational complexity from software to custom hardware.

*   **Software Implementation (`codec.c`):** 
    Utilized the `__builtin_clz` compiler intrinsic to optimize the process of finding the chord and step values. Despite this optimization, the loop required multiple bitwise shifts, masks, and branch instructions, resulting in a worst-case processing time of **25 clock cycles** per sample.
*   **Hardware Implementation (`tb_mulaw_custom.v` & `codec_hw.c`):** 
    By offloading the chord detection and bit manipulation to a dedicated Verilog priority encoder and multiplexer, the entire $\mu$-law compression calculation was reduced to pure combinational logic. Utilizing the custom `muLaw` instruction alongside register C specifiers allowed the calculation to be completed in **5 clock cycles**, representing a massive 5x improvement in processing time and power efficiency.

## Technologies Used
*   **C / ARM Assembly:** Software implementation and optimization.
*   **Verilog:** Custom hardware datapath design.
*   **Docker / QEMU (ARMHF32):** Local 32-bit ARM virtual environment for cross-compilation and simulation.
*   **Valgrind / Callgrind:** Dynamic instruction profiling.
*   **Python:** Scripting for WAV header repair and binary file extraction.

---

## How to Run the Project

### 1. Environment Setup (Docker)
Because this project targets a 32-bit ARM processor, it must be compiled and profiled within an ARM virtual environment. To launch an interactive ARM container with the project directory mounted, run the following from your host terminal:
```bash
docker run --rm -it -v "$PWD":/workspace -w /workspace/ARMHF32_VM --platform linux/arm/v7 ubuntu:20.04 /bin/bash
```
Once inside the container, install the necessary cross-compiler and profiling tools:
```bash
apt update && apt install -y gcc-arm-linux-gnueabihf valgrind
```

### 2. Compilation
Compile the baseline software implementation into a standalone executable:
```bash
arm-linux-gnueabihf-gcc -O2 codec.c -o codec
```
*Note: Because `codec_hw.c` utilizes the custom `mulaw` ISA extension, it requires the modified QEMU toolchain to compile into an executable without throwing an unrecognized instruction error. Standard GCC can generate its static assembly using the `-S` flag.*

### 3. Execution & Profiling (Software Baseline)
To compress and decompress the baseline audio file using the software codec, run:
```bash
./codec voice.wav output_soft.wav
```
To dynamically profile the execution and determine the exact instruction fetch count (Ir), execute the program via Valgrind's Callgrind tool:
```bash
valgrind --tool=callgrind ./codec voice.wav output_soft.wav
```
View the resulting `callgrind.out.[PID]` file to observe the ~28.8 million dynamic instruction fetches required for the 10-second audio clip.

### 4. Audio Header Repair
Standard C file I/O operations (`fread`/`fwrite`) often truncate the variable-length metadata injected into WAV headers by modern operating systems, which causes native media players to reject the file. To repair the output file's RIFF/WAVE header, exit the Docker container and run the Python repair script on your host machine:
```bash
python3 fix_audio.py output_soft.wav fixed_tone.wav
```
The resulting `fixed_tone.wav` file can now be played in any standard audio player (VLC, QuickTime, iTunes) to audit the lossy acoustic profile of the $\mu$-law algorithm.

### 5. Hardware Simulation
The custom combinational datapath can be independently verified using any standard HDL simulation tool (e.g., ModelSim, Vivado, or Icarus Verilog):
```bash
iverilog -o mulaw_sim tb_mulaw_custom.v
vvp mulaw_sim
```
