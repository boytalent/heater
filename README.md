# heater
An FPGA "heater" design that uses LFSR data to toggle logic for the purpose of stressing the power supply.

_**https://github.com/hdlguy/heater.git**_
## purpose
There are many reasons for wanting a design that does nothing other than toggle nodes to burn power.
1. You can test the current limits of your power distribution network.
1. You can test the cooling capability of your board.
1. You can verify the results of FPGA power estimation tools.
2. You can have a little fun.

## design
This design is written in Systemverilog.  It provides a parameterized number of channels of power burning pipelines. Also, each channel is parameterized with respect to the number of LUT, DSP48 and BRAM that are used.

Artix_top.v is the top level source for the Artix-50 version of the design. A VIO is used to control the number of channels that are enabled so that power consumption can be controlled at run-time.

Build instructions are in the implement folder.
## results
This design was tested on a MicroZed 7020 board and an Avnet Artix 50t board.  Temperatures ran very high
on the MicroZed so I switched to the Artix board. Eventually, the current limit of the Artix board
was exceeded causing board reboot.

Use with caution. :smiling_imp:
