# RISC-V_Pipelined_Architecture
Verilog implementation of RISC-V pipelined architecture guided by the well explained book: Digital Design and Computer Architecture RISC-V Edition (Sarah Harris, David Harris).

# Setting up the Environment
to use this code open Modelsim, create new project and add all the files
then run the following code in transcript
`vlog *.v; vsim RISC_top_tb -voptargs=+acc; do wave.do; run -all`

# Architecture Overview
