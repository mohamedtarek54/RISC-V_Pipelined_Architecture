# RISC-V_Pipelined_Architecture
Verilog implementation of RISC-V pipelined architecture guided by the well explained book: Digital Design and Computer Architecture RISC-V Edition (Sarah Harris, David Harris).

# Setting up the Environment
to use this code open Modelsim, create new project and add all the files
then open transcript window and run the following code:
`vlog *.v; vsim RISC_top_tb -voptargs=+acc; do wave.do; run -all`

# Architecture Overview
![image](https://github.com/mohamedtarek54/RISC-V_Pipelined_Architecture/assets/25269476/c4f8c9d1-517d-40ea-91f2-fdec03d3c7db)
<sub> All copyrights reserved to Harris book</sub>

## Assembly Program used to test the code
![image](https://github.com/mohamedtarek54/RISC-V_Pipelined_Architecture/assets/25269476/400489b0-b5db-448d-aeb1-77b1efe61f73)

