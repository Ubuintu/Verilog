set SIMLEN 1000ns

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

run ${SIMLEN}
