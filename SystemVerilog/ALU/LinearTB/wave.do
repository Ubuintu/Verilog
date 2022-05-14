onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /DUT_tb/DUT/clk
add wave -noupdate -radix binary /DUT_tb/DUT/reset
add wave -noupdate -radix hexadecimal /DUT_tb/DUT/alu_a_in
add wave -noupdate -radix hexadecimal /DUT_tb/DUT/alu_b_in
add wave -noupdate /DUT_tb/DUT/alu_opcode_in
add wave -noupdate -radix hexadecimal /DUT_tb/DUT/alu_y_out
add wave -noupdate -radix binary /DUT_tb/DUT/alu_co_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {90 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {949 ns}
