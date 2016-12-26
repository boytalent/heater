module lfsr_checker(
    input   logic           clk,
    input   logic           reset,
    input   logic           dv_in,
    input   logic   [31:0]  datain,
    output  logic           error);

    logic   [31:0]  next_lfsr, next_lfsr_q, lfsr_latch;
    logic dv_in_latch;

    lfsr #(.WIDTH(32)) lfsr_inst (.datain(datain), .dataout(next_lfsr));

    always_ff @(posedge clk) begin
        if (reset == 1) begin
            error <= 0;
            dv_in_latch <= 0;
        end else begin
            if (dv_in == 1) begin
                dv_in_latch <= 1;
                lfsr_latch <= next_lfsr;
                if ((lfsr_latch != datain)&&(dv_in_latch==1)) error <= 1;
            end
/*
            if (dv_in == 1) begin
                dv_in_latch <= 1;
                next_lfsr_q <= next_lfsr;
                if ((next_lfsr_q != datain)&&(dv_in_latch==1)) error <= 1;
            end
*/
        end
    end

endmodule

