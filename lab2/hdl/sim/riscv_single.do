# Create work library
if [file exists work] {
    vdel -all
}
vlib work

# Copy memory file to simulation directory
if {![file exists riscvtest.memfile]} {
    file copy ../../riscvtest/riscvtest.memfile .
}

# Copy wave.do for instruction decoding
if {![file exists wave.do]} {
    file copy ../wave.do .
}

# Compile all source files
vlog -sv ../src/riscv_pkg.sv
vlog -sv ../src/common/adder.sv
vlog -sv ../src/common/mux.sv
vlog -sv ../src/common/flopr.sv
vlog -sv ../src/core/alu.sv
vlog -sv ../src/core/regfile.sv
vlog -sv ../src/core/extend.sv
vlog -sv ../src/core/controller.sv
vlog -sv ../src/core/datapath.sv
vlog -sv ../src/memory/mem.sv
vlog -sv ../src/riscv_single.sv
vlog -sv ../src/top.sv

# Start simulation
vsim -debugdb -voptargs=+acc work.testbench

# Load instruction decoding
do wave.do

# Add waves with better organization
add wave -noupdate -divider -height 32 "Top"
add wave -hex /testbench/dut/*

add wave -noupdate -divider -height 32 "Instructions"
add wave -noupdate -expand -group Instructions /testbench/dut/rv32single/reset
add wave -noupdate -expand -group Instructions -color {Orange Red} /testbench/dut/rv32single/PC
add wave -noupdate -expand -group Instructions -color Orange /testbench/dut/rv32single/Instr
add wave -noupdate -expand -group Instructions -color Orange -radix Instructions /testbench/dut/rv32single/Instr
add wave -noupdate -expand -group Instructions -color Orange /testbench/dut/rv32single/dp/Instr
add wave -noupdate -expand -group Instructions -color Orange -radix Instructions /testbench/dut/rv32single/dp/Instr

add wave -noupdate -divider -height 32 "Datapath"
add wave -hex /testbench/dut/rv32single/dp/*

add wave -noupdate -divider -height 32 "Control"
add wave -hex /testbench/dut/rv32single/c/*

add wave -noupdate -divider -height 32 "Main Decoder"
add wave -hex /testbench/dut/rv32single/c/md/*

add wave -noupdate -divider -height 32 "ALU Decoder"
add wave -hex /testbench/dut/rv32single/c/ad/*

add wave -noupdate -divider -height 32 "Data Memory"
add wave -hex /testbench/dut/dmem/*

add wave -noupdate -divider -height 32 "Instruction Memory"
add wave -hex /testbench/dut/imem/*

add wave -noupdate -divider -height 32 "Register File"
add wave -hex /testbench/dut/rv32single/dp/rf/*
add wave -hex /testbench/dut/rv32single/dp/rf/rf

# Configure wave window
TreeUpdate [SetDefaultTree]
WaveRestoreZoom {0 ps} {200 ns}
configure wave -namecolwidth 250
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

# Run simulation
run 300ns

# Add schematic view
add schematic -full sim:/testbench/dut/rv32single
