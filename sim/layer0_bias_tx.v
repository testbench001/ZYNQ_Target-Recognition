module  layer0_bias_tx(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        output  wire    [63:0]  bias_data               ,
        output  reg             bias_valid              ,       
        output  wire            bias_last               ,       
        input                   ready                          
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
localparam      INDEX_END       =       'd8                     ;


wire    [31:0]          bias_arr[15:0]                          ;
reg     [ 4:0]                  index                           ;       


//=============================================================================
//**************    Main Code   **************
//=============================================================================
assign bias_arr[ 0] = 129; 
assign bias_arr[ 1] = 395; 
assign bias_arr[ 2] = -1099; 
assign bias_arr[ 3] = 473; 
assign bias_arr[ 4] = 119; 
assign bias_arr[ 5] = 698; 
assign bias_arr[ 6] = 537; 
assign bias_arr[ 7] = 818; 
assign bias_arr[ 8] = -108; 
assign bias_arr[ 9] = 1009; 
assign bias_arr[10] = 364; 
assign bias_arr[11] = 225; 
assign bias_arr[12] = -2467; 
assign bias_arr[13] = -162; 
assign bias_arr[14] = 368; 
assign bias_arr[15] = -174; 

assign  bias_data       =       {bias_arr[1+index*2], bias_arr[index*2]};
assign  bias_last       =       (index == (INDEX_END-1)) ? 1'b1 : 1'b0;

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                bias_valid      <=      1'b0;
        else if(index < (INDEX_END-1))
                bias_valid      <=      1'b1;
        else
                bias_valid      <=      1'b0;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                index   <=      'd0;
        else if(bias_valid == 1'b1 && ready == 1'b1 && index < INDEX_END)
                index   <=      index + 1'b1;
end


endmodule
