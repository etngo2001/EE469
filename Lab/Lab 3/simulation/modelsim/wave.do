onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/cpu/processor/clk
add wave -noupdate /testbench/cpu/processor/rst
add wave -noupdate -radix decimal /testbench/cpu/processor/PCF
add wave -noupdate /testbench/cpu/processor/CondE
add wave -noupdate /testbench/cpu/processor/InstrD
add wave -noupdate /testbench/cpu/processor/FlushD
add wave -noupdate /testbench/cpu/processor/FlushE
add wave -noupdate /testbench/cpu/processor/StallD
add wave -noupdate /testbench/cpu/processor/StallF
add wave -noupdate -radix decimal /testbench/cpu/processor/SrcAE
add wave -noupdate -radix decimal /testbench/cpu/processor/SrcBE
add wave -noupdate -radix decimal /testbench/cpu/processor/ResultW
add wave -noupdate -radix decimal /testbench/cpu/processor/ALUResultM
add wave -noupdate /testbench/cpu/processor/ForwardAE
add wave -noupdate /testbench/cpu/processor/ForwardBE
add wave -noupdate -radix decimal -childformat {{{/testbench/cpu/processor/u_reg_file/memory[15]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[14]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[13]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[12]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[11]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[10]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[9]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[8]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[7]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[6]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[5]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[4]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[3]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[2]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[1]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[0]} -radix decimal}} -expand -subitemconfig {{/testbench/cpu/processor/u_reg_file/memory[15]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[14]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[13]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[12]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[11]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[10]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[9]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[8]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[7]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[6]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[5]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[4]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[3]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[2]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[1]} {-height 15 -radix decimal} {/testbench/cpu/processor/u_reg_file/memory[0]} {-height 15 -radix decimal}} /testbench/cpu/processor/u_reg_file/memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {288890 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 242
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2730 ns}
