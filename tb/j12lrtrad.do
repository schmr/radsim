source tb/radiation_simulation.tcl

onerror {quit -f}
# Disable warning produced by change command.
# This script changes the simname_g generic of the testbench for each run.
# simname_g is used by the VHDL code to create a file with the miter results.
set WarnConstantChange 0
# Disable warning arising from metavalues during reset:
set NumericStdNoWarnings 1

set testbench_name tb_j1_rt_radiate
# 13 cycles from stimuli process
set reset_duration_ps 78000
# Latch and design area are *not* evaluated by the radiation source atm.
# For a more sophisticated evaluation they might be interesting.
set latch_area 9.8784
set design_area 56748.586830
# 785 cycles from stimuli process
set radiation_duration_ps 4710000

# Get particles from command line. Because zero padded numbers are
# treated as octal numbers use scan to remove the leading zeros.
scan [examine particles_g] %d particles
set particles_padded [format "%06d" $particles]
set simnum_padded [format "%03d" [examine simname_g]]
set simulation_name ${testbench_name}_${particles_padded}_${simnum_padded}
force simname ${simulation_name}
radiation_simulation $testbench_name $simulation_name $reset_duration_ps $radiation_duration_ps $particles $latch_area $design_area
