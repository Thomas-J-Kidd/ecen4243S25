OSU ECEN 4243 - Computer Architecture - Spring 2025

Lab 2: Single-Cycle RISC-V Microarchitecture Implementation in SystemVerilog HDL

Assigned: Monday 2/17Due: Monday 3/10 (midnight)Instructor: James E. Stine, Jr.

1. Introduction

In this lab, you will implement a RISC-V processor using a hardware description language (SystemVerilog). The microarchitecture of the RISC-V RV32I machine is single-cycle, a simple microarchitecture that we covered in class.

The objective of this lab is to understand the issues related to implementing a single-cycle RISC-V processor in hardware. You will use SystemVerilog for modeling and gain insights into how instruction set architecture choices affect hardware performance.

For full credit, you must:

Implement a single-cycle RISC-V RV32I machine in SystemVerilog.

Verify correctness through simulation and register dump comparisons.

Implement your design on the National Instruments Elvis III and DSDB boards using the onboard DDR3 memory controller.

2. Specifications of the RISC-V RV32I Machine

2.1 Instruction Set Architecture

The machine must support the following RISC-V RV32I instructions:

add  addi  andi  and  auipc
beq  bge  bgeu  blt  bltu
bne  jalr  jal  lb  lbu
lh  lhu  lui  lw  or
ori  sb  sh  sll  slli
slt  slti  sltiu  sltu  sra
srai  srl  srli  sub  sw
xor  xori

2.2 PC Fetch

Similar to Lab 1, the PC register follows the PC + 4 offset rule. If the last executed instruction is at 0x8000_0020, the PC should update to 0x8000_0024. Branch and jump instructions should store the next instruction address.

2.3 Microarchitecture

The machine has a single-cycle microarchitecture where each instruction executes in one cycle.

The architectural state (excluding memory) is stored in general-purpose registers.

The clock (clk) is a global logic definition that synchronizes all register updates.

Registers capture input values on the rising clock edge and store them until the next clock edge.

The output of registers feeds into a combinational logic circuit to generate control signals.

The provided SystemVerilog model follows a Princeton architecture and loads code through a DO file.

3. Behavioral Memory for Simulation

Memory is stored as bytes and follows a Harvard architecture (separate instruction and data memory).

Memory is little-endian.

The provided SystemVerilog DO file loads the program into memory.

Running the sample program should write 7 to memory address 100.

The simulation starts by modifying riscv_single.do to load the test program.

4. Synthesis and Implementation on the National Instruments ELVIS III Board

The architecture will be implemented on the National Instruments Virtual Implementation Suite (NI ELVIS III) board with an add-on DSDB board containing:

A Xilinx Zynq-7Z020 FPGA

Two Micron DDR3 memory components (512 MB total)

4.1 Memory Interfacing

DDR3 memory uses a memory controller that operates asynchronously.

Memory transfers use a handshake protocol with MStrobe (start signal) and PReady (completion signal).

The processor must stall while waiting for memory.

Modify the RISC-V control logic to integrate these memory signals.

4.2 Synthesis Process

The synthesis process involves:

Block Generation →

Synthesis →

Implementation →

Generate Bitstream

Use RTL or structural coding practices.

Avoid behavioral implementations.

Debug thoroughly before synthesizing.

Errors during synthesis halt the process, and logs provide guidance.

Upload the final bitstream to the FPGA using Vivado’s hardware manager.

5. Lab Resources

Source code is available in the GitHub repository.

SystemVerilog reference: Harris/Harris Digital Design and Computer Architecture (RISC-V Edition).

Additional references in Canvas.

Avoid using unverified online code snippets.

6. Getting Started & Tips

Skeleton Implementation: riscv_single.sv already implements 13 instructions:

add, addi, and, andi, beq, jal, lw, or, ori, slt, slti, sub, sw

Use these as references to extend functionality.

Run Simulation:

vsim -do riscv_single.do

Verify Correctness:

Compare register dumps against reference outputs.

Incremental Approach:

Add and test one instruction at a time.

Implement datapath functionality before control logic.

Performance Analysis:

Run test_hw.S on the ELVIS III board.

Compare execution time across different memory designs.

6.1 Debugging Tips

Start early. This lab requires time to complete.

Use Slack to ask questions.

Analyze R-type instructions first.

Review simulation logs carefully.

Understand signed/unsigned handling in SystemVerilog.

Modify DO files to track specific signals.

Ensure memory accesses are properly aligned.

7. Handin

Submit your SystemVerilog code on Canvas.

Ensure code is readable and well-documented.

Include test cases in an inputs/ subdirectory.

Provide a README for additional implementation details.

Your code must correctly simulate all required instructions.

8. Extra Credit

Additional features may be implemented for extra credit if the baseline project is completed.

References

L. H. Crockett et al., The Zynq Book: Embedded Processing with the Arm Cortex-A9 on the Xilinx Zynq-7000 All Programmable SoC, 2014.

S. Harris & D. Harris, Digital Design and Computer Architecture, RISC-V Edition, Elsevier Science, 2021.

D. Harris et al., RISC-V System-On-Chip Design, Elsevier Science, 2025.


