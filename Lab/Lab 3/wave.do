onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /testbench/cpu/clk
add wave -noupdate -radix decimal /testbench/cpu/PC
add wave -noupdate /testbench/cpu/Instr
add wave -noupdate /testbench/cpu/processor/ALUResult
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1325 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 144
configure wave -valuecolwidth 284
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {4637 ps} {5230 ps}
