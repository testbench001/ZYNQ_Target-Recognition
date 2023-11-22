module  layer2_bias_tx(
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
localparam      INDEX_END       =       'd16                    ;


wire    [31:0]                  bias_arr[31:0]                  ;
reg     [ 4:0]                  index                           ;       


//=============================================================================
//**************    Main Code   **************
//=============================================================================
assign bias_arr[ 0] = 692; 
assign bias_arr[ 1] = 583; 
assign bias_arr[ 2] = 206; 
assign bias_arr[ 3] = 697; 
assign bias_arr[ 4] = 547; 
assign bias_arr[ 5] = 468; 
assign bias_arr[ 6] = 274; 
assign bias_arr[ 7] = 383; 
assign bias_arr[ 8] = 158; 
assign bias_arr[ 9] = 203; 
assign bias_arr[10] = 586; 
assign bias_arr[11] = 579; 
assign bias_arr[12] = 187; 
assign bias_arr[13] = 178; 
assign bias_arr[14] = 703; 
assign bias_arr[15] = 478; 
assign bias_arr[16] = -199; 
assign bias_arr[17] = 576; 
assign bias_arr[18] = 222; 
assign bias_arr[19] = 624; 
assign bias_arr[20] = 534; 
assign bias_arr[21] = 107; 
assign bias_arr[22] = 549; 
assign bias_arr[23] = 89; 
assign bias_arr[24] = 354; 
assign bias_arr[25] = 374; 
assign bias_arr[26] = 576; 
assign bias_arr[27] = 370; 
assign bias_arr[28] = 394; 
assign bias_arr[29] = 385; 
assign bias_arr[30] = 714; 
assign bias_arr[31] = 560; 


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
