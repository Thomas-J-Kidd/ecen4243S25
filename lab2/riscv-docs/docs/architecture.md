# Processor Architecture

This page details the architecture of our RISC-V Single Cycle processor implementation through various diagrams.

## Module Hierarchy

The following diagram shows the hierarchical structure of the processor modules:

```docusaurus
graph TD
    A[top] --> B[riscvsingle]
    A --> C[imem]
    A --> D[dmem]
    B --> E[controller]
    B --> F[datapath]
    E --> G[maindec]
    E --> H[aludec]
    F --> I[flopr]
    F --> J[adder]
    F --> K[regfile]
    F --> L[extend]
    F --> M[alu]
    F --> N[mux2]
    F --> O[mux3]
```

## Module Interconnections

The following diagram shows how the modules are connected and how data flows between them:

```mermaid
graph TB
    subgraph TOP[top]
        direction TB
        
        subgraph RISCV[riscvsingle]
            direction TB
            
            subgraph CTRL[controller]
                MAINDEC[maindec]
                ALUDEC[aludec]
                MAINDEC -->|ALUOp| ALUDEC
            end
            
            subgraph DP[datapath]
                PC[Program Counter<br/>flopr]
                PCADD4[PC+4 Adder<br/>adder]
                PCADDBR[PC Branch Adder<br/>adder]
                PCMUX[PC MUX<br/>mux2]
                RF[Register File<br/>regfile]
                EXT[Extend<br/>extend]
                SRCBMUX[SrcB MUX<br/>mux2]
                ALU[ALU]
                RESMUX[Result MUX<br/>mux3]
                
                PC -->|PC| PCADD4
                PC -->|PC| PCADDBR
                PCADD4 -->|PCPlus4| PCMUX
                PCADDBR -->|PCTarget| PCMUX
                PCMUX -->|PCNext| PC
                
                RF -->|SrcA| ALU
                RF -->|WriteData| SRCBMUX
                EXT -->|ImmExt| SRCBMUX
                SRCBMUX -->|SrcB| ALU
                
                ALU -->|ALUResult| RESMUX
                PCADD4 -->|PCPlus4| RESMUX
            end
            
            CTRL -->|Control Signals| DP
        end
        
        IMEM[Instruction Memory<br/>imem]
        DMEM[Data Memory<br/>dmem]
        
        IMEM -->|Instr| RISCV
        RISCV -->|MemWrite, DataAdr| DMEM
        RISCV -->|WriteData| DMEM
        DMEM -->|ReadData| RISCV
    end
```

## Control Signals

The following control signals orchestrate the operation of the processor:

- **ResultSrc[1:0]**: Selects the result to write back to register file
  - 00: ALU Result
  - 01: Memory Read Data
  - 10: PC + 4

- **ImmSrc[1:0]**: Selects immediate extension type
  - 00: I-type
  - 01: S-type (stores)
  - 10: B-type (branches)
  - 11: J-type (jal)

- **ALUControl[2:0]**: Controls ALU operation
  - 000: Add
  - 001: Subtract
  - 010: AND
  - 011: OR
  - 101: SLT

- **ALUSrc**: Selects second ALU input
  - 0: Register
  - 1: Immediate

- **MemWrite**: Controls memory write
  - 0: Read
  - 1: Write

- **RegWrite**: Controls register file write
  - 0: No Write
  - 1: Write

- **PCSrc**: Selects next PC
  - 0: PC + 4
  - 1: Branch Target

- **Jump**: Indicates jump instruction
  - 0: Not Jump
  - 1: Jump
