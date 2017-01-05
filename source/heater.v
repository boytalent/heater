// This is a block of logic that is designed to to just burn power.
// Multiple channels can be instantiated in order to scale power consumption.
// An LFSR is used as the data source so the toggle rate is exactly 50%.  
// A checker is at the end of the pipe to verify that the logic is running error free.
module heater (
    input   logic               clk,
    input   logic               enable,
    input   logic               err_clear,
    output  logic               error);
    
    logic  reset, reset_pre;
    always_ff @(posedge clk) reset_pre <= ~enable;
    always_ff @(posedge clk) reset <= reset_pre;
    
    // an lfsr data source
    logic [31:0] lfsr_dout;    
    lfsr_generator lfsr_gen_inst(.clk(clk), .reset(reset), .dv_in(1), .dv_out(), .dataout(lfsr_dout));

    // some srl delays
    logic [5:0][31:0] srl_dout;
    srl32 srl32_0(.CLK(clk), .D(lfsr_dout),   .Q(srl_dout[0]));
    srl32 srl32_1(.CLK(clk), .D(srl_dout[0]), .Q(srl_dout[1]));
    srl32 srl32_2(.CLK(clk), .D(srl_dout[1]), .Q(srl_dout[2]));
    srl32 srl32_3(.CLK(clk), .D(srl_dout[2]), .Q(srl_dout[3]));
    srl32 srl32_4(.CLK(clk), .D(srl_dout[3]), .Q(srl_dout[4]));
    srl32 srl32_5(.CLK(clk), .D(srl_dout[4]), .Q(srl_dout[5]));

    // some BRAM delays
    logic [9:0] count;
    always_ff @ (posedge clk) if (reset==1) count<=0; else count++;
    logic [3:0][31:0] bram_dout;
    sp_bram sp_bram_0(.clka(clk), .wea(1), .addra(count), .dina(srl_dout[5]),  .douta(bram_dout[0]));
    sp_bram sp_bram_1(.clka(clk), .wea(1), .addra(count), .dina(bram_dout[0]), .douta(bram_dout[1]));
    sp_bram sp_bram_2(.clka(clk), .wea(1), .addra(count), .dina(bram_dout[1]), .douta(bram_dout[2]));
    sp_bram sp_bram_3(.clka(clk), .wea(1), .addra(count), .dina(bram_dout[2]), .douta(bram_dout[3]));

    // some DSP48 delays
    logic [5:0][47:0] dsp_dout;
    dsp_nop dsp_0(.CLK(clk), .D(0), .C({16'd0, bram_dout[3]}), .P(dsp_dout[0]));
    dsp_nop dsp_1(.CLK(clk), .D(0), .C({16'd0, dsp_dout[0]}),  .P(dsp_dout[1]));
    dsp_nop dsp_2(.CLK(clk), .D(0), .C({16'd0, dsp_dout[1]}),  .P(dsp_dout[2]));
    dsp_nop dsp_3(.CLK(clk), .D(0), .C({16'd0, dsp_dout[2]}),  .P(dsp_dout[3]));
    dsp_nop dsp_4(.CLK(clk), .D(0), .C({16'd0, dsp_dout[3]}),  .P(dsp_dout[4]));
    dsp_nop dsp_5(.CLK(clk), .D(0), .C({16'd0, dsp_dout[4]}),  .P(dsp_dout[5]));

    // some pipeline registers
    localparam Npipe = 128;
    logic [Npipe-1:0][31:0] ff_dout;
    always_ff @(posedge clk) ff_dout[0] <= dsp_dout[5][31:0];
    genvar i;  
    generate  for (i=1; i<Npipe; i++) begin: gen_ff_pipe  
        always_ff @(posedge clk) ff_dout[i] <= ff_dout[i-1];
    end  endgenerate 
    //always_ff @(posedge clk) ff_dout[0] <= dsp_dout[5][31:0];
    //always_ff @(posedge clk) ff_dout[1] <= ff_dout[0];
    //always_ff @(posedge clk) ff_dout[2] <= ff_dout[1];
    //always_ff @(posedge clk) ff_dout[3] <= ff_dout[2];
    //always_ff @(posedge clk) ff_dout[4] <= ff_dout[3];
    //always_ff @(posedge clk) ff_dout[5] <= ff_dout[4];
    //always_ff @(posedge clk) ff_dout[6] <= ff_dout[5];
    //always_ff @(posedge clk) ff_dout[7] <= ff_dout[6];
    
    // an lsfr data checker
    lfsr_checker lfsr_check_inst(.clk(clk), .reset(err_clear), .dv_in(1), .datain(ff_dout[Npipe-1]), .error(error));

endmodule

