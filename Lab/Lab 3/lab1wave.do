onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /testbench/cpu/clk
add wave -noupdate /testbench/cpu/rst
add wave -noupdate -radix decimal /testbench/cpu/PC
add wave -noupdate /testbench/cpu/Instr
add wave -noupdate /testbench/cpu/processor/ALUResultM
add wave -noupdate /testbench/cpu/WriteData
add wave -noupdate /testbench/cpu/MemWrite
add wave -noupdate /testbench/cpu/ReadData
add wave -noupdate -childformat {{{/testbench/cpu/processor/u_reg_file/memory[15]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[14]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[13]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[12]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[11]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[10]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[9]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[8]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[7]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[6]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[5]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[4]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[3]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[2]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[1]} -radix decimal} {{/testbench/cpu/processor/u_reg_file/memory[0]} -radix decimal}} -subitemconfig {{/testbench/cpu/processor/u_reg_file/memory[15]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[14]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[13]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[12]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[11]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[10]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[9]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[8]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[7]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[6]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[5]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[4]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[3]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[2]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[1]} {-radix decimal} {/testbench/cpu/processor/u_reg_file/memory[0]} {-radix decimal}} /testbench/cpu/processor/u_reg_file/memory
add wave -noupdate /testbench/cpu/processor/SrcA
add wave -noupdate /testbench/cpu/processor/SrcB
add wave -noupdate /testbench/cpu/processor/ALUResultM
add wave -noupdate /testbench/cpu/processor/WriteDataM
add wave -noupdate /testbench/cpu/processor/ReadData
add wave -noupdate /testbench/cpu/processor/MemWrite
add wave -noupdate /testbench/cpu/processor/RegWrite
add wave -noupdate /testbench/cpu/processor/BranchTakenE
add wave -noupdate /testbench/cpu/processor/BranchE
add wave -noupdate /testbench/cpu/processor/BranchD
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {974448 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 113
configure wave -valuecolwidth 60
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
WaveRestoreZoom {0 ps} {5460 ns}
