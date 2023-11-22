module  layer2_feature_tx(
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

localparam      INDEX_END       =       'd43264                 ;


reg     [ 7:0]                  ch0_data_arr[43263:0]           ;
reg     [ 7:0]                  ch1_data_arr[43263:0]           ;
reg     [ 7:0]                  ch2_data_arr[43263:0]           ;
reg     [ 7:0]                  ch3_data_arr[43263:0]           ;
reg     [ 7:0]                  ch4_data_arr[43263:0]           ;
reg     [ 7:0]                  ch5_data_arr[43263:0]           ;
reg     [ 7:0]                  ch6_data_arr[43263:0]           ;
reg     [ 7:0]                  ch7_data_arr[43263:0]           ;
reg     [ 7:0]                  ch8_data_arr[43263:0]           ;
reg     [ 7:0]                  ch9_data_arr[43263:0]           ;
reg     [ 7:0]                  ch10_data_arr[43263:0]          ;
reg     [ 7:0]                  ch11_data_arr[43263:0]          ;
reg     [ 7:0]                  ch12_data_arr[43263:0]          ;
reg     [ 7:0]                  ch13_data_arr[43263:0]          ;
reg     [ 7:0]                  ch14_data_arr[43263:0]          ;
reg     [ 7:0]                  ch15_data_arr[43263:0]          ;
reg     [11:0]                  index                           ;       

reg                             state_tx_r1                     ;
reg     [15:0]                  batch0_index                    ;
reg     [15:0]                  batch1_index                    ;       

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
initial $readmemh("./txt/ch8_data.txt",  ch8_data_arr);
initial $readmemh("./txt/ch9_data.txt",  ch9_data_arr);
initial $readmemh("./txt/ch10_data.txt", ch10_data_arr);
initial $readmemh("./txt/ch11_data.txt", ch11_data_arr);
initial $readmemh("./txt/ch12_data.txt", ch12_data_arr);
initial $readmemh("./txt/ch13_data.txt", ch13_data_arr);
initial $readmemh("./txt/ch14_data.txt", ch14_data_arr);
initial $readmemh("./txt/ch15_data.txt", ch15_data_arr);

assign  feature_data  =      (batch_cnt == 'd0) ? 
                             {ch7_data_arr[batch0_index],
                              ch6_data_arr[batch0_index],
                              ch5_data_arr[batch0_index],
                              ch4_data_arr[batch0_index],
                              ch3_data_arr[batch0_index],
                              ch2_data_arr[batch0_index],
                              ch1_data_arr[batch0_index],
                              ch0_data_arr[batch0_index]} : 

                             {ch15_data_arr[batch1_index],
                              ch14_data_arr[batch1_index],
                              ch13_data_arr[batch1_index],
                              ch12_data_arr[batch1_index],
                              ch11_data_arr[batch1_index],
                              ch10_data_arr[batch1_index],
                              ch9_data_arr[batch1_index],
                              ch8_data_arr[batch1_index]};

assign  feature_last  =       (tx_cnt != 'd12 ) ? ((data_cnt == 19*208-1) ? 1'b1 : 1'b0) : 
                                                  ((data_cnt == 4*208-1) ? 1'b1 : 1'b0);

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
                batch0_index    <=      'd0;
        else if(batch_cnt == 'd0 && feature_valid == 1'b1 && ready == 1'b1 && batch0_index == (INDEX_END-1))
                batch0_index    <=      'd0;
        else if(state[4] == 1'b1 && state_tx_r1 == 1'b0 && tx_cnt >= 'd1 && batch_cnt == 'd0)
                batch0_index    <=      batch0_index - 208*2;
        else if(batch_cnt == 'd0 && feature_valid == 1'b1 && ready == 1'b1) 
                batch0_index    <=      batch0_index + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                batch1_index    <=      'd0;
        else if(batch_cnt == 'd1 && feature_valid == 1'b1 && ready == 1'b1 && batch1_index == (INDEX_END-1))
                batch1_index    <=      'd0;
        else if(state[4] == 1'b1 && state_tx_r1 == 1'b0 && tx_cnt >= 'd1 && batch_cnt == 'd0)
                batch1_index    <=      batch1_index - 208*2;
        else if(batch_cnt == 'd1 && feature_valid == 1'b1 && ready == 1'b1) 
                batch1_index    <=      batch1_index + 1'b1;
end

endmodule
