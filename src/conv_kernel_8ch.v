module  conv_kernel_8ch(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // 
        input           [71:0]  ch0_data_in             ,       
        input           [71:0]  ch1_data_in             ,       
        input           [71:0]  ch2_data_in             ,       
        input           [71:0]  ch3_data_in             ,       
        input           [71:0]  ch4_data_in             ,       
        input           [71:0]  ch5_data_in             ,       
        input           [71:0]  ch6_data_in             ,       
        input           [71:0]  ch7_data_in             ,       
        input                   ch_data_in_vld          ,       

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
wire signed   [23:0]            ch0_out                    ;       
wire signed   [23:0]            ch1_out                    ;       
wire signed   [23:0]            ch2_out                    ;       
wire signed   [23:0]            ch3_out                    ;       
wire signed   [23:0]            ch4_out                    ;       
wire signed   [23:0]            ch5_out                    ;       
wire signed   [23:0]            ch6_out                    ;       
wire signed   [23:0]            ch7_out                    ;       

wire                            bias_enable                     ;       

// 后面通过仿真再来确定
wire                            ch_out_vld                      ;       


//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  bias_enable     =       (batch_type == 2'd2) ? 1'b1 : 1'b0;

shift_reg #(
        .DLY_CNT                (8                      )
) shift_reg_inst(
        .sclk                   (sclk                   ),
        .data_in                (ch_data_in_vld         ),
        .data_out               (ch_out_vld             )
);


conv_kernel_acc_8ch     conv_kernel_acc_8ch_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .ch0_data_in            (ch0_out                ),
        .ch1_data_in            (ch1_out                ),
        .ch2_data_in            (ch2_out                ),
        .ch3_data_in            (ch3_out                ),
        .ch4_data_in            (ch4_out                ),
        .ch5_data_in            (ch5_out                ),
        .ch6_data_in            (ch6_out                ),
        .ch7_data_in            (ch7_out                ),
        .data_in_vld            (ch_out_vld             ),
        .batch_type             (batch_type             ),
        // 
        .ch0_data_out           (ch0_conv_out           ),
        .ch1_data_out           (ch1_conv_out           ),
        .ch2_data_out           (ch2_conv_out           ),
        .ch3_data_out           (ch3_conv_out           ),
        .ch4_data_out           (ch4_conv_out           ),
        .ch5_data_out           (ch5_conv_out           ),
        .ch6_data_out           (ch6_conv_out           ),
        .ch7_data_out           (ch7_conv_out           ),
        .data_out_vld           (ch_conv_out_vld        )
);


conv_kernel_2ch         U0_conv_kernel_2ch_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .ch0_data_in            (ch0_data_in            ),
        .ch1_data_in            (ch1_data_in            ),
        .ch2_data_in            (ch2_data_in            ),
        .ch3_data_in            (ch3_data_in            ),
        .ch4_data_in            (ch4_data_in            ),
        .ch5_data_in            (ch5_data_in            ),
        .ch6_data_in            (ch6_data_in            ),
        .ch7_data_in            (ch7_data_in            ),

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
        //
        .ch0_bias               (ch0_bias               ),
        .ch1_bias               (ch1_bias               ),
        .bias_enable            (bias_enable            ),
        // 
        .ch0_conv_out           (ch0_out                ),
        .ch1_conv_out           (ch1_out                )
);

conv_kernel_2ch         U1_conv_kernel_2ch_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .ch0_data_in            (ch0_data_in            ),
        .ch1_data_in            (ch1_data_in            ),
        .ch2_data_in            (ch2_data_in            ),
        .ch3_data_in            (ch3_data_in            ),
        .ch4_data_in            (ch4_data_in            ),
        .ch5_data_in            (ch5_data_in            ),
        .ch6_data_in            (ch6_data_in            ),
        .ch7_data_in            (ch7_data_in            ),

        .ch0_weight_0           (ch2_weight_0           ),
        .ch0_weight_1           (ch2_weight_1           ),
        .ch0_weight_2           (ch2_weight_2           ),
        .ch0_weight_3           (ch2_weight_3           ),
        .ch0_weight_4           (ch2_weight_4           ),
        .ch0_weight_5           (ch2_weight_5           ),
        .ch0_weight_6           (ch2_weight_6           ),
        .ch0_weight_7           (ch2_weight_7           ),

        .ch1_weight_0           (ch3_weight_0           ),
        .ch1_weight_1           (ch3_weight_1           ),
        .ch1_weight_2           (ch3_weight_2           ),
        .ch1_weight_3           (ch3_weight_3           ),
        .ch1_weight_4           (ch3_weight_4           ),
        .ch1_weight_5           (ch3_weight_5           ),
        .ch1_weight_6           (ch3_weight_6           ),
        .ch1_weight_7           (ch3_weight_7           ),
        //
        .ch0_bias               (ch2_bias               ),
        .ch1_bias               (ch3_bias               ),
        .bias_enable            (bias_enable            ),
        // 
        .ch0_conv_out           (ch2_out                ),
        .ch1_conv_out           (ch3_out                )
);

conv_kernel_2ch         U2_conv_kernel_2ch_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .ch0_data_in            (ch0_data_in            ),
        .ch1_data_in            (ch1_data_in            ),
        .ch2_data_in            (ch2_data_in            ),
        .ch3_data_in            (ch3_data_in            ),
        .ch4_data_in            (ch4_data_in            ),
        .ch5_data_in            (ch5_data_in            ),
        .ch6_data_in            (ch6_data_in            ),
        .ch7_data_in            (ch7_data_in            ),

        .ch0_weight_0           (ch4_weight_0           ),
        .ch0_weight_1           (ch4_weight_1           ),
        .ch0_weight_2           (ch4_weight_2           ),
        .ch0_weight_3           (ch4_weight_3           ),
        .ch0_weight_4           (ch4_weight_4           ),
        .ch0_weight_5           (ch4_weight_5           ),
        .ch0_weight_6           (ch4_weight_6           ),
        .ch0_weight_7           (ch4_weight_7           ),

        .ch1_weight_0           (ch5_weight_0           ),
        .ch1_weight_1           (ch5_weight_1           ),
        .ch1_weight_2           (ch5_weight_2           ),
        .ch1_weight_3           (ch5_weight_3           ),
        .ch1_weight_4           (ch5_weight_4           ),
        .ch1_weight_5           (ch5_weight_5           ),
        .ch1_weight_6           (ch5_weight_6           ),
        .ch1_weight_7           (ch5_weight_7           ),
        //
        .ch0_bias               (ch4_bias               ),
        .ch1_bias               (ch5_bias               ),
        .bias_enable            (bias_enable            ),
        // 
        .ch0_conv_out           (ch4_out                ),
        .ch1_conv_out           (ch5_out                )
);

conv_kernel_2ch         U3_conv_kernel_2ch_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .ch0_data_in            (ch0_data_in            ),
        .ch1_data_in            (ch1_data_in            ),
        .ch2_data_in            (ch2_data_in            ),
        .ch3_data_in            (ch3_data_in            ),
        .ch4_data_in            (ch4_data_in            ),
        .ch5_data_in            (ch5_data_in            ),
        .ch6_data_in            (ch6_data_in            ),
        .ch7_data_in            (ch7_data_in            ),

        .ch0_weight_0           (ch6_weight_0           ),
        .ch0_weight_1           (ch6_weight_1           ),
        .ch0_weight_2           (ch6_weight_2           ),
        .ch0_weight_3           (ch6_weight_3           ),
        .ch0_weight_4           (ch6_weight_4           ),
        .ch0_weight_5           (ch6_weight_5           ),
        .ch0_weight_6           (ch6_weight_6           ),
        .ch0_weight_7           (ch6_weight_7           ),

        .ch1_weight_0           (ch7_weight_0           ),
        .ch1_weight_1           (ch7_weight_1           ),
        .ch1_weight_2           (ch7_weight_2           ),
        .ch1_weight_3           (ch7_weight_3           ),
        .ch1_weight_4           (ch7_weight_4           ),
        .ch1_weight_5           (ch7_weight_5           ),
        .ch1_weight_6           (ch7_weight_6           ),
        .ch1_weight_7           (ch7_weight_7           ),
        //
        .ch0_bias               (ch6_bias               ),
        .ch1_bias               (ch7_bias               ),
        .bias_enable            (bias_enable            ),
        // 
        .ch0_conv_out           (ch6_out                ),
        .ch1_conv_out           (ch7_out                )
);


endmodule
