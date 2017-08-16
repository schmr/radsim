# Single event transients (SETs) simulation scripts for Questasim/Modelsim
The provided scripts allow to inject single event transients during the
simulation of gate-level models.
Faults are uniformly distributed in space (all latch input nodes in
design under test (DUT)), as well as time, excluding an initial circuit reset
at the start of the simulation.

# Organization
* `rad.tcl` contains the low level procedures 
* `radiation_simulation.tcl` is a convenience wrapper to store the
radiation environment information alongside the waveforms in the value
change dump (VCD) file
* `j12lrtrad.do` is an example top level script that radiates a specific design
* `batch.sh` shows how a dataset of different radiation simulation runs
can be created for offline analysis

# Remarks
* The radiation procedures are not fully parameterized, some values like
the SET duration are hard coded.
* The overall radiation simulation script provides initial support for
adjusting the particle hit probability w.r.t the area of a latch and the
total design area.
Currently every particle event creates an SET (hit probability = 1.0).

# License
See LICENSE file.

[![DOI](https://zenodo.org/badge/100486954.svg)](https://zenodo.org/badge/latestdoi/100486954)
