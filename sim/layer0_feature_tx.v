module  layer0_feature_tx(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        output  wire    [63:0]  feature_data            ,       
        output  reg             feature_valid           ,       
        output  wire            feature_last            ,       
        input                   ready                   ,

        input           [ 7:0]  tx_cnt                  , 
        input           [ 7:0]  state                  
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

reg     [ 7:0]                  data_arr[1384448-1:0]           ;
reg     [23:0]                  index                           ;       

reg     [15:0]                  data_cnt                        ;
reg                             state_tx_r1                     ;
//=============================================================================
//**************    Main Code   **************
//=============================================================================
initial $readmemh("./txt/img_data.txt", data_arr);

assign  feature_data  =       {data_arr[7+index*8], data_arr[6+index*8],
                               data_arr[5+index*8], data_arr[4+index*8],
                               data_arr[3+index*8], data_arr[2+index*8],
                               data_arr[1+index*8], data_arr[0+index*8]};


assign  feature_last  =       (tx_cnt != 'd59 ) ? ((data_cnt == 9*416-1) ? 1'b1 : 1'b0) : 
                                                  ((data_cnt == 3*416-1) ? 1'b1 : 1'b0);



always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                data_cnt        <=      'd0;
        else if(feature_last == 1'b1)
                data_cnt        <=      'd0;
        else if(feature_valid == 1'b1)
                data_cnt        <=      data_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                feature_valid      <=      1'b0;
        else if(feature_last == 1'b1)
                feature_valid   <=      1'b0;
        else if(state[4] == 1'b1 && state_tx_r1 == 1'b0)
                feature_valid   <=      1'b1;
end

always  @(posedge sclk) begin
        state_tx_r1     <=      state[4];
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                index   <=      'd0;
        else if(state[4] == 1'b1 && state_tx_r1 == 1'b0 && tx_cnt >= 'd1)
                index   <=      index - 416*2;
        else if(feature_valid == 1'b1 && ready == 1'b1)
                index   <=      index + 1'b1;
end


endmodule
