#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

#include "mem-io.h"
#include "utils.h"
#include "proto2_hw.h"
#include "xspi_l.h"

int main(int argc,char** argv)
{
    void* pcie_addr;

    uint32_t pcie_bar0_addr=BASE_ADDRESS;
    uint32_t pcie_bar0_size=PROTO_SIZE;

    pcie_addr=phy_addr_2_vir_addr(pcie_bar0_addr,pcie_bar0_size);
    if(pcie_addr==NULL) {
       fprintf(stderr,"can't mmap phy_addr 0x%08x with size 0x%08x to viraddr. you must be in root.\n",pcie_bar0_addr,pcie_bar0_size);
       exit(-1);
    }
   fprintf(stdout,"phy_addr 0x%08x with size 0x%08x to viraddr 0x%08x.\n",pcie_bar0_addr,pcie_bar0_size, (uint32_t)pcie_addr);

    uint32_t chan_enable = 0x00000000;
    printf("chan_enable = 0x%08X\n", chan_enable);
    write_reg(pcie_addr,GPIO0_DATA, chan_enable); // enable the channels
    usleep(100);

    write_reg(pcie_addr,GPIO1_DATA, 0xffffffff); // clear the errors
    write_reg(pcie_addr,GPIO1_DATA, 0x00000000); // clear the errors
    uint32_t read_val;
    read_val = read_reg(pcie_addr,GPIO1_DATA2);
    printf("errors = 0x%08X\n", read_val);

    read_val = read_reg(pcie_addr,XADC_TEMP);
    printf("temperature = 0x%08X, %f degrees C\n", read_val, (read_val*503.975/(16.0*4096.0))-273.15);

    read_val = read_reg(pcie_addr,XADC_VCCINT);
    printf("VCCint = 0x%08X, %f Volts\n", read_val, read_val*3.0/(16.0*4096.0));

    read_val = read_reg(pcie_addr,XADC_VCCAUX);
    printf("VCCaux = 0x%08X, %f Volts\n", read_val, read_val*3.0/(16.0*4096.0));

    read_val = read_reg(pcie_addr,XADC_VCCBRAM);
    printf("VCCbram = 0x%08X, %f Volts\n", read_val, read_val*3.0/(16.0*4096.0));

    munmap(pcie_addr,pcie_bar0_size);

    return 0;
}
