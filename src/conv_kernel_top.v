module  conv_kernel_top(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // Lite Reg
        input                   padding_start           ,       
        input                   conv1x1_start           ,       
        input                   conv_type               ,       
        input           [ 1:0]  site_type               ,       
        input           [ 2:0]  feature_col_select      ,       
        input           [ 6:0]  feature_row             ,   
        output  wire            conv_finish             ,
        //
        input           [63:0]  buffer_rd_data          ,       
        output  wire            buffer_rd_en            ,      
        //
        input           [71:0]  ch0_weight_0            ,       
        input           [71:0]  ch0_weight_1            ,       
        input           [71:0]  ch0_weight_2            ,       
        input           [71:0]  ch0_weight_3            ,       
        input           [71:0]  ch0_weight_4            ,       
        input           [71:0]  ch0_weight_5            ,       
        input           [71:0]  ch0_weight_6            ,       
        input           [71:0]  ch0_weight_7            ,       

        input           [71:0]  ch1_weight_0            ,       
        input           [71:0]  ch1_weight_1            ,       
        input           [71:0]  ch1_weight_2            ,       
        input           [71:0]  ch1_weight_3            ,       
        input           [71:0]  ch1_weight_4            ,       
        input           [71:0]  ch1_weight_5            ,       
        input           [71:0]  ch1_weight_6            ,       
        input           [71:0]  ch1_weight_7            ,       

        input           [71:0]  ch2_weight_0            ,       
        input           [71:0]  ch2_weight_1            ,       
        input           [71:0]  ch2_weight_2            ,       
        input           [71:0]  ch2_weight_3            ,       
        input           [71:0]  ch2_weight_4            ,       
        input           [71:0]  ch2_weight_5            ,       
        input           [71:0]  ch2_weight_6            ,       
        input           [71:0]  ch2_weight_7            ,       

        input           [71:0]  ch3_weight_0            ,       
        input           [71:0]  ch3_weight_1            ,       
        input           [71:0]  ch3_weight_2            ,       
        input           [71:0]  ch3_weight_3            ,       
        input           [71:0]  ch3_weight_4            ,       
        input           [71:0]  ch3_weight_5            ,       
        input           [71:0]  ch3_weight_6            ,       
        input           [71:0]  ch3_weight_7            ,   

        input           [71:0]  ch4_weight_0            ,       
        input           [71:0]  ch4_weight_1            ,       
        input           [71:0]  ch4_weight_2            ,       
        input           [71:0]  ch4_weight_3            ,       
        input           [71:0]  ch4_weight_4            ,       
        input           [71:0]  ch4_weight_5            ,       
        input           [71:0]  ch4_weight_6            ,       
        input           [71:0]  ch4_weight_7            ,       

        input           [71:0]  ch5_weight_0            ,       
        input           [71:0]  ch5_weight_1            ,       
        input           [71:0]  ch5_weight_2            ,       
        input           [71:0]  ch5_weight_3            ,       
        input           [71:0]  ch5_weight_4            ,       
        input           [71:0]  ch5_weight_5            ,       
        input           [71:0]  ch5_weight_6            ,       
        input           [71:0]  ch5_weight_7            ,       

        input           [71:0]  ch6_weight_0            ,       
        input           [71:0]  ch6_weight_1            ,       
        input           [71:0]  ch6_weight_2            ,       
        input           [71:0]  ch6_weight_3            ,       
        input           [71:0]  ch6_weight_4            ,       
        input           [71:0]  ch6_weight_5            ,       
        input           [71:0]  ch6_weight_6            ,       
        input           [71:0]  ch6_weight_7            ,       

        input           [71:0]  ch7_weight_0            ,       
        input           [71:0]  ch7_weight_1            ,       
        input           [71:0]  ch7_weight_2            ,       
        input           [71:0]  ch7_weight_3            ,       
        input           [71:0]  ch7_weight_4            ,       
        input           [71:0]  ch7_weight_5            ,       
        input           [71:0]  ch7_weight_6            ,       
        input           [71:0]  ch7_weight_7            ,   
        //
        input   signed  [31:0]  ch0_bias                ,
        input   signed  [31:0]  ch1_bias                ,
        input   signed  [31:0]  ch2_bias                ,
        input   signed  [31:0]  ch3_bias                ,
        input   signed  [31:0]  ch4_bias                ,
        input   signed  [31:0]  ch5_bias                ,
        input   signed  [31:0]  ch6_bias                ,
        input   signed  [31:0]  ch7_bias                ,
        input           [ 1:0]  batch_type              ,       
        // 
        output  wire signed   [23:0]  ch0_conv_out      ,
        output  wire signed   [23:0]  ch1_conv_out      ,    
        output  wire signed   [23:0]  ch2_conv_out      ,
        output  wire signed   [23:0]  ch3_conv_out      ,    
        output  wire signed   [23:0]  ch4_conv_out      ,
        output  wire signed   [23:0]  ch5_conv_out      ,    
        output  wire signed   [23:0]  ch6_conv_out      ,
        output  wire signed   [23:0]  ch7_conv_out      ,    
        output  wire                  ch_conv_out_vld           
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
wire    [63:0]                  padding_data                    ;       
wire                            padding_data_vld                ;       
wire    [ 6:0]                  padding_row_cnt                 ;       
wire    [ 8:0]                  padding_col_cnt                 ;       

wire    [63:0]                  line2_data                      ;       
wire    [63:0]                  line1_data                      ;       
wire    [63:0]                  line0_data                      ;       
wire                            line_data_vld                   ;       

wire    [71:0]                  ch0_martix_3x3_data             ;       
wire    [71:0]                  ch1_martix_3x3_data             ;       
wire    [71:0]                  ch2_martix_3x3_data             ;       
wire    [71:0]                  ch3_martix_3x3_data             ;       
wire    [71:0]                  ch4_martix_3x3_data             ;       
wire    [71:0]                  ch5_martix_3x3_data             ;       
wire    [71:0]                  ch6_martix_3x3_data             ;       
wire    [71:0]                  ch7_martix_3x3_data             ;       
wire                            martix_3x3_data_vld             ;       


wire                            padding_finish                  ;       
wire                            conv1x1_read_finish             ;       

wire                            conv1_buffer_rd_en              ;       
wire                            conv3_buffer_rd_en              ;       

wire    [71:0]                  conv_ch0_data_in                ;       
wire    [71:0]                  conv_ch1_data_in                ;       
wire    [71:0]                  conv_ch2_data_in                ;       
wire    [71:0]                  conv_ch3_data_in                ;       
wire    [71:0]                  conv_ch4_data_in                ;       
wire    [71:0]                  conv_ch5_data_in                ;       
wire    [71:0]                  conv_ch6_data_in                ;       
wire    [71:0]                  conv_ch7_data_in                ;       
wire                            conv_ch_data_in_vld             ;       



//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  buffer_rd_en            =       (conv_type == 1'b0) ? conv3_buffer_rd_en : conv1_buffer_rd_en;
assign  conv_ch_data_in_vld     =       (conv_type == 1'b0) ? martix_3x3_data_vld : buffer_rd_en;
assign  conv_ch0_data_in        =       (conv_type == 1'b0) ? ch0_martix_3x3_data : {64'h0, buffer_rd_data[7:0]};
assign  conv_ch1_data_in        =       (conv_type == 1'b0) ? ch1_martix_3x3_data : {64'h0, buffer_rd_data[15:8]};
assign  conv_ch2_data_in        =       (conv_type == 1'b0) ? ch2_martix_3x3_data : {64'h0, buffer_rd_data[23:16]};
assign  conv_ch3_data_in        =       (conv_type == 1'b0) ? ch3_martix_3x3_data : {64'h0, buffer_rd_data[31:24]};
assign  conv_ch4_data_in        =       (conv_type == 1'b0) ? ch4_martix_3x3_data : {64'h0, buffer_rd_data[39:32]};
assign  conv_ch5_data_in        =       (conv_type == 1'b0) ? ch5_martix_3x3_data : {64'h0, buffer_rd_data[47:40]};
assign  conv_ch6_data_in        =       (conv_type == 1'b0) ? ch6_martix_3x3_data : {64'h0, buffer_rd_data[55:48]};
assign  conv_ch7_data_in        =       (conv_type == 1'b0) ? ch7_martix_3x3_data : {64'h0, buffer_rd_data[63:56]};


shift_reg #(
        .DLY_CNT                (17                     )   
)shift_reg_inst(
        .sclk                   (sclk                   ),       
        .data_in                (padding_finish | conv1x1_read_finish),       
        .data_out               (conv_finish            )       
);
conv1x1_read_ctrl       U0_conv1x1_read_ctrl_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Lite Reg
        .conv1x1_start          (conv1x1_start          ),
        .feature_col_select     (feature_col_select     ),
        .feature_row            (feature_row            ),
        //
        .buffer_rd_en           (conv1_buffer_rd_en     ),
        .conv1x1_read_finish    (conv1x1_read_finish    ),
        // 
        .row_cnt                (                       ),
        .col_cnt                (                       )

);

conv_padding            U1_conv_padding_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Lite Reg
        .padding_start          (padding_start          ),
        .site_type              (site_type              ),
        .feature_col_select     (feature_col_select     ),
        .feature_row            (feature_row            ),
        //
        .buffer_rd_data         (buffer_rd_data         ),
        .buffer_rd_en           (conv3_buffer_rd_en     ),
        .padding_data           (padding_data           ),
        .padding_data_vld       (padding_data_vld       ),
        .padding_finish         (padding_finish         ),
        //
        .row_cnt                (padding_row_cnt        ),
        .col_cnt                (padding_col_cnt        )
);

martix_3line            U2_martix_3line(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (padding_data           ),
        .data_in_vld            (padding_data_vld       ),
        .feature_col_select     (feature_col_select     ),
        .padding_row_cnt        (padding_row_cnt        ),
        //
        .line2_data             (line2_data             ),
        .line1_data             (line1_data             ),
        .line0_data             (line0_data             ),
        .line_data_vld          (line_data_vld          )
);

martix_3x3_top          U3_martix_3x3_top_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .line2_data             (line2_data             ),
        .line1_data             (line1_data             ),
        .line0_data             (line0_data             ),
        .line_data_vld          (line_data_vld          ),
        .padding_col_cnt        (padding_col_cnt        ),
        // 
        .ch0_martix_3x3_data    (ch0_martix_3x3_data    ),
        .ch1_martix_3x3_data    (ch1_martix_3x3_data    ),
        .ch2_martix_3x3_data    (ch2_martix_3x3_data    ),
        .ch3_martix_3x3_data    (ch3_martix_3x3_data    ),
        .ch4_martix_3x3_data    (ch4_martix_3x3_data    ),
        .ch5_martix_3x3_data    (ch5_martix_3x3_data    ),
        .ch6_martix_3x3_data    (ch6_martix_3x3_data    ),
        .ch7_martix_3x3_data    (ch7_martix_3x3_data    ),
        .martix_3x3_data_vld    (martix_3x3_data_vld    )
);

conv_kernel_8ch         U4_conv_kernel_8ch_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .ch0_data_in            (conv_ch0_data_in       ),
        .ch1_data_in            (conv_ch1_data_in       ),
        .ch2_data_in            (conv_ch2_data_in       ),
        .ch3_data_in            (conv_ch3_data_in       ),
        .ch4_data_in            (conv_ch4_data_in       ),
        .ch5_data_in            (conv_ch5_data_in       ),
        .ch6_data_in            (conv_ch6_data_in       ),
        .ch7_data_in            (conv_ch7_data_in       ),
        .ch_data_in_vld         (conv_ch_data_in_vld    ),

        .ch0_weight_0           (ch0_weight_0           ),
        .ch0_weight_1           (ch0_weight_1           ),
        .ch0_weight_2           (ch0_weight_2           ),
        .ch0_weight_3           (ch0_weight_3           ),
        .ch0_weight_4           (ch0_weight_4           ),
        .ch0_weight_5           (ch0_weight_5           ),
        .ch0_weight_6           (ch0_weight_6           ),
        .ch0_weight_7           (ch0_weight_7           ),

        .ch1_weight_0           (ch1_weight_0           ),
        .ch1_weight_1           (ch1_weight_1           ),
        .ch1_weight_2           (ch1_weight_2           ),
        .ch1_weight_3           (ch1_weight_3           ),
        .ch1_weight_4           (ch1_weight_4           ),
        .ch1_weight_5           (ch1_weight_5           ),
        .ch1_weight_6           (ch1_weight_6           ),
        .ch1_weight_7           (ch1_weight_7           ),

        .ch2_weight_0           (ch2_weight_0           ),
        .ch2_weight_1           (ch2_weight_1           ),
        .ch2_weight_2           (ch2_weight_2           ),
        .ch2_weight_3           (ch2_weight_3           ),
        .ch2_weight_4           (ch2_weight_4           ),
        .ch2_weight_5           (ch2_weight_5           ),
        .ch2_weight_6           (ch2_weight_6           ),
        .ch2_weight_7           (ch2_weight_7           ),

        .ch3_weight_0           (ch3_weight_0           ),
        .ch3_weight_1           (ch3_weight_1           ),
        .ch3_weight_2           (ch3_weight_2           ),
        .ch3_weight_3           (ch3_weight_3           ),
        .ch3_weight_4           (ch3_weight_4           ),
        .ch3_weight_5           (ch3_weight_5           ),
        .ch3_weight_6           (ch3_weight_6           ),
        .ch3_weight_7           (ch3_weight_7           ),

        .ch4_weight_0           (ch4_weight_0           ),
        .ch4_weight_1           (ch4_weight_1           ),
        .ch4_weight_2           (ch4_weight_2           ),
        .ch4_weight_3           (ch4_weight_3           ),
        .ch4_weight_4           (ch4_weight_4           ),
        .ch4_weight_5           (ch4_weight_5           ),
        .ch4_weight_6           (ch4_weight_6           ),
        .ch4_weight_7           (ch4_weight_7           ),

        .ch5_weight_0           (ch5_weight_0           ),
        .ch5_weight_1           (ch5_weight_1           ),
        .ch5_weight_2           (ch5_weight_2           ),
        .ch5_weight_3           (ch5_weight_3           ),
        .ch5_weight_4           (ch5_weight_4           ),
        .ch5_weight_5           (ch5_weight_5           ),
        .ch5_weight_6           (ch5_weight_6           ),
        .ch5_weight_7           (ch5_weight_7           ),

        .ch6_weight_0           (ch6_weight_0           ),
        .ch6_weight_1           (ch6_weight_1           ),
        .ch6_weight_2           (ch6_weight_2           ),
        .ch6_weight_3           (ch6_weight_3           ),
        .ch6_weight_4           (ch6_weight_4           ),
        .ch6_weight_5           (ch6_weight_5           ),
        .ch6_weight_6           (ch6_weight_6           ),
        .ch6_weight_7           (ch6_weight_7           ),

        .ch7_weight_0           (ch7_weight_0           ),
        .ch7_weight_1           (ch7_weight_1           ),
        .ch7_weight_2           (ch7_weight_2           ),
        .ch7_weight_3           (ch7_weight_3           ),
        .ch7_weight_4           (ch7_weight_4           ),
        .ch7_weight_5           (ch7_weight_5           ),
        .ch7_weight_6           (ch7_weight_6           ),
        .ch7_weight_7           (ch7_weight_7           ),
        //
        .ch0_bias               (ch0_bias               ),
        .ch1_bias               (ch1_bias               ),
        .ch2_bias               (ch2_bias               ),
        .ch3_bias               (ch3_bias               ),
        .ch4_bias               (ch4_bias               ),
        .ch5_bias               (ch5_bias               ),
        .ch6_bias               (ch6_bias               ),
        .ch7_bias               (ch7_bias               ),
        .batch_type             (batch_type             ),
        // 
        .ch0_conv_out           (ch0_conv_out           ),
        .ch1_conv_out           (ch1_conv_out           ),
        .ch2_conv_out           (ch2_conv_out           ),
        .ch3_conv_out           (ch3_conv_out           ),
        .ch4_conv_out           (ch4_conv_out           ),
        .ch5_conv_out           (ch5_conv_out           ),
        .ch6_conv_out           (ch6_conv_out           ),
        .ch7_conv_out           (ch7_conv_out           ),
        .ch_conv_out_vld        (ch_conv_out_vld        )
);

endmodule
