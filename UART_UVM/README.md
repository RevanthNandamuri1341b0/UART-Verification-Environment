# UART Verification Environment

Development of **UART** Verification Environment using **Universal Verification Methodology**

## Setting in EDAPlayground

* Open [EDAPlayground](https://www.edaplayground.com/)

* Choose `SystemVerilog/Verilog` in **Testbench + Design**

* Choose `UVM 1.2 ` in  **OVM / UVM**

* Choose  ``Synopsys VCS 2020.03`` in **Tools and Simulator** 

* Add below code in **Compile options** 

    * `-timescale=1ns/1ns +vcs+flush+all +warn=all

* Add below code in **Run options**

    * `+UVM_TESTNAME=uart_test`

#

### FOR REFERENCE CHECKOUT THIS LINK ---> [Master Reference](https://www.edaplayground.com/x/VCra)
#
