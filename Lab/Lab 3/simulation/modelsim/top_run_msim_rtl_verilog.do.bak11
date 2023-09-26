transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+U:/EE469/Lab3 {U:/EE469/Lab3/top.sv}
vlog -sv -work work +incdir+U:/EE469/Lab3 {U:/EE469/Lab3/reg_file.sv}
vlog -sv -work work +incdir+U:/EE469/Lab3 {U:/EE469/Lab3/fullAdder.sv}
vlog -sv -work work +incdir+U:/EE469/Lab3 {U:/EE469/Lab3/dmem.sv}
vlog -sv -work work +incdir+U:/EE469/Lab3 {U:/EE469/Lab3/arm.sv}
vlog -sv -work work +incdir+U:/EE469/Lab3 {U:/EE469/Lab3/imem.sv}
vlog -sv -work work +incdir+U:/EE469/Lab3 {U:/EE469/Lab3/alu.sv}

