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
force sim:/DUT_tb/DUT/load 1 0 -cancel 10
run 100ns
force -freeze sim:/DUT_tb/DUT/load 1 {@ 300 ns} -cancel {@ 310 ns}
force -freeze sim:/DUT_tb/DUT/data_in 1 {@ 300 ns} -cancel {@ 310 ns}
run 300ns

#run ${SIMLEN}


####################################
# Procedure calls
####################################
printTxt "Hello world"
