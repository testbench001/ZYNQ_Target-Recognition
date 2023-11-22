module  quant_int8(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        input   signed  [23:0]  data_in                 ,
        //
        input           [14:0]  mult                    ,       
        input           [ 7:0]  shift                   ,       
        input           [ 7:0]  zero_point              ,       
        //
        output  reg     [ 7:0]  data_out                       
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

wire    signed  [38:0]          mult_rslt                       ;

reg     [23:0]                  shift_rslt                      ;

reg                             data_up                         ;

//=============================================================================
//**************    Main Code   **************
//=============================================================================
mult_gen_0      mult_gen_0_inst (
        .CLK                    (sclk                   ),      // input wire CLK
        .A                      (data_in                ),      // input wire [23 : 0] A
        .B                      (mult                   ),      // input wire [14 : 0] B
        .P                      (mult_rslt              )       // output wire [38 : 0] P
);

always  @(posedge sclk) begin
        data_up <=       mult_rslt[14+shift];
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0) begin
                shift_rslt      <=      'd0;
                data_out        <=      'd0;
        end
        else begin
                shift_rslt      <=      mult_rslt[38:15] >> shift;
                if(data_up == 1'b1)
                        data_out        <=      shift_rslt + zero_point + 'd1;
                else 
                        data_out        <=      shift_rslt + zero_point;
        end
end




endmodule
