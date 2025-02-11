# Simulation Guide

This guide explains how to simulate the RISC-V single cycle processor using ModelSim/QuestaSim.

## Test Interface Modes

The test interface can be run in two modes:

### GUI Mode
```bash
cd hdl/sim
vsim -do run_test.tcl
```
- Provides wave window visualization
- Shows schematic view
- Interactive debugging capabilities
- Type 'return' in transcript to return to menu

### Batch Mode
```bash
cd hdl/sim
vsim -do run_test.tcl -c
```
- Command-line only
- Faster execution
- Suitable for automated testing

## Memory Organization

The processor uses two memory modules:
- Instruction Memory (1024 x 32-bit words)
- Data Memory (1024 x 32-bit words)

Memory Map:
```
Instruction Memory:
0x00000000 - 0x00000FFC: Program Storage (1024 words)

Data Memory:
0x00000000 - 0x00000FFC: Data Storage (1024 words)
```

## Using the Interface

The interface provides three options:

```mermaid
graph TD
    A[Main Menu] --> B[1. List Tests]
    A --> C[2. Run Test]
    A --> D[3. Exit]
    
    B --> E[Shows available instruction tests]
    C --> F[Prompts for test name]
    F --> G[Runs selected test]
    D --> H[Exits interface]
```

### GUI Mode Workflow

```mermaid
graph TD
    A[Start Test] --> B[Load Memory]
    B --> C[Setup Waves]
    C --> D[Run Simulation]
    D --> E[Examine Results]
    E --> F[Debug if needed]
    F --> G[Type 'return' when done]
    G --> H[Back to Menu]
```

### Batch Mode Workflow

```mermaid
graph TD
    A[Start Test] --> B[Load Memory]
    B --> C[Run Simulation]
    C --> D[Check Results]
    D --> E[Back to Menu]
```

## Available Tests

The testing directory includes tests for all implemented RV32I instructions:

```mermaid
graph TD
    subgraph Arithmetic
        add[add]
        addi[addi]
        sub[sub]
    end
    
    subgraph Logical
        and[and/andi]
        or[or/ori]
        xor[xor/xori]
    end
    
    subgraph Shifts
        sll[sll/slli]
        srl[srl/srli]
        sra[sra/srai]
    end
    
    subgraph Memory
        load[lb/lh/lw/lbu/lhu]
        store[sb/sh/sw]
    end
    
    subgraph Branches
        beq[beq]
        bne[bne]
        blt[blt/bge]
        bltu[bltu/bgeu]
    end
    
    subgraph Other
        lui[lui]
        auipc[auipc]
        jal[jal]
        jalr[jalr]
    end
```

## GUI Mode Features

When running in GUI mode, you get access to:

### Wave Window Organization
```mermaid
graph TD
    subgraph Wave Window
        top[Top Level Signals]
        inst[Instructions]
        dp[Datapath Signals]
        ctrl[Control Signals]
        md[Main Decoder]
        alud[ALU Decoder]
        dmem[Data Memory]
        imem[Instruction Memory]
        rf[Register File]
    end

    inst --> decoded[Decoded Instructions]
    inst --> raw[Raw Instructions]
    
    dp --> alu[ALU Signals]
    dp --> pc[PC Logic]
    dp --> ext[Immediate Extension]
```

### Interactive Debug Features
- Pause/Resume simulation
- Examine waves at any point
- View schematic diagram
- Check register contents
- Monitor memory values

## Common Issues and Solutions

1. Test Not Found
   - Verify test name matches exactly (e.g., "add" not "ADD")
   - Check if memfile exists in testing directory
   - Ensure proper file permissions

2. Wave Window Issues (GUI Mode)
   - Use View -> Wave if window not visible
   - Reset zoom with right-click -> Zoom -> Full
   - Add signals manually if needed

3. GUI Mode Navigation
   - Use 'return' command to go back to menu
   - Wave window remains interactive
   - Can run multiple tests sequentially

4. Memory File Issues
   - Memory files must be hex format
   - Maximum 1024 words per memory
   - Word-aligned addresses only

## Tips for Effective Testing

1. GUI Mode Best Practices
   - Examine waves after simulation
   - Use schematic view for signal tracing
   - Type 'return' when done examining
   - Clear workspace between tests

2. Batch Mode Best Practices
   - Good for quick verification
   - Check console output for results
   - Use for regression testing
   - Faster execution time

3. Understanding Test Results
   - Success: Test writes expected value
   - Failure: Wrong value or address
   - Timeout: Simulation reaches 300ns

4. Memory Usage
   - 1024 words available for instructions
   - 1024 words available for data
   - Word-aligned access only
   - Addresses in hex format
