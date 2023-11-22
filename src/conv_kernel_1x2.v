module  conv_kernel_1x2(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // 
        input           [71:0]  data_in                 ,
        input           [71:0]  ch0_weight              ,
        input           [71:0]  ch1_weight              ,
        //
        output  wire signed    [19:0]   ch0_out         ,
        output  wire signed    [19:0]   ch1_out         
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

wire    signed  [ 7:0]          data_00                         ;
wire    signed  [ 7:0]          data_01                         ;
wire    signed  [ 7:0]          data_02                         ;
wire    signed  [ 7:0]          data_10                         ;
wire    signed  [ 7:0]          data_11                         ;
wire    signed  [ 7:0]          data_12                         ;
wire    signed  [ 7:0]          data_20                         ;
wire    signed  [ 7:0]          data_21                         ;
wire    signed  [ 7:0]          data_22                         ;

wire    signed  [ 7:0]          ch0_w_00                        ;
wire    signed  [ 7:0]          ch0_w_01                        ;
wire    signed  [ 7:0]          ch0_w_02                        ;
wire    signed  [ 7:0]          ch0_w_10                        ;
wire    signed  [ 7:0]          ch0_w_11                        ;
wire    signed  [ 7:0]          ch0_w_12                        ;
wire    signed  [ 7:0]          ch0_w_20                        ;
wire    signed  [ 7:0]          ch0_w_21                        ;
wire    signed  [ 7:0]          ch0_w_22                        ;

wire    signed  [ 7:0]          ch1_w_00                        ;
wire    signed  [ 7:0]          ch1_w_01                        ;
wire    signed  [ 7:0]          ch1_w_02                        ;
wire    signed  [ 7:0]          ch1_w_10                        ;
wire    signed  [ 7:0]          ch1_w_11                        ;
wire    signed  [ 7:0]          ch1_w_12                        ;
wire    signed  [ 7:0]          ch1_w_20                        ;
wire    signed  [ 7:0]          ch1_w_21                        ;
wire    signed  [ 7:0]          ch1_w_22                        ;

wire    signed  [15:0]          ch0_out_00                      ;
wire    signed  [15:0]          ch0_out_01                      ;
wire    signed  [15:0]          ch0_out_02                      ;
wire    signed  [15:0]          ch0_out_10                      ;
wire    signed  [15:0]          ch0_out_11                      ;
wire    signed  [15:0]          ch0_out_12                      ;
wire    signed  [15:0]          ch0_out_20                      ;
wire    signed  [15:0]          ch0_out_21                      ;
wire    signed  [15:0]          ch0_out_22                      ;

wire    signed  [15:0]          ch1_out_00                      ;
wire    signed  [15:0]          ch1_out_01                      ;
wire    signed  [15:0]          ch1_out_02                      ;
wire    signed  [15:0]          ch1_out_10                      ;
wire    signed  [15:0]          ch1_out_11                      ;
wire    signed  [15:0]          ch1_out_12                      ;
wire    signed  [15:0]          ch1_out_20                      ;
wire    signed  [15:0]          ch1_out_21                      ;
wire    signed  [15:0]          ch1_out_22                      ;

//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  data_00 =       data_in[7:0];
assign  data_10 =       data_in[15:8];
assign  data_20 =       data_in[23:16];
assign  data_01 =       data_in[31:24];
assign  data_11 =       data_in[39:32];
assign  data_21 =       data_in[47:40];
assign  data_02 =       data_in[55:48];
assign  data_12 =       data_in[63:56];
assign  data_22 =       data_in[71:64];

assign  ch0_w_00        =       ch0_weight[7:0];
assign  ch0_w_01        =       ch0_weight[15:8];
assign  ch0_w_02        =       ch0_weight[23:16];
assign  ch0_w_10        =       ch0_weight[31:24];
assign  ch0_w_11        =       ch0_weight[39:32];
assign  ch0_w_12        =       ch0_weight[47:40];
assign  ch0_w_20        =       ch0_weight[55:48];
assign  ch0_w_21        =       ch0_weight[63:56];
assign  ch0_w_22        =       ch0_weight[71:64];

assign  ch1_w_00        =       ch1_weight[7:0];
assign  ch1_w_01        =       ch1_weight[15:8];
assign  ch1_w_02        =       ch1_weight[23:16];
assign  ch1_w_10        =       ch1_weight[31:24];
assign  ch1_w_11        =       ch1_weight[39:32];
assign  ch1_w_12        =       ch1_weight[47:40];
assign  ch1_w_20        =       ch1_weight[55:48];
assign  ch1_w_21        =       ch1_weight[63:56];
assign  ch1_w_22        =       ch1_weight[71:64];


conv_mult_dsp   U00_conv_mult_dsp_inst(
        // system signals
        .sclk                   (sclk                   ),
        //
        .data_a                 (ch0_w_00               ),
        .data_d                 (ch1_w_00               ),
        .data_b                 (data_00                ),
        //
        .data_ab                (ch0_out_00             ),
        .data_db                (ch1_out_00             )
);

conv_mult_dsp   U01_conv_mult_dsp_inst(
        // system signals
        .sclk                   (sclk                   ),
        //
        .data_a                 (ch0_w_01               ),
        .data_d                 (ch1_w_01               ),
        .data_b                 (data_01                ),
        //
        .data_ab                (ch0_out_01             ),
        .data_db                (ch1_out_01             )
);

conv_mult_dsp   U02_conv_mult_dsp_inst(
        // system signals
        .sclk                   (sclk                   ),
        //
        .data_a                 (ch0_w_02               ),
        .data_d                 (ch1_w_02               ),
        .data_b                 (data_02                ),
        //
        .data_ab                (ch0_out_02             ),
        .data_db                (ch1_out_02             )
);

conv_mult_dsp   U10_conv_mult_dsp_inst(
        // system signals
        .sclk                   (sclk                   ),
        //
        .data_a                 (ch0_w_10               ),
        .data_d                 (ch1_w_10               ),
        .data_b                 (data_10                ),
        //
        .data_ab                (ch0_out_10             ),
        .data_db                (ch1_out_10             )
);

conv_mult_dsp   U11_conv_mult_dsp_inst(
        // system signals
        .sclk                   (sclk                   ),
        //
        .data_a                 (ch0_w_11               ),
        .data_d                 (ch1_w_11               ),
        .data_b                 (data_11                ),
        //
        .data_ab                (ch0_out_11             ),
        .data_db                (ch1_out_11             )
);

conv_mult_dsp   U12_conv_mult_dsp_inst(
        // system signals
        .sclk                   (sclk                   ),
        //
        .data_a                 (ch0_w_12               ),
        .data_d                 (ch1_w_12               ),
        .data_b                 (data_12                ),
        //
        .data_ab                (ch0_out_12             ),
        .data_db                (ch1_out_12             )
);

conv_mult_dsp   U20_conv_mult_dsp_inst(
        // system signals
        .sclk                   (sclk                   ),
        //
        .data_a                 (ch0_w_20               ),
        .data_d                 (ch1_w_20               ),
        .data_b                 (data_20                ),
        //
        .data_ab                (ch0_out_20             ),
        .data_db                (ch1_out_20             )
);

conv_mult_dsp   U21_conv_mult_dsp_inst(
        // system signals
        .sclk                   (sclk                   ),
        //
        .data_a                 (ch0_w_21               ),
        .data_d                 (ch1_w_21               ),
        .data_b                 (data_21                ),
        //
        .data_ab                (ch0_out_21             ),
        .data_db                (ch1_out_21             )
);

conv_mult_dsp   U22_conv_mult_dsp_inst(
        // system signals
        .sclk                   (sclk                   ),
        //
        .data_a                 (ch0_w_22               ),
        .data_d                 (ch1_w_22               ),
        .data_b                 (data_22                ),
        //
        .data_ab                (ch0_out_22             ),
        .data_db                (ch1_out_22             )
);

conv_kernel_1x2_add     ch0_conv_kernel_1x2_add_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .data00                 (ch0_out_00             ),
        .data01                 (ch0_out_01             ),
        .data02                 (ch0_out_02             ),
        .data10                 (ch0_out_10             ),
        .data11                 (ch0_out_11             ),
        .data12                 (ch0_out_12             ),
        .data20                 (ch0_out_20             ),
        .data21                 (ch0_out_21             ),
        .data22                 (ch0_out_22             ),
        //
        .add_result             (ch0_out                )
);

conv_kernel_1x2_add     ch1_conv_kernel_1x2_add_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .data00                 (ch1_out_00             ),
        .data01                 (ch1_out_01             ),
        .data02                 (ch1_out_02             ),
        .data10                 (ch1_out_10             ),
        .data11                 (ch1_out_11             ),
        .data12                 (ch1_out_12             ),
        .data20                 (ch1_out_20             ),
        .data21                 (ch1_out_21             ),
        .data22                 (ch1_out_22             ),
        //
        .add_result             (ch1_out                )
);


endmodule
