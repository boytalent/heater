`timescale 1 ns / 1 ps

module heater_tb();
    localparam clk_period = 10;

    logic               reset, err_clear, error;

    logic clk = 0; initial forever #(clk_period/2) clk = ~clk;

    initial begin 
        reset = 1;
        err_clear = 0;
        #(clk_period*10);
        reset = 0;
        #(clk_period*4600);
        err_clear = 1;
        #(clk_period*1);
        err_clear = 0;
    end

    heater uut (.*);

endmodule

