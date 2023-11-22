`timescale      1ns/1ns 

module  tb_max_pool_8ch;

reg             sclk;
reg             s_rst_n;

initial begin
        sclk    =       1;
        s_rst_n <=      0;
        #100
        s_rst_n <=      1;
end

always  #5      sclk    =       ~sclk;

/////////////////////////////////////////
reg     [ 7:0]  cnt;
wire            data_in_vld;
wire            padding_start;
reg     [ 7:0]  data_in;

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                cnt     <=      'd0;
        else 
                cnt     <=      cnt + 1'b1;
end

always  @(posedge sclk) begin
        data_in <=      {$random%256};
end

assign  data_in_vld     =       (cnt[3:0] >= 'd2 && cnt[3:0] <= 'd14 && cnt[7:4] <= 'd12) ? 1'b1 : 1'b0;

assign  padding_start   =       (cnt == 'd1) ? 1'b1 : 1'b0;


max_pool_8ch    max_pool_8ch_inst(
        // system signals
        .sclk                   (sclk                   ),       
        .s_rst_n                (s_rst_n                ),       
        //
        .padding_start          (padding_start          ),      
        .pool_stride            (1'b1                   ),       // 0:stride=2, 1:stride=1
        .ch0_data_in            (data_in                ),       
        .ch1_data_in            (data_in                ),       
        .ch2_data_in            (data_in                ),       
        .ch3_data_in            (data_in                ),       
        .ch4_data_in            (data_in                ),       
        .ch5_data_in            (data_in                ),       
        .ch6_data_in            (data_in                ),       
        .ch7_data_in            (data_in                ),       
        .data_in_vld            (data_in_vld            ),       
        //
        .ch0_data_out           (                       ),       
        .ch1_data_out           (                       ),       
        .ch2_data_out           (                       ),       
        .ch3_data_out           (                       ),       
        .ch4_data_out           (                       ),       
        .ch5_data_out           (                       ),       
        .ch6_data_out           (                       ),       
        .ch7_data_out           (                       ),       
        .data_out_vld           (                       )    
);

endmodule