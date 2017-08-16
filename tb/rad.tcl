proc rnd_sigval {} {
    # Create a random 1 or 0.
    return [rnd_int 2]
}


proc deposit_charge {signame t reset_duration_ps} {
    # Deposit a random 0 or 1 at given signal.
    set val [rnd_sigval]
    set oldval [examine $signame]
    set offset [expr {$t + $reset_duration_ps}]
    if {[expr {(($oldval == "St0") && ($val == 0)) || (($oldval == "St1") && ($val == 1))}]} {
        add message "($offset) ($oldval -> $val) Deposit $val at $signame ."
    } else {
        add message -severity warning "($offset) ($oldval -> $val) Deposit $val at $signame ."
    }
    #force -deposit $signame $val 1 ps -cancel 2 ps 
    #force -deposit $signame $val 1 ps  
    #run 1 ps
    #noforce $signame
    #force -deposit $signame $val -cancel 400 ps
    #force -deposit $signame $val -cancel 5 ns
    force -deposit $signame $val -cancel 500 ps
}


proc calculate_hitprob {area_latch area_circuit num_latches} {
    #return [expr {$num_latches / ($area_circuit / $area_latch)}]
    # Let every particle trigger a SBU. This is the conservatice choice.
    return 1.0
}


proc rnd_int {range} {
    return [expr {int(floor(rand() * $range))}]  
}


proc create_events {simtime num_events} {
    # Create events for num_events per simulationtime. 
    # Events per timestep = num_events * timestep / simtime
    # Check if events happen and calculate random point in time.
    set events {}
    set i 0
    for {set i 0} {$i < $num_events} {incr i} {
	lappend events [rnd_int $simtime]
        incr i
    }
    set hit_events [llength $events]
    return $events
}


proc create_timeslices {simtime events} {
    # events need to be sorted in increasing order
    set timeslices {}
    set last 0
    foreach x $events {
        lappend timeslices [expr {int($x - $last)}]
        set last $x
    }
    return $timeslices
}


proc radiate_design {num_events area_latch area_circuit simtime reset_duration_ps} {
    # Create a list of all latch nodes and run simulation while depositing
    # random signal values on a random latch.
    set latches [find signals -r /*/Q_buf]
    set targetsignals {}
    foreach l $latches {
        set ts [file dirname $l]
	lappend targetsignals "${ts}/D"
    }
    set latches $targetsignals
    set num_latches [llength $latches]
    add message "Found $num_latches latches."
    set events [create_events $simtime $num_events]
    set whynotinplace [lsort -increasing -integer $events]
    set timeslices [create_timeslices $simtime $whynotinplace]
    set targets {}
    for {set i 0} {$i < [llength $timeslices]} {incr i} {
        set dt [lindex $timeslices $i]
	set t [lindex $whynotinplace $i]
        run $dt ps
        set target [lindex $latches [rnd_int $num_latches]]
	lappend targets $target
        deposit_charge $target $t $reset_duration_ps
    }
    foreach l $targets {
        add wave $l
    }
}
