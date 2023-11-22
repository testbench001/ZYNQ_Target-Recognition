module  conv_kernel_1x2_add(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // 
        input   signed  [15:0]  data00                  ,       
        input   signed  [15:0]  data01                  ,       
        input   signed  [15:0]  data02                  ,       
        input   signed  [15:0]  data10                  ,       
        input   signed  [15:0]  data11                  ,       
        input   signed  [15:0]  data12                  ,  
        input   signed  [15:0]  data20                  ,       
        input   signed  [15:0]  data21                  ,       
        input   signed  [15:0]  data22                  ,  
        //
        output  reg signed      [19:0]  add_result              
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

reg     signed  [19:0]          temp0                           ;
reg     signed  [19:0]          temp1                           ;
reg     signed  [19:0]          temp2                           ;


//=============================================================================
//**************    Main Code   **************
//=============================================================================
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0) begin
                temp0           <=      'd0;
                temp1           <=      'd0;
                temp2           <=      'd0;
                add_result      <=      'd0;
        end 
        else begin
                temp0           <=      data00 + data01 + data02;
                temp1           <=      data10 + data11 + data12;
                temp2           <=      data20 + data21 + data22;
                add_result      <=      temp0 + temp1 + temp2;
        end
end


endmodule
