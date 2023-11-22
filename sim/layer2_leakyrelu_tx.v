module  layer2_leakyrelu_tx(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        output  wire    [63:0]  leakyrelu_data          ,       
        output  reg             leakyrelu_valid         ,       
        output  wire            leakyrelu_last          ,       
        input                   ready                          
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
localparam      INDEX_END       =       'd32                    ;


reg     [ 7:0]                  data_arr[255:0]                 ;
reg     [ 5:0]                  index                           ;       


//=============================================================================
//**************    Main Code   **************
//=============================================================================
initial $readmemh("./txt/layer2_leakyrelu.txt", data_arr);

assign  leakyrelu_data  =       {data_arr[7+index*8], data_arr[6+index*8],
                                 data_arr[5+index*8], data_arr[4+index*8],
                                 data_arr[3+index*8], data_arr[2+index*8],
                                 data_arr[1+index*8], data_arr[0+index*8]};
assign  leakyrelu_last  =       (index == (INDEX_END-1)) ? 1'b1 : 1'b0;

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                leakyrelu_valid      <=      1'b0;
        else if(index < (INDEX_END-1))
                leakyrelu_valid      <=      1'b1;
        else
                leakyrelu_valid      <=      1'b0;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                index   <=      'd0;
        else if(leakyrelu_valid == 1'b1 && ready == 1'b1 && index < INDEX_END)
                index   <=      index + 1'b1;
end


endmodule
