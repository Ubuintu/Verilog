onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /DUT_tb/clk
add wave -noupdate -radix binary /DUT_tb/rst
add wave -noupdate -radix unsigned /DUT_tb/DUT/data_in
add wave -noupdate -radix binary /DUT_tb/DUT/load
add wave -noupdate -radix unsigned /DUT_tb/DUT/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {126 ns}
