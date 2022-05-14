####################################
# Procedure 
####################################
proc printTxt {msg} {
    global now      #creates local variable linked to correponding global variables
    global UNITS    # note that UNITS can be accessed outside proc call 
    set UNITS ns
    echo @${now} ${UNITS}: $msg
    puts "@${now} ${UNITS}: ${msg}"
}

proc getScriptDirectory {} {
    set dispScriptFile [file normalize [info script]]
    set scriptFolder [file dirname $dispScriptFile]
    printTxt $scriptFolder
    return $scriptFolder
}

proc getArgs {} {
    global argv
    global 1
    global 2
    global 3
    global 4
    global 5
    global argc

    # WIP; argc doesnt exist
    set MSG "No arguements entered"
    if {$argc==0} {
        printTxt $MSG
    } else {

        set MSG "Number of arguments: "
        append MSG $argc
        append MSG "\nArguments are: "
        printTxt $MSG

        # Currently doesn't work
#        for {set i 0} {$i < $argc} {incr i} {
#             printTxt [lindex $argv $i]              
#        }

        foreach arg $argv {
            printTxt "inside foreach"
            printTxt $arg
        }
        
        # Modelsim does not allow argv simulator state variable, see microsemi doc
        switch $argc {
            1 {
                printTxt "Inside switch statement"
                printTxt "Arg1: $1"
            }
            2 {
                printTxt "Inside switch statement"
                printTxt "Arg1: $1"
                printTxt "Arg2: $2"
            }
            3 {
                printTxt "Inside switch statement"
                printTxt "Arg1: $1"
                printTxt "Arg2: $2"
                printTxt "Arg3: $3"
            }
        }

        printTxt "argv is: $argv"
    }

    # Same as above only using $1-9 & argv
#    set MSG "No arguements entered"
#    #issue w/argv
#    puts [llength $argv]
#    puts $argv
#
#
#        for {set i 1} {$i < 10} {incr i} {
#             set MSG  "arg $i: "              
#             append MSG ${$i}
#             printTxt $MSG
#        }
    

    # works w/global declaration
#    foreach arg $argv {
#        printTxt $arg
#    }

#    set argv $::argv
#    set argc $::argc
#
#    printTxt argv
#    printTxt argc

#    printTxt $1

}

####################################
# Identifiers
####################################
set SRC_DIR [getScriptDirectory]
set TB_MOD "DUT_tb"
set DUT "alu_simple_bugs_enc2"
set separator "============================================================="
set string "Running functional simulation of "
append string ${DUT}

####################################
# Compile 
####################################
onerror {resume}
transcript on

if {[file exists work]} {
    vdel -lib work -all
}

vlib work
vmap work work

# "-sv" option enables SV features & keywords; -work specifies logical name/pathname of lib to be mapped
vlog -sv -work work ${SRC_DIR}/../DUT/${DUT}.svp
vlog -sv -work work ${SRC_DIR}/${TB_MOD}.sv

# vsim -t 1ns -L work ${TB_MOD} 
vsim -t 1ns -L work $entity 
# -do "T1 T2 T3 # do option doesnt work"

do wave.do

####################################
# Simulation 
####################################
puts "\n\n\n\n\n\n\n\n"
echo \n\n\n\n\n\n\n\n

puts "\n\n"
echo \n\n
printTxt $separator
printTxt $string
printTxt $separator
puts "\n\n"
echo \n\n
# Use variable to keep track of time in simulation and easily iterate previous sequences
set curTime 0
set curTime [expr $curTime + 10]
run ${curTime}ns
getArgs
printTxt $architecture
printTxt $configuration
printTxt $entity
#printTxt $1
#printTxt $2
#printTxt $argc
#printTxt $curTime

# assert reset
force -deposit sim:/DUT_tb/DUT/reset 1 0
set curTime [expr $curTime + 20]
run @${curTime}ns 
# 30ns
#printTxt $curTime

# demonstrating force with deposit option; note: deposit will drive a value and hold it until it is overwritten by anything
# WIP: not sure if syntax works for abs time
force -deposit sim:/DUT_tb/DUT/alu_a_in 0 @${curTime}ns 
set curTime [expr $curTime + 5]
force -deposit sim:/DUT_tb/DUT/alu_b_in 0 @${curTime}ns 
set curTime [expr $curTime + 5]
force -deposit sim:/DUT_tb/DUT/alu_opcode_in 0 @${curTime}ns 

# force -deposit sim:/DUT_tb/DUT/alu_a_in 0 {@30ns}
# force -deposit sim:/DUT_tb/DUT/alu_b_in 0 {@35ns}
# force -deposit sim:/DUT_tb/DUT/alu_opcode_in 0 {@40ns}
# run {@ 50 ns}

run {@200ns}
force -deposit sim:/DUT_tb/DUT/reset 0 
force -deposit sim:/DUT_tb/DUT/alu_a_in 8'd5 
force -deposit sim:/DUT_tb/DUT/alu_b_in 8'd4 
set string "Deasserting reset, running simulation for addition"
puts "\n\n"
echo \n\n
printTxt $separator
printTxt $string
printTxt $separator
puts "\n\n"
echo \n\n
printTxt "simple case"

# freeze will drive a value that cannot be overriden by simulation
force -freeze sim:/DUT_tb/DUT/alu_a_in 8'hff {@210ns}
force -freeze sim:/DUT_tb/DUT/alu_b_in 8'hff {@210ns}
run {@210ns}
# note: printTxt() displays instantly; need to print after run statement
printTxt "Carry out asserted case" 

# This will overwrite the freeze BUT cannot do from tb
# force -deposit sim:/DUT_tb/DUT/alu_a_in 8'd5 {@220ns} 
# force -deposit sim:/DUT_tb/DUT/alu_b_in 8'd4 {@220ns}

force -freeze sim:/DUT_tb/DUT/alu_a_in 8'h0 {@220ns}
force -freeze sim:/DUT_tb/DUT/alu_b_in 8'h0 {@220ns}
force -freeze sim:/DUT_tb/DUT/alu_a_in 8'd15 {@230ns}
force -freeze sim:/DUT_tb/DUT/alu_b_in 8'h15 {@230ns}
force -freeze sim:/DUT_tb/DUT/alu_a_in 8'h0 {@240ns}
force -freeze sim:/DUT_tb/DUT/alu_b_in 8'h0 {@240ns}
run {@250ns}

puts "\n\n"
echo \n\n
set string "Running simulation for multiplication"
printTxt $separator
printTxt $string
printTxt $separator
puts "\n\n"
echo \n\n

force sim:/DUT_tb/DUT/alu_a_in 8'h4 {@280ns}
force sim:/DUT_tb/DUT/alu_b_in 8'h4 {@280ns}
force sim:/DUT_tb/DUT/alu_opcode_in 4'd2 {@250ns}
run {@280ns}
printTxt "simple case"
force sim:/DUT_tb/DUT/alu_a_in 8'h0 {@320ns}
force sim:/DUT_tb/DUT/alu_b_in 8'h0 {@320ns}
run {@350ns}

force sim:/DUT_tb/DUT/alu_a_in 8'hFF {@350ns}
force sim:/DUT_tb/DUT/alu_b_in 8'hFF {@350ns}
force sim:/DUT_tb/DUT/alu_opcode_in 4'd2 {@350ns}
run {@350ns}
printTxt "simple case"
force sim:/DUT_tb/DUT/alu_a_in 8'h0 {@375ns}
force sim:/DUT_tb/DUT/alu_b_in 8'h0 {@375ns}
force sim:/DUT_tb/DUT/alu_opcode_in 4'd0 {@375ns}
run {@375ns}
force sim:/DUT_tb/DUT/alu_a_in 8'h0 0
force sim:/DUT_tb/DUT/alu_b_in 8'h0 0
run {@420ns}

puts "\n\n"
echo \n\n
set string "Running simulation for division"
printTxt $separator
printTxt $string
printTxt $separator
puts "\n\n"
echo \n\n

force sim:/DUT_tb/DUT/alu_a_in 8'h0F 0
force sim:/DUT_tb/DUT/alu_b_in 8'h03 0
force sim:/DUT_tb/DUT/alu_opcode_in 4'd3 0 
run {@430ns}
printTxt "simple case"
force sim:/DUT_tb/DUT/alu_a_in 8'h0 0
force sim:/DUT_tb/DUT/alu_b_in 8'h1 0
force sim:/DUT_tb/DUT/alu_a_in 8'h08 {@450ns} 
force sim:/DUT_tb/DUT/alu_b_in 8'h04 {@450ns}
run {@510ns}
printTxt "complex case"
force sim:/DUT_tb/DUT/alu_a_in 8'hFF 0
force sim:/DUT_tb/DUT/alu_b_in 8'h25 0
run {@600ns}
