This folder holds the build scripts for the FPGA designs.  There is a folder to build for
the MicroZed (or ZedBoard) with a Zynq 7020 part. Another folder is provided for the Avnet
Artix 50t eval board.

These FPGA designs have been built and tested with Vivado 2016.4.

Start a Xilinx TCL shell or use the TCL window of the Vivado GUI. Change directory to the implement folder then run ...

    vivado -mode batch -source setup.tcl

    vivado -mode batch -source compile.tcl

On the Artix board you can burn the flash with ..

    vivado -mode batch -source program_spi.tcl

The Zed build produces top.bit.bin that can be loaded from Zynq processor under linux like this ...

    sudo cat top.bit.bin > /dev/xdevcfg
