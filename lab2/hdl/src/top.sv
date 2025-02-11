// Top level module and testbench for RISC-V Single Cycle Processor

`timescale 1ns/1ps

module top
   (input  logic        clk,
    input  logic        reset,
    output logic [31:0] WriteData,
    output logic [31:0] DataAdr,
    output logic        MemWrite);
   
    logic [31:0] PC, Instr, ReadData;
   
    // Instantiate processor and memories
    riscvsingle rv32single
      (.clk(clk),
       .reset(reset),
       .PC(PC),
       .Instr(Instr),
       .MemWrite(MemWrite),
       .ALUResult(DataAdr),
       .WriteData(WriteData),
       .ReadData(ReadData));

    imem imem
      (.a(PC),
       .rd(Instr));

    dmem dmem
      (.clk(clk),
       .we(MemWrite),
       .a(DataAdr),
       .wd(WriteData),
       .rd(ReadData));
   
endmodule

module testbench;

    logic        clk;
    logic        reset;
    logic [31:0] WriteData;
    logic [31:0] DataAdr;
    logic        MemWrite;

    // Instantiate device to be tested
    top dut
      (.clk(clk),
       .reset(reset),
       .WriteData(WriteData),
       .DataAdr(DataAdr),
       .MemWrite(MemWrite));

    initial begin
        string memfilename;
        memfilename = "riscvtest.memfile";  // Use local path
        $readmemh(memfilename, dut.imem.RAM);
    end

    // Initialize test
    initial begin
        reset = 1;
        #22;
        reset = 0;
    end

    // Generate clock to sequence tests
    always begin
        clk = 1;
        #5;
        clk = 0;
        #5;
    end

    // Check results
    always @(negedge clk) begin
        if(MemWrite) begin
            if(DataAdr === 100 & WriteData === 25) begin
                $display("Simulation succeeded");
                $stop;
            end 
            else if (DataAdr !== 96) begin
                $display("Simulation failed");
                $stop;
            end
        end
    end

endmodule
