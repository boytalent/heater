#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

#include "common-bit-set.h"
#include "utils.h"
#include "mem-io.h"

#define TEST_BRAM_RANGE 0x1000
/*
void test_bram()
{
    uint32_t tmp_val;
    tmp_val=read_reg(gpio_addr,DIRM_0);
    tmp_val|=SET_BIT_X_TO_1(mio_pin);
    write_reg(gpio_addr,DIRM_0,tmp_val);

    tmp_val=read_reg(gpio_addr,OEN_0);
    tmp_val|=SET_BIT_X_TO_1(mio_pin);
    write_reg(gpio_addr,OEN_0,tmp_val);
  
    while(1)
    {
       tmp_val=read_reg(gpio_addr,DATA_0);
       tmp_val^=SET_BIT_X_TO_1(mio_pin);
       DEBUG("*(%p)=0x%08x\n",(void*)(0xE000A000)+DATA_0,tmp_val);
       write_reg(gpio_addr,DATA_0,tmp_val);
       usleep(1000);
    }
}
*/

int main(int argc, char** argv)
{
    uint32_t *axi_addr;

    axi_addr=phy_addr_2_vir_addr(PROTO_BASE_ADDR, PROTO_RANGE);
    if(axi_addr==NULL) {
       fprintf(stderr,"can't mmap phy_addr 0x%08x with size 0x%08x to viraddr\n", PROTO_BASE_ADDR, PROTO_RANGE);
       exit(3);
    }


    munmap(axi_addr,PROTO_RANGE);

    return 0;
}
