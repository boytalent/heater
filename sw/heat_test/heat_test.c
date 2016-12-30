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

    write_reg(pcie_addr,GPIO0_DATA, 1); // enable the channels
    write_reg(pcie_addr,GPIO1_DATA, 0xffffffff); // clear the errors
    write_reg(pcie_addr,GPIO1_DATA, 0x00000000); // clear the errors
    uint32_t read_val0;
    read_val0 = read_reg(pcie_addr,GPIO1_DATA2);
    printf("read_val0 = 0x%08X\n", read_val0);

    munmap(pcie_addr,pcie_bar0_size);

    return 0;
}
