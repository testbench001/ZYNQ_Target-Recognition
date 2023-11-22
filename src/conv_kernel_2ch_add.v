module  conv_kernel_2ch_add(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // 
        input   signed  [19:0]  data0                   ,
        input   signed  [19:0]  data1                   ,
        input   signed  [19:0]  data2                   ,
        input   signed  [19:0]  data3                   ,
        input   signed  [19:0]  data4                   ,
        input   signed  [19:0]  data5                   ,
        input   signed  [19:0]  data6                   ,
        input   signed  [19:0]  data7                   ,
        input   signed  [31:0]  bias                    ,
        input                   bias_enable             ,       
        //
        output  reg signed [23:0]       data_out                
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

reg     signed  [23:0]          temp0                           ;       
reg     signed  [23:0]          temp1                           ;       
reg     signed  [23:0]          temp2                           ;       

wire    signed  [31:0]          bias_data                       ;

//=============================================================================
//**************    Main Code   **************
//=============================================================================
assign  bias_data       =       (bias_enable == 1'b1) ? bias : 32'h0;

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0) begin
                temp0           <=      'd0;
                temp1           <=      'd0;
                temp2           <=      'd0;
                data_out        <=      'd0;
        end
        else begin
                temp0           <=      data0 + data1 + data2;
                temp1           <=      data3 + data4 + data5;
                temp2           <=      data6 + data7 + bias_data;
                data_out        <=      temp0 + temp1 + temp2;
        end
end


endmodule
