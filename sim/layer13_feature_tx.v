module  layer13_feature_tx(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        output  wire    [63:0]  feature_data            ,       
        output  reg             feature_valid           ,       
        output  wire            feature_last            ,       
        input                   ready                   ,
        //
        input           [ 6:0]  state                   ,
        input           [ 7:0]  batch_cnt               ,       
        input           [ 7:0]  tx_cnt                        
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

localparam      INDEX_END       =       'd21632                 ;


reg     [ 7:0]                  ch0_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch1_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch2_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch3_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch4_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch5_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch6_data_arr[INDEX_END-1:0]     ;
reg     [ 7:0]                  ch7_data_arr[INDEX_END-1:0]     ;

reg     [15:0]                  index                           ;       

reg                             state_tx_r1                     ;

reg     [15:0]                  data_cnt                        ;


//=============================================================================
//**************    Main Code   **************
//=============================================================================
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                data_cnt        <=      'd0;
        else if(feature_last == 1'b1)
                data_cnt        <=      'd0;
        else if(feature_valid == 1'b1)
                data_cnt        <=      data_cnt + 1'b1;
end


always  @(posedge sclk) begin
        state_tx_r1     <=      state[4];
end

initial $readmemh("./txt/ch0_data.txt",  ch0_data_arr);
initial $readmemh("./txt/ch1_data.txt",  ch1_data_arr);
initial $readmemh("./txt/ch2_data.txt",  ch2_data_arr);
initial $readmemh("./txt/ch3_data.txt",  ch3_data_arr);
initial $readmemh("./txt/ch4_data.txt",  ch4_data_arr);
initial $readmemh("./txt/ch5_data.txt",  ch5_data_arr);
initial $readmemh("./txt/ch6_data.txt",  ch6_data_arr);
initial $readmemh("./txt/ch7_data.txt",  ch7_data_arr);


assign  feature_data  =      {ch7_data_arr[index],
                              ch6_data_arr[index],
                              ch5_data_arr[index],
                              ch4_data_arr[index],
                              ch3_data_arr[index],
                              ch2_data_arr[index],
                              ch1_data_arr[index],
                              ch0_data_arr[index]};



assign  feature_last  =      (data_cnt == 13*13-1) ? 1'b1 : 1'b0;

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                feature_valid   <=      1'b0;
        else if(feature_last == 1'b1)
                feature_valid   <=      1'b0;
        else if(state[4] == 1'b1 && state_tx_r1 == 1'b0)
                feature_valid   <=      1'b1;
end


always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                index    <=      'd0;
        else if(feature_valid == 1'b1 && ready == 1'b1 )
                index    <=      index + 1'b1;

end

endmodule
