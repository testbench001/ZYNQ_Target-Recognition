module  weight_top_buffer(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // Stream Data
        input           [63:0]  weight_data_in          ,       
        input                   weight_data_in_vld      ,       
        // 
        input                   store_start             ,       
        input                   conv_type               ,
        input           [ 7:0]  wbuffer_rd_addr         ,   
        // 
        output  wire    [71:0]  ch0_weight_3x3_0        ,
        output  wire    [71:0]  ch0_weight_3x3_1        ,
        output  wire    [71:0]  ch0_weight_3x3_2        ,
        output  wire    [71:0]  ch0_weight_3x3_3        ,
        output  wire    [71:0]  ch0_weight_3x3_4        ,
        output  wire    [71:0]  ch0_weight_3x3_5        ,
        output  wire    [71:0]  ch0_weight_3x3_6        ,
        output  wire    [71:0]  ch0_weight_3x3_7        ,

        output  wire    [71:0]  ch1_weight_3x3_0        ,
        output  wire    [71:0]  ch1_weight_3x3_1        ,
        output  wire    [71:0]  ch1_weight_3x3_2        ,
        output  wire    [71:0]  ch1_weight_3x3_3        ,
        output  wire    [71:0]  ch1_weight_3x3_4        ,
        output  wire    [71:0]  ch1_weight_3x3_5        ,
        output  wire    [71:0]  ch1_weight_3x3_6        ,
        output  wire    [71:0]  ch1_weight_3x3_7        ,

        output  wire    [71:0]  ch2_weight_3x3_0        ,
        output  wire    [71:0]  ch2_weight_3x3_1        ,
        output  wire    [71:0]  ch2_weight_3x3_2        ,
        output  wire    [71:0]  ch2_weight_3x3_3        ,
        output  wire    [71:0]  ch2_weight_3x3_4        ,
        output  wire    [71:0]  ch2_weight_3x3_5        ,
        output  wire    [71:0]  ch2_weight_3x3_6        ,
        output  wire    [71:0]  ch2_weight_3x3_7        ,

        output  wire    [71:0]  ch3_weight_3x3_0        ,
        output  wire    [71:0]  ch3_weight_3x3_1        ,
        output  wire    [71:0]  ch3_weight_3x3_2        ,
        output  wire    [71:0]  ch3_weight_3x3_3        ,
        output  wire    [71:0]  ch3_weight_3x3_4        ,
        output  wire    [71:0]  ch3_weight_3x3_5        ,
        output  wire    [71:0]  ch3_weight_3x3_6        ,
        output  wire    [71:0]  ch3_weight_3x3_7        ,

        output  wire    [71:0]  ch4_weight_3x3_0        ,
        output  wire    [71:0]  ch4_weight_3x3_1        ,
        output  wire    [71:0]  ch4_weight_3x3_2        ,
        output  wire    [71:0]  ch4_weight_3x3_3        ,
        output  wire    [71:0]  ch4_weight_3x3_4        ,
        output  wire    [71:0]  ch4_weight_3x3_5        ,
        output  wire    [71:0]  ch4_weight_3x3_6        ,
        output  wire    [71:0]  ch4_weight_3x3_7        ,

        output  wire    [71:0]  ch5_weight_3x3_0        ,
        output  wire    [71:0]  ch5_weight_3x3_1        ,
        output  wire    [71:0]  ch5_weight_3x3_2        ,
        output  wire    [71:0]  ch5_weight_3x3_3        ,
        output  wire    [71:0]  ch5_weight_3x3_4        ,
        output  wire    [71:0]  ch5_weight_3x3_5        ,
        output  wire    [71:0]  ch5_weight_3x3_6        ,
        output  wire    [71:0]  ch5_weight_3x3_7        ,

        output  wire    [71:0]  ch6_weight_3x3_0        ,
        output  wire    [71:0]  ch6_weight_3x3_1        ,
        output  wire    [71:0]  ch6_weight_3x3_2        ,
        output  wire    [71:0]  ch6_weight_3x3_3        ,
        output  wire    [71:0]  ch6_weight_3x3_4        ,
        output  wire    [71:0]  ch6_weight_3x3_5        ,
        output  wire    [71:0]  ch6_weight_3x3_6        ,
        output  wire    [71:0]  ch6_weight_3x3_7        ,

        output  wire    [71:0]  ch7_weight_3x3_0        ,
        output  wire    [71:0]  ch7_weight_3x3_1        ,
        output  wire    [71:0]  ch7_weight_3x3_2        ,
        output  wire    [71:0]  ch7_weight_3x3_3        ,
        output  wire    [71:0]  ch7_weight_3x3_4        ,
        output  wire    [71:0]  ch7_weight_3x3_5        ,
        output  wire    [71:0]  ch7_weight_3x3_6        ,
        output  wire    [71:0]  ch7_weight_3x3_7        
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

     

localparam      DATA_CNT_END    =       'd9                     ;
localparam      CH_CNT_END      =       'd8                     ;

reg     [ 3:0]                  data_cnt                        ;       
reg                             wr_en                           ;       
reg     [ 2:0]                  ch_cnt                          ;       
reg     [ 7:0]                  wr_addr                         ;

wire    [ 7:0]                  ch0_weight_in                   ;       
wire    [ 7:0]                  ch1_weight_in                   ;       
wire    [ 7:0]                  ch2_weight_in                   ;       
wire    [ 7:0]                  ch3_weight_in                   ;       
wire    [ 7:0]                  ch4_weight_in                   ;       
wire    [ 7:0]                  ch5_weight_in                   ;       
wire    [ 7:0]                  ch6_weight_in                   ;       
wire    [ 7:0]                  ch7_weight_in                   ;  
//=============================================================================
//**************    Main Code   **************
//=============================================================================
assign  ch0_weight_in   =      weight_data_in[7:0]; 
assign  ch1_weight_in   =      weight_data_in[15:8]; 
assign  ch2_weight_in   =      weight_data_in[23:16]; 
assign  ch3_weight_in   =      weight_data_in[31:24]; 
assign  ch4_weight_in   =      weight_data_in[39:32]; 
assign  ch5_weight_in   =      weight_data_in[47:40]; 
assign  ch6_weight_in   =      weight_data_in[55:48]; 
assign  ch7_weight_in   =      weight_data_in[63:56]; 

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                data_cnt        <=      'd0;
        else if(weight_data_in_vld == 1'b1 && data_cnt == (DATA_CNT_END-1) && conv_type == 1'b0)
                data_cnt        <=      'd0;
        else if(weight_data_in_vld == 1'b1 && conv_type == 1'b0)
                data_cnt        <=      data_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                wr_en   <=      1'b0;
        else if(weight_data_in_vld == 1'b1 && data_cnt == (DATA_CNT_END-1) && conv_type == 1'b0)
                wr_en   <=      1'b1;
        else if(weight_data_in_vld == 1'b1 && conv_type == 1'b1)
                wr_en   <=      1'b1;
        else
                wr_en   <=      1'b0;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                ch_cnt  <=      'd0;
        else if(ch_cnt == (CH_CNT_END-1) && wr_en == 1'b1)
                ch_cnt  <=      'd0;
        else if(wr_en == 1'b1)
                ch_cnt  <=      ch_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                wr_addr <=      'd0;
        else if(store_start == 1'b1)
                wr_addr <=      'd0;
        else if(ch_cnt == (CH_CNT_END-1) && wr_en == 1'b1)
                wr_addr <=      wr_addr + 1'b1;
end

weight_single_buffer    ch0_weight_single_buffer(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Stream Data
        .weight_data_in_vld     (weight_data_in_vld     ),
        .weight_data_in         (ch0_weight_in          ),
        .wr_en                  (wr_en                  ),
        .wr_addr                (wr_addr                ),
        .ch_cnt                 (ch_cnt                 ),
        .conv_type              (conv_type              ),
        // 
        .wbuffer_rd_addr        (wbuffer_rd_addr        ),
        .ch0_weight_3x3         (ch0_weight_3x3_0       ),
        .ch1_weight_3x3         (ch0_weight_3x3_1       ),
        .ch2_weight_3x3         (ch0_weight_3x3_2       ),
        .ch3_weight_3x3         (ch0_weight_3x3_3       ),
        .ch4_weight_3x3         (ch0_weight_3x3_4       ),
        .ch5_weight_3x3         (ch0_weight_3x3_5       ),
        .ch6_weight_3x3         (ch0_weight_3x3_6       ),
        .ch7_weight_3x3         (ch0_weight_3x3_7       )
);

weight_single_buffer    ch1_weight_single_buffer(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Stream Data
        .weight_data_in_vld     (weight_data_in_vld     ),
        .weight_data_in         (ch1_weight_in          ),
        .wr_en                  (wr_en                  ),
        .wr_addr                (wr_addr                ),
        .ch_cnt                 (ch_cnt                 ),
        .conv_type              (conv_type              ),
        // 
        .wbuffer_rd_addr        (wbuffer_rd_addr        ),
        .ch0_weight_3x3         (ch1_weight_3x3_0       ),
        .ch1_weight_3x3         (ch1_weight_3x3_1       ),
        .ch2_weight_3x3         (ch1_weight_3x3_2       ),
        .ch3_weight_3x3         (ch1_weight_3x3_3       ),
        .ch4_weight_3x3         (ch1_weight_3x3_4       ),
        .ch5_weight_3x3         (ch1_weight_3x3_5       ),
        .ch6_weight_3x3         (ch1_weight_3x3_6       ),
        .ch7_weight_3x3         (ch1_weight_3x3_7       )
);

weight_single_buffer    ch2_weight_single_buffer(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Stream Data
        .weight_data_in_vld     (weight_data_in_vld     ),
        .weight_data_in         (ch2_weight_in          ),
        .wr_en                  (wr_en                  ),
        .wr_addr                (wr_addr                ),
        .ch_cnt                 (ch_cnt                 ),
        .conv_type              (conv_type              ),
        // 
        .wbuffer_rd_addr        (wbuffer_rd_addr        ),
        .ch0_weight_3x3         (ch2_weight_3x3_0       ),
        .ch1_weight_3x3         (ch2_weight_3x3_1       ),
        .ch2_weight_3x3         (ch2_weight_3x3_2       ),
        .ch3_weight_3x3         (ch2_weight_3x3_3       ),
        .ch4_weight_3x3         (ch2_weight_3x3_4       ),
        .ch5_weight_3x3         (ch2_weight_3x3_5       ),
        .ch6_weight_3x3         (ch2_weight_3x3_6       ),
        .ch7_weight_3x3         (ch2_weight_3x3_7       )
);


weight_single_buffer    ch3_weight_single_buffer(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Stream Data
        .weight_data_in_vld     (weight_data_in_vld     ),
        .weight_data_in         (ch3_weight_in          ),
        .wr_en                  (wr_en                  ),
        .wr_addr                (wr_addr                ),
        .ch_cnt                 (ch_cnt                 ),
        .conv_type              (conv_type              ),
        // 
        .wbuffer_rd_addr        (wbuffer_rd_addr        ),
        .ch0_weight_3x3         (ch3_weight_3x3_0       ),
        .ch1_weight_3x3         (ch3_weight_3x3_1       ),
        .ch2_weight_3x3         (ch3_weight_3x3_2       ),
        .ch3_weight_3x3         (ch3_weight_3x3_3       ),
        .ch4_weight_3x3         (ch3_weight_3x3_4       ),
        .ch5_weight_3x3         (ch3_weight_3x3_5       ),
        .ch6_weight_3x3         (ch3_weight_3x3_6       ),
        .ch7_weight_3x3         (ch3_weight_3x3_7       )
);

weight_single_buffer    ch4_weight_single_buffer(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Stream Data
        .weight_data_in_vld     (weight_data_in_vld     ),
        .weight_data_in         (ch4_weight_in          ),
        .wr_en                  (wr_en                  ),
        .wr_addr                (wr_addr                ),
        .ch_cnt                 (ch_cnt                 ),
        .conv_type              (conv_type              ),
        // 
        .wbuffer_rd_addr        (wbuffer_rd_addr        ),
        .ch0_weight_3x3         (ch4_weight_3x3_0       ),
        .ch1_weight_3x3         (ch4_weight_3x3_1       ),
        .ch2_weight_3x3         (ch4_weight_3x3_2       ),
        .ch3_weight_3x3         (ch4_weight_3x3_3       ),
        .ch4_weight_3x3         (ch4_weight_3x3_4       ),
        .ch5_weight_3x3         (ch4_weight_3x3_5       ),
        .ch6_weight_3x3         (ch4_weight_3x3_6       ),
        .ch7_weight_3x3         (ch4_weight_3x3_7       )
);

weight_single_buffer    ch5_weight_single_buffer(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Stream Data
        .weight_data_in_vld     (weight_data_in_vld     ),
        .weight_data_in         (ch5_weight_in          ),
        .wr_en                  (wr_en                  ),
        .wr_addr                (wr_addr                ),
        .ch_cnt                 (ch_cnt                 ),
        .conv_type              (conv_type              ),
        // 
        .wbuffer_rd_addr        (wbuffer_rd_addr        ),
        .ch0_weight_3x3         (ch5_weight_3x3_0       ),
        .ch1_weight_3x3         (ch5_weight_3x3_1       ),
        .ch2_weight_3x3         (ch5_weight_3x3_2       ),
        .ch3_weight_3x3         (ch5_weight_3x3_3       ),
        .ch4_weight_3x3         (ch5_weight_3x3_4       ),
        .ch5_weight_3x3         (ch5_weight_3x3_5       ),
        .ch6_weight_3x3         (ch5_weight_3x3_6       ),
        .ch7_weight_3x3         (ch5_weight_3x3_7       )
);

weight_single_buffer    ch6_weight_single_buffer(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Stream Data
        .weight_data_in_vld     (weight_data_in_vld     ),
        .weight_data_in         (ch6_weight_in          ),
        .wr_en                  (wr_en                  ),
        .wr_addr                (wr_addr                ),
        .ch_cnt                 (ch_cnt                 ),
        .conv_type              (conv_type              ),
        // 
        .wbuffer_rd_addr        (wbuffer_rd_addr        ),
        .ch0_weight_3x3         (ch6_weight_3x3_0       ),
        .ch1_weight_3x3         (ch6_weight_3x3_1       ),
        .ch2_weight_3x3         (ch6_weight_3x3_2       ),
        .ch3_weight_3x3         (ch6_weight_3x3_3       ),
        .ch4_weight_3x3         (ch6_weight_3x3_4       ),
        .ch5_weight_3x3         (ch6_weight_3x3_5       ),
        .ch6_weight_3x3         (ch6_weight_3x3_6       ),
        .ch7_weight_3x3         (ch6_weight_3x3_7       )
);

weight_single_buffer    ch7_weight_single_buffer(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Stream Data
        .weight_data_in_vld     (weight_data_in_vld     ),
        .weight_data_in         (ch7_weight_in          ),
        .wr_en                  (wr_en                  ),
        .wr_addr                (wr_addr                ),
        .ch_cnt                 (ch_cnt                 ),
        .conv_type              (conv_type              ),
        // 
        .wbuffer_rd_addr        (wbuffer_rd_addr        ),
        .ch0_weight_3x3         (ch7_weight_3x3_0       ),
        .ch1_weight_3x3         (ch7_weight_3x3_1       ),
        .ch2_weight_3x3         (ch7_weight_3x3_2       ),
        .ch3_weight_3x3         (ch7_weight_3x3_3       ),
        .ch4_weight_3x3         (ch7_weight_3x3_4       ),
        .ch5_weight_3x3         (ch7_weight_3x3_5       ),
        .ch6_weight_3x3         (ch7_weight_3x3_6       ),
        .ch7_weight_3x3         (ch7_weight_3x3_7       )
);
endmodule
