source tb/rad.tcl

proc radiation_simulation {testbench_name simulation_name reset_duration_ps radiation_duration_ps particles latcharea designarea} {
	# Setup memory dump on break by testbench finished exception.
	onbreak {
	mem save -o ${simulation_name}_sram_rtl.mti -f mti -data decimal -addr hex -wordsperline 1 -startaddress 256 -endaddress 280 /${testbench_name}/i_sram/sram_r
	mem save -o ${simulation_name}_sram_gate.mti -f mti -data decimal -addr hex -wordsperline 1 -startaddress 256 -endaddress 280 /${testbench_name}/i_sramrt/sram_r
	vcd flush
	quit -f
	}
	# Record radiation run in value change dump.
	vcd file ${simulation_name}.vcd.gz
	vcd limit 2gb ${simulation_name}.vcd.gz
	vcd comment "Radiation experiment ${simulation_name} using testbench ${testbench_name} with ${particles} particles.\nReset duration: ${reset_duration_ps} ps\nRadiation duration: ${radiation_duration_ps} ps\nLatcharea: ${latcharea}\nDesignarea: ${designarea}"
	vcd add -r -optcells *
	# Run until end of reset.
	run ${reset_duration_ps} ps
	# Radiate gatelevel model during execution of program.
	# Stop radiation a few cycles before reference model would complete
	# the execution of the program.
	radiate_design ${particles} ${latcharea} ${designarea} ${radiation_duration_ps} ${reset_duration_ps}
	run -all
}
