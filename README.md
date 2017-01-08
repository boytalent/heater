# heater
An FPGA "heater" design to use LFSR data to toggle logic for the purpose of stressing the power supply.

https://github.com/hdlguy/heater.git

This design was tested on a MicroZed 7020 board and an Avnet Artix 50t board.  Temperatures ran very high 
on the MicroZed so I switched to the Artix board. Eventually, the current limit of the Artix board 
was exceeded causing board reboot. :-)

Build instructions are in the implement folder.

Use with caution.


