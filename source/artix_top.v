module artix_top (
    input  logic       clk,
    output logic [7:0] led);

    localparam N = 18;

    logic [N-1:0] heater_error, heater_err_clear, heater_enable;

    genvar i;  
    generate  for (i=0; i < N; i++) begin: gen_code_label  
        heater heater_inst(.clk(clk), .enable(heater_enable[i]), .error(heater_error[i]), .err_clear(heater_err_clear[i]));
    end  endgenerate 

    artix_vio vio_inst( .clk(clk), .probe_in0(heater_error), .probe_out0(heater_err_clear), .probe_out1(heater_enable) );

    always_ff @(posedge clk) led <= heater_error[7:0];
    
endmodule

