####################################
# Variables here
####################################
set SIMLEN 1000ns
set UNITS 

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

####################################
# Main 
####################################
onerror {resume}
transcript on

if {[file exists rtl_work]} {
    vdel -lib rtl_work -all
}

vlib rtl_work
vmap work rtl_work

vlog -sv -work work DUT.v
vlog -sv -work work DUT_tb.sv

vsim -t 1ns -L work DUT_tb

do waveCNT.do

####################################
# Simulation 
####################################
echo \n\n\n\n
puts "\n\n\n\n"

# Should try force -deposit when MS gives redline initially
# relative time
# !!! MS doesn't like comments in the same line as assignment
force sim:/DUT_tb/DUT/load 1 0 -cancel 10 
run 100ns
# abs time
force -freeze sim:/DUT_tb/DUT/load 1 {@ 300 ns} -cancel {@ 310 ns} 
force -freeze sim:/DUT_tb/DUT/data_in 1 {@ 300 ns} -cancel {@ 310 ns}
run 300ns
# cur time is 410
#force DUT_tb/DUT/load 1 {@ 410 ns}, 0 {@ 420 ns} -repeat 200 -cancel {@ 1000 ns} //force option doesn't like abs time
force DUT_tb/DUT/load 1 0, 0 10 -repeat 200 -cancel {@ 1000 ns}
run 600ns

#run ${SIMLEN}


####################################
# Procedure calls
####################################
printTxt "Hello world"
