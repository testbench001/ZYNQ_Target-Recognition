module  yolo_accel_top(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // Axi4-Lite Reg
        input           [31:0]  slave_lite_reg0         ,
        input           [31:0]  slave_lite_reg1         ,
        input           [31:0]  slave_lite_reg2         ,
        input           [31:0]  slave_lite_reg3         ,
        // Axi4-Stream Rx
        input           [63:0]  s_axis_mm2s_tdata       ,       
        input           [ 7:0]  s_axis_mm2s_tkeep       ,       
        input                   s_axis_mm2s_tvalid      ,       
        output  wire            s_axis_mm2s_tready      ,       
        input                   s_axis_mm2s_tlast       ,       
        // Axi4-Stream TX
        output  wire    [63:0]  s_axis_s2mm_tdata       ,       
        output  wire    [ 7:0]  s_axis_s2mm_tkeep       ,       
        output  wire            s_axis_s2mm_tvalid      ,       
        input                   s_axis_s2mm_tready      ,       
        output  wire            s_axis_s2mm_tlast       ,       
        // Generate Intr
        output  wire            task_finish                    
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
wire    [ 5:0]                  state                           ;       
wire    [ 1:0]                  data_type                       ;       
wire                            conv_type                       ;       
wire    [ 1:0]                  site_type                       ;       
wire    [ 1:0]                  batch_type                      ;       
wire    [ 2:0]                  feature_col_select              ;       
wire    [ 6:0]                  feature_row                     ;       
wire                            read_start                      ;       
wire                            is_pool                         ;       
wire                            pool_stride                     ;       
        
wire                            write_finish                    ;       
wire                            read_finish                     ;       
wire                            conv_finish                     ;       
wire                            upsample_finish                 ;       

wire    [ 7:0]                  bbuffer_rd_addr                 ;
wire    [ 7:0]                  wbuffer_rd_addr                 ;
wire                            weight_store_start              ;       
wire                            padding_start                   ;       

wire    [14:0]                  mult                            ;       
wire    [ 7:0]                  shift                           ;       
wire    [ 7:0]                  zero_point_in                   ;       
wire    [ 7:0]                  zero_point_out                  ;       

///////////////////////////////////////////////////////////////////
wire    [63:0]                  stream_rx_data                  ;       
wire                            stream_feature_vld              ;       
wire                            stream_weight_vld               ;       
wire                            stream_bias_vld                 ;       
wire                            stream_leakyrelu_vld            ;       

wire    signed  [31:0]          bias_ch0                        ;       
wire    signed  [31:0]          bias_ch1                        ;       
wire    signed  [31:0]          bias_ch2                        ;       
wire    signed  [31:0]          bias_ch3                        ;       
wire    signed  [31:0]          bias_ch4                        ;       
wire    signed  [31:0]          bias_ch5                        ;       
wire    signed  [31:0]          bias_ch6                        ;       
wire    signed  [31:0]          bias_ch7                        ;       

wire                            conv_buffer_rd_en               ;       
wire                            feature_buffer_rd_en            ;       
wire    [63:0]                  feature_buffer_rd_data          ;       

wire    [71:0]                  ch0_weight_3x3_0                ;       
wire    [71:0]                  ch0_weight_3x3_1                ;       
wire    [71:0]                  ch0_weight_3x3_2                ;       
wire    [71:0]                  ch0_weight_3x3_3                ;       
wire    [71:0]                  ch0_weight_3x3_4                ;       
wire    [71:0]                  ch0_weight_3x3_5                ;       
wire    [71:0]                  ch0_weight_3x3_6                ;       
wire    [71:0]                  ch0_weight_3x3_7                ;       

wire    [71:0]                  ch1_weight_3x3_0                ;       
wire    [71:0]                  ch1_weight_3x3_1                ;       
wire    [71:0]                  ch1_weight_3x3_2                ;       
wire    [71:0]                  ch1_weight_3x3_3                ;       
wire    [71:0]                  ch1_weight_3x3_4                ;       
wire    [71:0]                  ch1_weight_3x3_5                ;       
wire    [71:0]                  ch1_weight_3x3_6                ;       
wire    [71:0]                  ch1_weight_3x3_7                ;       

wire    [71:0]                  ch2_weight_3x3_0                ;       
wire    [71:0]                  ch2_weight_3x3_1                ;       
wire    [71:0]                  ch2_weight_3x3_2                ;       
wire    [71:0]                  ch2_weight_3x3_3                ;       
wire    [71:0]                  ch2_weight_3x3_4                ;       
wire    [71:0]                  ch2_weight_3x3_5                ;       
wire    [71:0]                  ch2_weight_3x3_6                ;       
wire    [71:0]                  ch2_weight_3x3_7                ;       

wire    [71:0]                  ch3_weight_3x3_0                ;       
wire    [71:0]                  ch3_weight_3x3_1                ;       
wire    [71:0]                  ch3_weight_3x3_2                ;       
wire    [71:0]                  ch3_weight_3x3_3                ;       
wire    [71:0]                  ch3_weight_3x3_4                ;       
wire    [71:0]                  ch3_weight_3x3_5                ;       
wire    [71:0]                  ch3_weight_3x3_6                ;       
wire    [71:0]                  ch3_weight_3x3_7                ;       

wire    [71:0]                  ch4_weight_3x3_0                ;       
wire    [71:0]                  ch4_weight_3x3_1                ;       
wire    [71:0]                  ch4_weight_3x3_2                ;       
wire    [71:0]                  ch4_weight_3x3_3                ;       
wire    [71:0]                  ch4_weight_3x3_4                ;       
wire    [71:0]                  ch4_weight_3x3_5                ;       
wire    [71:0]                  ch4_weight_3x3_6                ;       
wire    [71:0]                  ch4_weight_3x3_7                ;       

wire    [71:0]                  ch5_weight_3x3_0                ;       
wire    [71:0]                  ch5_weight_3x3_1                ;       
wire    [71:0]                  ch5_weight_3x3_2                ;       
wire    [71:0]                  ch5_weight_3x3_3                ;       
wire    [71:0]                  ch5_weight_3x3_4                ;       
wire    [71:0]                  ch5_weight_3x3_5                ;       
wire    [71:0]                  ch5_weight_3x3_6                ;       
wire    [71:0]                  ch5_weight_3x3_7                ;       

wire    [71:0]                  ch6_weight_3x3_0                ;       
wire    [71:0]                  ch6_weight_3x3_1                ;       
wire    [71:0]                  ch6_weight_3x3_2                ;       
wire    [71:0]                  ch6_weight_3x3_3                ;       
wire    [71:0]                  ch6_weight_3x3_4                ;       
wire    [71:0]                  ch6_weight_3x3_5                ;       
wire    [71:0]                  ch6_weight_3x3_6                ;       
wire    [71:0]                  ch6_weight_3x3_7                ;       

wire    [71:0]                  ch7_weight_3x3_0                ;       
wire    [71:0]                  ch7_weight_3x3_1                ;       
wire    [71:0]                  ch7_weight_3x3_2                ;       
wire    [71:0]                  ch7_weight_3x3_3                ;       
wire    [71:0]                  ch7_weight_3x3_4                ;       
wire    [71:0]                  ch7_weight_3x3_5                ;       
wire    [71:0]                  ch7_weight_3x3_6                ;       
wire    [71:0]                  ch7_weight_3x3_7                ;       

//////////////////////////////////////////////////////////////////////
wire signed   [23:0]            ch0_conv_out                    ;       
wire signed   [23:0]            ch1_conv_out                    ;       
wire signed   [23:0]            ch2_conv_out                    ;       
wire signed   [23:0]            ch3_conv_out                    ;       
wire signed   [23:0]            ch4_conv_out                    ;       
wire signed   [23:0]            ch5_conv_out                    ;       
wire signed   [23:0]            ch6_conv_out                    ;       
wire signed   [23:0]            ch7_conv_out                    ;       
wire                            ch_conv_out_vld                 ;       
/////////////////////////////////////////////////////////////////////
// Int8 Result
wire    [ 7:0]                  ch0_quant_out                   ;       
wire    [ 7:0]                  ch1_quant_out                   ;       
wire    [ 7:0]                  ch2_quant_out                   ;       
wire    [ 7:0]                  ch3_quant_out                   ;       
wire    [ 7:0]                  ch4_quant_out                   ;       
wire    [ 7:0]                  ch5_quant_out                   ;       
wire    [ 7:0]                  ch6_quant_out                   ;       
wire    [ 7:0]                  ch7_quant_out                   ;       
wire                            quant_out_vld                   ;       
// Act Result
wire    [ 7:0]                  ch0_act_out                     ;       
wire    [ 7:0]                  ch1_act_out                     ;       
wire    [ 7:0]                  ch2_act_out                     ;       
wire    [ 7:0]                  ch3_act_out                     ;       
wire    [ 7:0]                  ch4_act_out                     ;       
wire    [ 7:0]                  ch5_act_out                     ;       
wire    [ 7:0]                  ch6_act_out                     ;       
wire    [ 7:0]                  ch7_act_out                     ;       
wire    [63:0]                  act_out_data                    ;       
wire                            act_out_vld                     ;       
// Pool Reslut
wire    [ 7:0]                  ch0_pool_out                     ;       
wire    [ 7:0]                  ch1_pool_out                     ;       
wire    [ 7:0]                  ch2_pool_out                     ;       
wire    [ 7:0]                  ch3_pool_out                     ;       
wire    [ 7:0]                  ch4_pool_out                     ;       
wire    [ 7:0]                  ch5_pool_out                     ;       
wire    [ 7:0]                  ch6_pool_out                     ;       
wire    [ 7:0]                  ch7_pool_out                     ;       
wire                            pool_out_vld                     ;  


wire    [63:0]                  pool_out_data                   ;       
// Tx Buffer
wire    [63:0]                  tx_buffer_rd_data               ;       
wire                            tx_buffer_rd_en                 ;   
wire    [63:0]                  tx_buffer_wr_data               ;
wire                            tx_buffer_wr_en                 ;
wire    [12:0]                  buffer_data_count               ;       


wire                            up_buffer_rd_en                 ;       
wire    [63:0]                  up_axis_tdata                   ;       
wire                            up_axis_tvalid                  ;       
wire                            up_axis_tlast                   ;       

wire    [63:0]                  axis_s2mm_tdata                 ;       
wire                            axis_s2mm_tvalid                ;       
wire                            axis_s2mm_tlast                 ;       


//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  pool_out_data           =       {ch7_pool_out, 
                                         ch6_pool_out,
                                         ch5_pool_out,
                                         ch4_pool_out,
                                         ch3_pool_out,
                                         ch2_pool_out,
                                         ch1_pool_out,
                                         ch0_pool_out};
                                         
assign  act_out_data            =       {ch7_act_out, 
                                         ch6_act_out,
                                         ch5_act_out,
                                         ch4_act_out,
                                         ch3_act_out,
                                         ch2_act_out,
                                         ch1_act_out,
                                         ch0_act_out};
                                         
assign  feature_buffer_rd_en    =       (state[4] == 1'b1) ? up_buffer_rd_en : conv_buffer_rd_en;
assign  s_axis_s2mm_tdata       =       (state[4] == 1'b1) ? up_axis_tdata : axis_s2mm_tdata;
assign  s_axis_s2mm_tvalid      =       (state[4] == 1'b1) ? up_axis_tvalid : axis_s2mm_tvalid;
assign  s_axis_s2mm_tlast       =       (state[4] == 1'b1) ? up_axis_tlast : axis_s2mm_tlast;
assign  s_axis_s2mm_tkeep       =       8'hff;


assign  tx_buffer_wr_en         =       (is_pool == 1'b1) ? pool_out_vld : act_out_vld;
assign  tx_buffer_wr_data       =       (is_pool == 1'b1) ? pool_out_data : act_out_data;

main_ctrl       U1_main_ctrl_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Axi4-Lite Reg
        .slave_lite_reg0        (slave_lite_reg0        ),
        .slave_lite_reg1        (slave_lite_reg1        ),
        .slave_lite_reg2        (slave_lite_reg2        ),
        .slave_lite_reg3        (slave_lite_reg3        ),
        // 
        .read_start             (read_start             ),
        .state                  (state                  ),
        .data_type              (data_type              ),
        .conv_type              (conv_type              ),
        .site_type              (site_type              ),
        .batch_type             (batch_type             ),
        .feature_col_select     (feature_col_select     ),
        .feature_row            (feature_row            ),
        .bbuffer_rd_addr        (bbuffer_rd_addr        ),
        .wbuffer_rd_addr        (wbuffer_rd_addr        ),
        .mult                   (mult                   ),
        .shift                  (shift                  ),
        .zero_point_in          (zero_point_in          ),
        .zero_point_out         (zero_point_out         ),

        .write_finish           (write_finish           ),
        .read_finish            (read_finish            ),
        .conv_finish            (conv_finish            ),
        .upsample_finish        (upsample_finish        ),
        .task_finish            (task_finish            ),
        .weight_store_start     (weight_store_start     ),
        .conv1x1_start          (conv1x1_start          ),
        .padding_start          (padding_start          ),
        .pool_stride            (pool_stride            ),
        .is_pool                (is_pool                ) 
);

stream_rx       U2_stream_rx_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Stream Rx
        .s_axis_mm2s_tdata      (s_axis_mm2s_tdata      ),
        .s_axis_mm2s_tkeep      (s_axis_mm2s_tkeep      ),
        .s_axis_mm2s_tvalid     (s_axis_mm2s_tvalid     ),
        .s_axis_mm2s_tready     (s_axis_mm2s_tready     ),
        .s_axis_mm2s_tlast      (s_axis_mm2s_tlast      ),
        // Main Ctrl
        .data_type              (data_type              ),
        .state                  (state                  ),
        .write_finish           (write_finish           ),
        // 
        .stream_rx_data         (stream_rx_data         ),
        .stream_feature_vld     (stream_feature_vld     ),
        .stream_weight_vld      (stream_weight_vld      ),
        .stream_bias_vld        (stream_bias_vld        ),
        .stream_leakyrelu_vld   (stream_leakyrelu_vld   )
);

bias_buffer     U3_bias_buffer_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Stream Data
        .stream_rx_data         (stream_rx_data         ),
        .stream_bias_vld        (stream_bias_vld        ),
        .write_finish           (write_finish           ),
        // 
        .bias_rd_addr           (bbuffer_rd_addr        ),
        .bias_ch0               (bias_ch0               ),
        .bias_ch1               (bias_ch1               ),
        .bias_ch2               (bias_ch2               ),
        .bias_ch3               (bias_ch3               ),
        .bias_ch4               (bias_ch4               ),
        .bias_ch5               (bias_ch5               ),
        .bias_ch6               (bias_ch6               ),
        .bias_ch7               (bias_ch7               )
);

feature_buffer  U4_feature_buffer_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Stream Data
        .stream_rx_data         (stream_rx_data         ),
        .stream_feature_vld     (stream_feature_vld     ),
        // Read
        .feature_buffer_rd_en   (feature_buffer_rd_en   ),
        .feature_buffer_rd_data (feature_buffer_rd_data ),
        //
        .zero_point_in          (zero_point_in          )
);

weight_top_buffer       U5_weight_top_buffer_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Stream Data
        .weight_data_in         (stream_rx_data         ),
        .weight_data_in_vld     (stream_weight_vld      ),
        // 
        .store_start            (weight_store_start     ),
        .wbuffer_rd_addr        (wbuffer_rd_addr        ),
        .conv_type              (conv_type              ),
        // 
        .ch0_weight_3x3_0       (ch0_weight_3x3_0       ),
        .ch0_weight_3x3_1       (ch0_weight_3x3_1       ),
        .ch0_weight_3x3_2       (ch0_weight_3x3_2       ),
        .ch0_weight_3x3_3       (ch0_weight_3x3_3       ),
        .ch0_weight_3x3_4       (ch0_weight_3x3_4       ),
        .ch0_weight_3x3_5       (ch0_weight_3x3_5       ),
        .ch0_weight_3x3_6       (ch0_weight_3x3_6       ),
        .ch0_weight_3x3_7       (ch0_weight_3x3_7       ),

        .ch1_weight_3x3_0       (ch1_weight_3x3_0       ),
        .ch1_weight_3x3_1       (ch1_weight_3x3_1       ),
        .ch1_weight_3x3_2       (ch1_weight_3x3_2       ),
        .ch1_weight_3x3_3       (ch1_weight_3x3_3       ),
        .ch1_weight_3x3_4       (ch1_weight_3x3_4       ),
        .ch1_weight_3x3_5       (ch1_weight_3x3_5       ),
        .ch1_weight_3x3_6       (ch1_weight_3x3_6       ),
        .ch1_weight_3x3_7       (ch1_weight_3x3_7       ),

        .ch2_weight_3x3_0       (ch2_weight_3x3_0       ),
        .ch2_weight_3x3_1       (ch2_weight_3x3_1       ),
        .ch2_weight_3x3_2       (ch2_weight_3x3_2       ),
        .ch2_weight_3x3_3       (ch2_weight_3x3_3       ),
        .ch2_weight_3x3_4       (ch2_weight_3x3_4       ),
        .ch2_weight_3x3_5       (ch2_weight_3x3_5       ),
        .ch2_weight_3x3_6       (ch2_weight_3x3_6       ),
        .ch2_weight_3x3_7       (ch2_weight_3x3_7       ),

        .ch3_weight_3x3_0       (ch3_weight_3x3_0       ),
        .ch3_weight_3x3_1       (ch3_weight_3x3_1       ),
        .ch3_weight_3x3_2       (ch3_weight_3x3_2       ),
        .ch3_weight_3x3_3       (ch3_weight_3x3_3       ),
        .ch3_weight_3x3_4       (ch3_weight_3x3_4       ),
        .ch3_weight_3x3_5       (ch3_weight_3x3_5       ),
        .ch3_weight_3x3_6       (ch3_weight_3x3_6       ),
        .ch3_weight_3x3_7       (ch3_weight_3x3_7       ),

        .ch4_weight_3x3_0       (ch4_weight_3x3_0       ),
        .ch4_weight_3x3_1       (ch4_weight_3x3_1       ),
        .ch4_weight_3x3_2       (ch4_weight_3x3_2       ),
        .ch4_weight_3x3_3       (ch4_weight_3x3_3       ),
        .ch4_weight_3x3_4       (ch4_weight_3x3_4       ),
        .ch4_weight_3x3_5       (ch4_weight_3x3_5       ),
        .ch4_weight_3x3_6       (ch4_weight_3x3_6       ),
        .ch4_weight_3x3_7       (ch4_weight_3x3_7       ),

        .ch5_weight_3x3_0       (ch5_weight_3x3_0       ),
        .ch5_weight_3x3_1       (ch5_weight_3x3_1       ),
        .ch5_weight_3x3_2       (ch5_weight_3x3_2       ),
        .ch5_weight_3x3_3       (ch5_weight_3x3_3       ),
        .ch5_weight_3x3_4       (ch5_weight_3x3_4       ),
        .ch5_weight_3x3_5       (ch5_weight_3x3_5       ),
        .ch5_weight_3x3_6       (ch5_weight_3x3_6       ),
        .ch5_weight_3x3_7       (ch5_weight_3x3_7       ),

        .ch6_weight_3x3_0       (ch6_weight_3x3_0       ),
        .ch6_weight_3x3_1       (ch6_weight_3x3_1       ),
        .ch6_weight_3x3_2       (ch6_weight_3x3_2       ),
        .ch6_weight_3x3_3       (ch6_weight_3x3_3       ),
        .ch6_weight_3x3_4       (ch6_weight_3x3_4       ),
        .ch6_weight_3x3_5       (ch6_weight_3x3_5       ),
        .ch6_weight_3x3_6       (ch6_weight_3x3_6       ),
        .ch6_weight_3x3_7       (ch6_weight_3x3_7       ),

        .ch7_weight_3x3_0       (ch7_weight_3x3_0       ),
        .ch7_weight_3x3_1       (ch7_weight_3x3_1       ),
        .ch7_weight_3x3_2       (ch7_weight_3x3_2       ),
        .ch7_weight_3x3_3       (ch7_weight_3x3_3       ),
        .ch7_weight_3x3_4       (ch7_weight_3x3_4       ),
        .ch7_weight_3x3_5       (ch7_weight_3x3_5       ),
        .ch7_weight_3x3_6       (ch7_weight_3x3_6       ),
        .ch7_weight_3x3_7       (ch7_weight_3x3_7       )
);

leaky_relu      U6_leaky_relu_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Stream Data
        .stream_rx_data         (stream_rx_data         ),
        .stream_leakyrelu_vld   (stream_leakyrelu_vld   ),
        .write_finish           (write_finish           ),
        //
        .ch0_data_i             (ch0_quant_out          ),
        .ch1_data_i             (ch1_quant_out          ),
        .ch2_data_i             (ch2_quant_out          ),
        .ch3_data_i             (ch3_quant_out          ),
        .ch4_data_i             (ch4_quant_out          ),
        .ch5_data_i             (ch5_quant_out          ),
        .ch6_data_i             (ch6_quant_out          ),
        .ch7_data_i             (ch7_quant_out          ),
        .ch_data_vld_i          (quant_out_vld          ),
        //
        .ch0_data_o             (ch0_act_out            ),
        .ch1_data_o             (ch1_act_out            ),
        .ch2_data_o             (ch2_act_out            ),
        .ch3_data_o             (ch3_act_out            ),
        .ch4_data_o             (ch4_act_out            ),
        .ch5_data_o             (ch5_act_out            ),
        .ch6_data_o             (ch6_act_out            ),
        .ch7_data_o             (ch7_act_out            ),
        .ch_data_vld_o          (act_out_vld            )
);

conv_kernel_top         U7_conv_kernel_top_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Lite Reg
        .padding_start          (padding_start          ),
        .conv1x1_start          (conv1x1_start          ),
        .conv_type              (conv_type              ),
        .site_type              (site_type              ),
        .feature_col_select     (feature_col_select     ),
        .feature_row            (feature_row            ),
        .conv_finish            (conv_finish            ),
        //
        .buffer_rd_data         (feature_buffer_rd_data ),
        .buffer_rd_en           (conv_buffer_rd_en      ),
        //
        .ch0_weight_0           (ch0_weight_3x3_0       ),
        .ch0_weight_1           (ch0_weight_3x3_1       ),
        .ch0_weight_2           (ch0_weight_3x3_2       ),
        .ch0_weight_3           (ch0_weight_3x3_3       ),
        .ch0_weight_4           (ch0_weight_3x3_4       ),
        .ch0_weight_5           (ch0_weight_3x3_5       ),
        .ch0_weight_6           (ch0_weight_3x3_6       ),
        .ch0_weight_7           (ch0_weight_3x3_7       ),
                                                   
        .ch1_weight_0           (ch1_weight_3x3_0       ),
        .ch1_weight_1           (ch1_weight_3x3_1       ),
        .ch1_weight_2           (ch1_weight_3x3_2       ),
        .ch1_weight_3           (ch1_weight_3x3_3       ),
        .ch1_weight_4           (ch1_weight_3x3_4       ),
        .ch1_weight_5           (ch1_weight_3x3_5       ),
        .ch1_weight_6           (ch1_weight_3x3_6       ),
        .ch1_weight_7           (ch1_weight_3x3_7       ),
                                                   
        .ch2_weight_0           (ch2_weight_3x3_0       ),
        .ch2_weight_1           (ch2_weight_3x3_1       ),
        .ch2_weight_2           (ch2_weight_3x3_2       ),
        .ch2_weight_3           (ch2_weight_3x3_3       ),
        .ch2_weight_4           (ch2_weight_3x3_4       ),
        .ch2_weight_5           (ch2_weight_3x3_5       ),
        .ch2_weight_6           (ch2_weight_3x3_6       ),
        .ch2_weight_7           (ch2_weight_3x3_7       ),
                                                   
        .ch3_weight_0           (ch3_weight_3x3_0       ),
        .ch3_weight_1           (ch3_weight_3x3_1       ),
        .ch3_weight_2           (ch3_weight_3x3_2       ),
        .ch3_weight_3           (ch3_weight_3x3_3       ),
        .ch3_weight_4           (ch3_weight_3x3_4       ),
        .ch3_weight_5           (ch3_weight_3x3_5       ),
        .ch3_weight_6           (ch3_weight_3x3_6       ),
        .ch3_weight_7           (ch3_weight_3x3_7       ),
                                                   
        .ch4_weight_0           (ch4_weight_3x3_0       ),
        .ch4_weight_1           (ch4_weight_3x3_1       ),
        .ch4_weight_2           (ch4_weight_3x3_2       ),
        .ch4_weight_3           (ch4_weight_3x3_3       ),
        .ch4_weight_4           (ch4_weight_3x3_4       ),
        .ch4_weight_5           (ch4_weight_3x3_5       ),
        .ch4_weight_6           (ch4_weight_3x3_6       ),
        .ch4_weight_7           (ch4_weight_3x3_7       ),
                                                   
        .ch5_weight_0           (ch5_weight_3x3_0       ),
        .ch5_weight_1           (ch5_weight_3x3_1       ),
        .ch5_weight_2           (ch5_weight_3x3_2       ),
        .ch5_weight_3           (ch5_weight_3x3_3       ),
        .ch5_weight_4           (ch5_weight_3x3_4       ),
        .ch5_weight_5           (ch5_weight_3x3_5       ),
        .ch5_weight_6           (ch5_weight_3x3_6       ),
        .ch5_weight_7           (ch5_weight_3x3_7       ),
                                                   
        .ch6_weight_0           (ch6_weight_3x3_0       ),
        .ch6_weight_1           (ch6_weight_3x3_1       ),
        .ch6_weight_2           (ch6_weight_3x3_2       ),
        .ch6_weight_3           (ch6_weight_3x3_3       ),
        .ch6_weight_4           (ch6_weight_3x3_4       ),
        .ch6_weight_5           (ch6_weight_3x3_5       ),
        .ch6_weight_6           (ch6_weight_3x3_6       ),
        .ch6_weight_7           (ch6_weight_3x3_7       ),
                                                   
        .ch7_weight_0           (ch7_weight_3x3_0       ),
        .ch7_weight_1           (ch7_weight_3x3_1       ),
        .ch7_weight_2           (ch7_weight_3x3_2       ),
        .ch7_weight_3           (ch7_weight_3x3_3       ),
        .ch7_weight_4           (ch7_weight_3x3_4       ),
        .ch7_weight_5           (ch7_weight_3x3_5       ),
        .ch7_weight_6           (ch7_weight_3x3_6       ),
        .ch7_weight_7           (ch7_weight_3x3_7       ),
        //
        .ch0_bias               (bias_ch0               ),
        .ch1_bias               (bias_ch1               ),
        .ch2_bias               (bias_ch2               ),
        .ch3_bias               (bias_ch3               ),
        .ch4_bias               (bias_ch4               ),
        .ch5_bias               (bias_ch5               ),
        .ch6_bias               (bias_ch6               ),
        .ch7_bias               (bias_ch7               ),
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

quant_int8_8ch          U8_quant_int8_8ch_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .ch0_data_in            (ch0_conv_out           ),
        .ch1_data_in            (ch1_conv_out           ),
        .ch2_data_in            (ch2_conv_out           ),
        .ch3_data_in            (ch3_conv_out           ),
        .ch4_data_in            (ch4_conv_out           ),
        .ch5_data_in            (ch5_conv_out           ),
        .ch6_data_in            (ch6_conv_out           ),
        .ch7_data_in            (ch7_conv_out           ),
        .data_in_vld            (ch_conv_out_vld        ),
        //
        .mult                   (mult                   ),
        .shift                  (shift                  ),
        .zero_point             (zero_point_out         ),
        //
        .ch0_data_out           (ch0_quant_out          ),
        .ch1_data_out           (ch1_quant_out          ),
        .ch2_data_out           (ch2_quant_out          ),
        .ch3_data_out           (ch3_quant_out          ),
        .ch4_data_out           (ch4_quant_out          ),
        .ch5_data_out           (ch5_quant_out          ),
        .ch6_data_out           (ch6_quant_out          ),
        .ch7_data_out           (ch7_quant_out          ),
        .data_out_vld           (quant_out_vld          )
);

max_pool_8ch    U9_max_pool_8ch_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n & is_pool      ),
        //
        .padding_start          (padding_start          ),      
        .pool_stride            (pool_stride            ),       //
        .ch0_data_in            (ch0_act_out            ),
        .ch1_data_in            (ch1_act_out            ),
        .ch2_data_in            (ch2_act_out            ),
        .ch3_data_in            (ch3_act_out            ),
        .ch4_data_in            (ch4_act_out            ),
        .ch5_data_in            (ch5_act_out            ),
        .ch6_data_in            (ch6_act_out            ),
        .ch7_data_in            (ch7_act_out            ),
        .data_in_vld            (act_out_vld            ),
        //
        .ch0_data_out           (ch0_pool_out           ),
        .ch1_data_out           (ch1_pool_out           ),
        .ch2_data_out           (ch2_pool_out           ),
        .ch3_data_out           (ch3_pool_out           ),
        .ch4_data_out           (ch4_pool_out           ),
        .ch5_data_out           (ch5_pool_out           ),
        .ch6_data_out           (ch6_pool_out           ),
        .ch7_data_out           (ch7_pool_out           ),
        .data_out_vld           (pool_out_vld           )
);

tx_buffer       U10_tx_buffer_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // in 
        .buffer_wr_data         (tx_buffer_wr_data      ),
        .buffer_wr_en           (tx_buffer_wr_en        ),
        // Read
        .buffer_rd_en           (tx_buffer_rd_en        ),
        .buffer_rd_data         (tx_buffer_rd_data      ),
        //
        .read_start             (read_start             ),
        .buffer_data_count      (buffer_data_count      )
);

stream_tx       U11_stream_tx_inst(
        // system siganls
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .s_axis_s2mm_tdata      (axis_s2mm_tdata        ),
        .s_axis_s2mm_tvalid     (axis_s2mm_tvalid       ),
        .s_axis_s2mm_tready     (s_axis_s2mm_tready     ),
        .s_axis_s2mm_tlast      (axis_s2mm_tlast        ),
        // 
        .buffer_rd_en           (tx_buffer_rd_en        ),
        .buffer_rd_data         (tx_buffer_rd_data      ),
        .state                  (state                  ),
        .buffer_data_count      (buffer_data_count      ),
        .read_finish            (read_finish            )
);

upsample        U12_upsample_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .state                  (state                  ),
        .buffer_rd_en           (up_buffer_rd_en        ),
        .buffer_rd_data         (feature_buffer_rd_data ),
        // 
        .axis_tdata             (up_axis_tdata          ),
        .axis_tvalid            (up_axis_tvalid         ),
        .axis_tready            (s_axis_s2mm_tready     ),
        .axis_tlast             (up_axis_tlast          ),
        .upsample_finish        (upsample_finish        )
);


endmodule
