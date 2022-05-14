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

####################################
# Variables here
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

vsim -t 1ns -L work ${TB_MOD}

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
#printTxt $curTime

# assert reset
force -deposit sim:/DUT_tb/DUT/reset 1 0
set curTime [expr $curTime + 20]
run {@${curTime}ns} 
# 30ns
#printTxt $curTime

# demonstrating force with deposit option; note: deposit will drive a value and hold it until it is overwritten by anything
# WIP; currently doesnt like the lines 76-80
## force -deposit sim:/DUT_tb/DUT/alu_a_in 0 {@${curTime}ns} 
## set curTime [expr $curTime + 5]
## force -deposit sim:/DUT_tb/DUT/alu_b_in 0 {@${curTime}ns} 
## set curTime [expr $curTime + 5]
## force -deposit sim:/DUT_tb/DUT/alu_opcode_in 0 {@${curTime}ns} 
force -deposit sim:/DUT_tb/DUT/alu_a_in 0 {@30ns}
force -deposit sim:/DUT_tb/DUT/alu_b_in 0 {@35ns}
force -deposit sim:/DUT_tb/DUT/alu_opcode_in 0 {@40ns}
run {@ 50 ns}

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
force sim:/DUT_tb/DUT/alu_opcode_in 4'd2 {@280ns}
run {@280ns}
printTxt "simple case"
force sim:/DUT_tb/DUT/alu_a_in 8'h0 {@320ns}
force sim:/DUT_tb/DUT/alu_b_in 8'h0 {@320ns}
run {@350ns}
