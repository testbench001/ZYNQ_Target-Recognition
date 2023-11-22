module  layer13_weight_tx(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        output  wire    [63:0]  weight_data             ,       
        output  reg             weight_valid            ,       
        output  wire            weight_last             ,       
        input                   ready                          
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
localparam      INDEX_END       =       'd1024                   ;


reg     [ 7:0]                  ch0_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch1_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch2_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch3_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch4_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch5_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch6_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch7_data_arr[INDEX_END-1:0]     ;
reg     [10:0]                  index                           ;       


//=============================================================================
//**************    Main Code   **************
//=============================================================================
initial $readmemh("./txt/layer13_weight_ch0.txt", ch0_data_arr);
initial $readmemh("./txt/layer13_weight_ch1.txt", ch1_data_arr);
initial $readmemh("./txt/layer13_weight_ch2.txt", ch2_data_arr);
initial $readmemh("./txt/layer13_weight_ch3.txt", ch3_data_arr);
initial $readmemh("./txt/layer13_weight_ch4.txt", ch4_data_arr);
initial $readmemh("./txt/layer13_weight_ch5.txt", ch5_data_arr);
initial $readmemh("./txt/layer13_weight_ch6.txt", ch6_data_arr);
initial $readmemh("./txt/layer13_weight_ch7.txt", ch7_data_arr);

assign  weight_data  =       {ch7_data_arr[index],
                              ch6_data_arr[index],
                              ch5_data_arr[index],  
                              ch4_data_arr[index],
                              ch3_data_arr[index],
                              ch2_data_arr[index],
                              ch1_data_arr[index],
                              ch0_data_arr[index]};

assign  weight_last  =       (index == (INDEX_END-1)) ? 1'b1 : 1'b0;

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                weight_valid      <=      1'b0;
        else if(index < (INDEX_END-1))
                weight_valid      <=      1'b1;
        else
                weight_valid      <=      1'b0;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                index   <=      'd0;
        else if(weight_valid == 1'b1 && ready == 1'b1 && index < INDEX_END)
                index   <=      index + 1'b1;
end


endmodule
