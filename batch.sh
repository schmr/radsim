#!/bin/sh -xv
simargs="-quiet -novopt -sdfnowarn -suppress 3017,3722 -c -t ps"
sim="vsim"
dc_shell_quiet="dc_shell -no_log -output_log_file /dev/null -x"

REPS=20
PARTICLERANGE="1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100 200 300 400 500 600 700 800 900"

RANGE=`seq ${REPS}`

# Run simulations with radiation.
for j in $PARTICLERANGE
do
	particles=`printf "%03d" $j`
	rm tb_j1_rt_radiate_${particles}.stdout

	# 2lrt, unprotected
	for i in $RANGE
	do
		simname_number=`printf "%027d" $i`
		${sim} ${simargs} -t ps -sdftype /tb_j1_rt_radiate/i_j1rt=j1rt.sdf -Gsimname_g=${simname_number} -Gparticles_g=${particles} tb_j1_rt_radiate -do tb/j12lrtrad.do | tee -a tb_j1_rt_radiate_${particles}.stdout
	done
done
