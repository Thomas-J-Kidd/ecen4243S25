# Source Code Organization

The RISC-V single cycle processor implementation is organized into a modular directory structure that separates components by their functionality.

## Directory Structure

```mermaid
graph TD
    src[src/] --> common[common/]
    src --> core[core/]
    src --> memory[memory/]
    src --> pkg[riscv_pkg.sv]
    src --> rsingle[riscv_single.sv]
    src --> top[top.sv]
    
    common --> adder[adder.sv]
    common --> mux[mux.sv]
    common --> flopr[flopr.sv]
    
    core --> alu[alu.sv]
    core --> regfile[regfile.sv]
    core --> extend[extend.sv]
    core --> ctrl[controller.sv]
    core --> dp[datapath.sv]
    
    memory --> mem[mem.sv]
```

## Module Dependencies

```mermaid
graph TB
    subgraph Source Files
        direction TB
        
        subgraph Common Components
            adder[adder.sv]
            mux[mux.sv]
            flopr[flopr.sv]
        end
        
        subgraph Core Components
            alu[alu.sv]
            regfile[regfile.sv]
            extend[extend.sv]
            controller[controller.sv]
            datapath[datapath.sv]
        end
        
        subgraph Memory Components
            mem[mem.sv]
        end
        
        pkg[riscv_pkg.sv]
        top[top.sv]
        riscv[riscv_single.sv]
    end
    
    pkg --> |"types"| controller
    pkg --> |"types"| datapath
    
    controller --> riscv
    datapath --> riscv
    
    adder --> datapath
    mux --> datapath
    flopr --> datapath
    
    alu --> datapath
    regfile --> datapath
    extend --> datapath
    
    riscv --> top
    mem --> |"imem, dmem"| top
```

## Component Descriptions

### Common Components
- **adder.sv**: Simple 32-bit adder used for PC increment and branch target calculation
- **mux.sv**: Multiplexer modules (2-to-1 and 3-to-1) for data selection
- **flopr.sv**: Flip-flops with synchronous reset for state storage

### Core Components
- **alu.sv**: Arithmetic Logic Unit implementing RISC-V arithmetic and logical operations
- **regfile.sv**: Register File with 32 registers, dual read ports, and single write port
- **extend.sv**: Sign extension unit for different instruction formats
- **controller.sv**: Main control unit including instruction decoder and ALU control
- **datapath.sv**: Main datapath connecting all components and implementing data flow

### Memory Components
- **mem.sv**: Instruction and data memory modules (imem and dmem)

### Top-Level Files
- **riscv_pkg.sv**: Package containing common type definitions and parameters
- **riscv_single.sv**: Top-level processor module connecting controller and datapath
- **top.sv**: System top-level including processor and memories

## Key Interfaces

### Datapath-Controller Interface
```mermaid
graph LR
    subgraph Controller
        maindec[Main Decoder]
        aludec[ALU Decoder]
    end
    
    subgraph Datapath
        alu[ALU]
        regfile[Register File]
        pclogic[PC Logic]
    end
    
    maindec --> |RegWrite| regfile
    maindec --> |PCSrc| pclogic
    maindec --> |ALUSrc| alu
    aludec --> |ALUControl| alu
```

### Memory Interface
```mermaid
graph LR
    subgraph Processor
        pc[PC]
        alu[ALU]
        regfile[Register File]
    end
    
    subgraph Memory
        imem[Instruction Memory]
        dmem[Data Memory]
    end
    
    pc --> |address| imem
    imem --> |instruction| Processor
    alu --> |address| dmem
    regfile --> |write data| dmem
    dmem --> |read data| regfile
