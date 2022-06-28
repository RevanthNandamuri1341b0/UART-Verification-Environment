vlib work
vdel -all
vlib work
#vlog -f .list +acc
vlog transmitter.v +acc
vlog receiver.v +acc
vlog baud.v +acc
vlog uart.v +acc
vlog testbench.sv +acc
vsim work.top
#add wave -r *
do wave.do
run -all
