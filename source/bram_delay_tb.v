`timescale 1 ns / 1 ps

module bram_delay_tb();
    localparam clk_period = 10;

    logic               reset, err_clear, error;
//    logic   [31:0]      datain;
//    logic   [31:0]      dataout;

    logic clk = 0; initial forever #(clk_period/2) clk = ~clk;

    initial begin 
        reset = 1;
        err_clear = 0;
        #(clk_period*10);
        reset = 0;
        #(clk_period*1200);
        err_clear = 1;
        #(clk_period*1);
        err_clear = 0;
    end


//    always @(posedge clk) begin 
//        if (reset == 1) 
//            datain <= 500;
//        else
//            datain <= datain + 1;
//    end
        
    bram_delay uut (.*);

endmodule

