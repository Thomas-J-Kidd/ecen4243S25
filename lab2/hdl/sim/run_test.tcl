# TCL script for running RISC-V instruction tests

proc list_tests {} {
    puts "\nAvailable Tests:"
    puts "================"
    
    # Get list of memfiles from testing directory
    set tests [glob -nocomplain ../../testing/*.memfile]
    set i 1
    foreach test $tests {
        set basename [file rootname [file tail $test]]
        # Remove .memfile extension and print with index
        puts [format "%3d: %s" $i $basename]
        incr i
    }
    puts ""
}

proc run_test {test_name} {
    global env
    set batch_mode [info exists env(BATCH_MODE)]

    # Clean up any previous files
    if {[catch {quit -sim}]} {}
    file delete -force work
    file delete -force transcript
    file delete -force vsim.wlf
    
    # Copy the selected test memfile
    if {[catch {file copy -force ../../testing/$test_name.memfile riscvtest.memfile} err]} {
        puts "\nError copying test file: $err"
        return
    }

    # Copy wave.do for instruction decoding
    if {!$batch_mode} {
        if {[catch {file copy -force ../wave.do .} err]} {
            puts "\nWarning copying wave.do: $err"
        }
    }

    # Create work directory
    file mkdir work

    # Create and map work library
    vlib work
    vmap work work

    # Compile all source files
    set source_files {
        "../src/riscv_pkg.sv"
        "../src/common/adder.sv"
        "../src/common/mux.sv"
        "../src/common/flopr.sv"
        "../src/core/alu.sv"
        "../src/core/regfile.sv"
        "../src/core/extend.sv"
        "../src/core/controller.sv"
        "../src/core/datapath.sv"
        "../src/memory/mem.sv"
        "../src/riscv_single.sv"
        "../src/top.sv"
    }

    foreach file $source_files {
        if {[catch {vlog -work work -sv $file} err]} {
            puts "\nError compiling $file: $err"
            return
        }
    }

    # Start simulation
    if {[catch {vsim -quiet -debugdb -voptargs=+acc work.testbench} err]} {
        puts "\nError starting simulation: $err"
        return
    }

    # Setup waves and windows only in GUI mode
    if {!$batch_mode} {
        # Load instruction decoding
        if {[catch {do wave.do} err]} {
            puts "\nWarning loading wave.do: $err"
        }

        # Add waves with better organization
        add wave -noupdate -divider -height 32 "Top"
        add wave -hex /testbench/dut/*

        add wave -noupdate -divider -height 32 "Instructions"
        add wave -noupdate -expand -group Instructions /testbench/dut/rv32single/reset
        add wave -noupdate -expand -group Instructions -color {Orange Red} /testbench/dut/rv32single/PC
        add wave -noupdate -expand -group Instructions -color Orange /testbench/dut/rv32single/Instr
        add wave -noupdate -expand -group Instructions -color Orange -radix Instructions /testbench/dut/rv32single/Instr

        add wave -noupdate -divider -height 32 "Datapath"
        add wave -hex /testbench/dut/rv32single/dp/*

        add wave -noupdate -divider -height 32 "Control"
        add wave -hex /testbench/dut/rv32single/c/*

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

        # Add schematic view
        add schematic -full sim:/testbench/dut/rv32single
    }

    # Load memory file into instruction memory
    if {[catch {
        mem load -infile riscvtest.memfile -format hex /testbench/dut/imem/RAM
    } err]} {
        puts "\nWarning loading memory file: $err"
    }

    # Run simulation
    puts "\nRunning simulation..."
    run 300ns

    # Display final status
    puts "\nSimulation completed"

    # In GUI mode, don't return to the menu immediately
    if {!$batch_mode} {
        puts "\nSimulation is ready for interaction."
        puts "Use the GUI to examine waves and debug."
        puts "Type 'return' in the transcript window when done to return to the menu."
        
        # Create a temporary procedure for the user to return to the menu
        proc ::return {} {
            rename ::return ""
            resume
        }
        
        # Pause the script execution but keep GUI responsive
        pause
    }
}

# Main menu
proc show_menu {} {
    puts "\nRISC-V Instruction Test Interface"
    puts "================================"
    puts "1. List available tests"
    puts "2. Run a specific test"
    puts "3. Exit"
    puts "\nEnter your choice (1-3): "
    flush stdout
}

# Set batch mode environment variable if -c flag is present
if {[lsearch $argv "-c"] != -1} {
    set env(BATCH_MODE) 1
}

# Main loop
while {1} {
    if {[catch {
        show_menu
        gets stdin choice

        switch $choice {
            1 {
                list_tests
            }
            2 {
                puts "\nEnter test name (e.g., add, slli, beq): "
                flush stdout
                gets stdin test_name
                if {[file exists ../../testing/$test_name.memfile]} {
                    puts "\nRunning test: $test_name"
                    run_test $test_name
                } else {
                    puts "\nError: Test '$test_name' not found"
                }
            }
            3 {
                puts "\nExiting..."
                exit
            }
            default {
                puts "\nInvalid choice. Please try again."
            }
        }
    } err]} {
        puts "\nError: $err"
        puts "Continuing..."
    }
}
