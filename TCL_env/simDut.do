####################################
# Variables here
####################################
set SIMLEN 1000ns

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

printTxt $UNITS
run ${SIMLEN}



####################################
# Procedure calls
####################################
echo \n
puts "\n"
printTxt "Hello world"
