module top (
    inout logic  [14:0]DDR_addr,
    inout logic  [2:0]DDR_ba,
    inout logic  DDR_cas_n,
    inout logic  DDR_ck_n,
    inout logic  DDR_ck_p,
    inout logic  DDR_cke,
    inout logic  DDR_cs_n,
    inout logic  [3:0]DDR_dm,
    inout logic  [31:0]DDR_dq,
    inout logic  [3:0]DDR_dqs_n,
    inout logic  [3:0]DDR_dqs_p,
    inout logic  DDR_odt,
    inout logic  DDR_ras_n,
    inout logic  DDR_reset_n,
    inout logic  DDR_we_n,
    inout logic  FIXED_IO_ddr_vrn,
    inout logic  FIXED_IO_ddr_vrp,
    inout logic  [53:0]FIXED_IO_mio,
    inout logic  FIXED_IO_ps_clk,
    inout logic  FIXED_IO_ps_porb,
    inout logic  FIXED_IO_ps_srstb);

    localparam N = 32;

    logic axiclk;
    //assign clk = axiclk;
    clk_wiz_0 instance_name (.clk_out200(clk), .clk_in100(axiclk)); 
    //logic reset_reg, reset_regreg;
    //always_ff @(posedge clk) reset_reg    <= reset;
    //always_ff @(posedge clk) reset_regreg <= reset_reg;

    //logic err_clear_reg, err_clear_regreg;
    //always_ff @(posedge clk) err_clear_reg    <= err_clear;
    //always_ff @(posedge clk) err_clear_regreg <= err_clear_reg;

    //bram_delay delay_inst(.clk(clk), .reset(0), .error(error), .err_clear(err_clear_regreg));

    logic [N-1:0] error, err_clear;

    genvar i;  
    generate  for (i=0; i < N; i++) begin: gen_code_label  
        bram_delay delay_inst(.clk(clk), .reset(0), .error(error[i]), .err_clear(err_clear[i]));
    end  endgenerate 
    
    system system_i(
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .axiclk(axiclk)
    );

    vio_0 vio_inst (.clk(clk), .probe_in0(error), .probe_out0(err_clear) );

endmodule

