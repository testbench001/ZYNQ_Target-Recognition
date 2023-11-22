module  martix_3x3(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        input           [ 7:0]  line2_data              ,
        input           [ 7:0]  line1_data              ,
        input           [ 7:0]  line0_data              ,
        // 
        output  wire    [71:0]  martix_3x3_data       
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

reg     [ 7:0]                  reg00                           ;       
reg     [ 7:0]                  reg10                           ;       
reg     [ 7:0]                  reg20                           ;       

reg     [ 7:0]                  reg01                           ;       
reg     [ 7:0]                  reg11                           ;       
reg     [ 7:0]                  reg21                           ;       


//=============================================================================
//**************    Main Code   **************
//=============================================================================


assign  martix_3x3_data         =       {line2_data, line1_data, line0_data,
                                         reg21,      reg11,      reg01,
                                         reg20,      reg10,      reg00};


always  @(posedge sclk) begin
        reg21   <=      line2_data;
        reg11   <=      line1_data;
        reg01   <=      line0_data;
        
        reg20   <=      reg21;
        reg10   <=      reg11;
        reg00   <=      reg01;
end



endmodule
