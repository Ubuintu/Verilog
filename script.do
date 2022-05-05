proc printTxt { msg } {
    global now
    echo $now : $msg
}

proc getScriptDirectory {} {
    set dispScriptFile [file normalize [info script]]
    set scriptFolder [file dirname $dispScriptFile]
    printTxt $scriptFolder
    return $scriptFolder
}

set SIM_LEN 100000ns
set SRC_DIR [getScriptDirectory]
set TB_MOD "DUT_tb"
set DUT "button_conditioner"

onerror {resume}
transcript on

if {[file exists rtl_work]} {
    vdel -lib rtl_work -all
}

vlib rtl_work
vmap work rtl_work

vlog -sv -work work ${SRC_DIR}/${TB_MOD}.sv
vlog -sv -work work ${SRC_DIR}/${DUT}.v

vsim -t 1ns -L work ${TB_MOD}

do waveBTNCON.do

printTxt "Hello World"
printTxt [getScriptDirectory]

run ${SIM_LEN}
