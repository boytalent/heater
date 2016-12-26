module bram_delay (
    input   logic               clk,
    input   logic               reset,
    input   logic               err_clear,
    output  logic               error);
    
    // an lfsr data source
    logic [31:0] lfsr_dout;    
    lfsr_generator lfsr_gen_inst(.clk(clk), .reset(reset), .dv_in(1), .dv_out(), .dataout(lfsr_dout));

    // an srl delay
    logic [31:0] srl_dout;
    srl32 srl32_inst(.CLK(clk), .D(lfsr_dout), .Q(srl_dout));

    // a BRAM delay
    logic [9:0] count;
    always_ff @ (posedge clk) if (reset==1) count<=0; else count++;
    logic [31:0] bram_dout;
    sp_bram sp_bram_inst(.clka(clk), .wea(1), .addra(count), .dina(srl_dout), .douta(bram_dout));

    // a DSP48 delay
    logic [47:0] dsp_dout;
    dsp_nop dsp_nop_inst(.CLK(clk), .D(0), .C({16'd0, bram_dout}), .P(dsp_dout));

    // a couple of pipeline registers
    logic [31:0] ff_dout, ff_dout_reg;
    always_ff @(posedge clk) ff_dout     <= dsp_dout[31:0];
    always_ff @(posedge clk) ff_dout_reg <= ff_dout;
    
    // an lsfr data checker
    lfsr_checker lfsr_check_inst(.clk(clk), .reset(err_clear), .dv_in(1), .datain(ff_dout_reg), .error(error));

endmodule

