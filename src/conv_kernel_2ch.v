module  conv_kernel_2ch(
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
        //
        input   signed  [31:0]  ch0_bias                ,
        input   signed  [31:0]  ch1_bias                ,
        input                   bias_enable             ,       
        // 
        output  wire signed   [23:0]  ch0_conv_out      ,
        output  wire signed   [23:0]  ch1_conv_out            
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
wire signed    [19:0]           ch0_out_0                       ;
wire signed    [19:0]           ch0_out_1                       ;
wire signed    [19:0]           ch0_out_2                       ;
wire signed    [19:0]           ch0_out_3                       ;
wire signed    [19:0]           ch0_out_4                       ;
wire signed    [19:0]           ch0_out_5                       ;
wire signed    [19:0]           ch0_out_6                       ;
wire signed    [19:0]           ch0_out_7                       ;

wire signed    [19:0]           ch1_out_0                       ;
wire signed    [19:0]           ch1_out_1                       ;
wire signed    [19:0]           ch1_out_2                       ;
wire signed    [19:0]           ch1_out_3                       ;
wire signed    [19:0]           ch1_out_4                       ;
wire signed    [19:0]           ch1_out_5                       ;
wire signed    [19:0]           ch1_out_6                       ;
wire signed    [19:0]           ch1_out_7                       ;


//=============================================================================
//**************    Main Code   **************
//=============================================================================
conv_kernel_1x2         U0_conv_kernel_1x2_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .data_in                (ch0_data_in            ),
        .ch0_weight             (ch0_weight_0           ),
        .ch1_weight             (ch1_weight_0           ),
        //
        .ch0_out                (ch0_out_0              ),
        .ch1_out                (ch1_out_0              )
);

conv_kernel_1x2         U1_conv_kernel_1x2_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .data_in                (ch1_data_in            ),
        .ch0_weight             (ch0_weight_1           ),
        .ch1_weight             (ch1_weight_1           ),
        //
        .ch0_out                (ch0_out_1              ),
        .ch1_out                (ch1_out_1              )
);

conv_kernel_1x2         U2_conv_kernel_1x2_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .data_in                (ch2_data_in            ),
        .ch0_weight             (ch0_weight_2           ),
        .ch1_weight             (ch1_weight_2           ),
        //
        .ch0_out                (ch0_out_2              ),
        .ch1_out                (ch1_out_2              )
);

conv_kernel_1x2         U3_conv_kernel_1x2_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .data_in                (ch3_data_in            ),
        .ch0_weight             (ch0_weight_3           ),
        .ch1_weight             (ch1_weight_3           ),
        //
        .ch0_out                (ch0_out_3              ),
        .ch1_out                (ch1_out_3              )
);

conv_kernel_1x2         U4_conv_kernel_1x2_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .data_in                (ch4_data_in            ),
        .ch0_weight             (ch0_weight_4           ),
        .ch1_weight             (ch1_weight_4           ),
        //
        .ch0_out                (ch0_out_4              ),
        .ch1_out                (ch1_out_4              )
);

conv_kernel_1x2         U5_conv_kernel_1x2_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .data_in                (ch5_data_in            ),
        .ch0_weight             (ch0_weight_5           ),
        .ch1_weight             (ch1_weight_5           ),
        //
        .ch0_out                (ch0_out_5              ),
        .ch1_out                (ch1_out_5              )
);

conv_kernel_1x2         U6_conv_kernel_1x2_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .data_in                (ch6_data_in            ),
        .ch0_weight             (ch0_weight_6           ),
        .ch1_weight             (ch1_weight_6           ),
        //
        .ch0_out                (ch0_out_6              ),
        .ch1_out                (ch1_out_6              )
);

conv_kernel_1x2         U7_conv_kernel_1x2_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .data_in                (ch7_data_in            ),
        .ch0_weight             (ch0_weight_7           ),
        .ch1_weight             (ch1_weight_7           ),
        //
        .ch0_out                (ch0_out_7              ),
        .ch1_out                (ch1_out_7              )
);

conv_kernel_2ch_add     ch0_conv_kernel_2ch_add(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .data0                  (ch0_out_0              ),
        .data1                  (ch0_out_1              ),
        .data2                  (ch0_out_2              ),
        .data3                  (ch0_out_3              ),
        .data4                  (ch0_out_4              ),
        .data5                  (ch0_out_5              ),
        .data6                  (ch0_out_6              ),
        .data7                  (ch0_out_7              ),
        .bias                   (ch0_bias               ),
        .bias_enable            (bias_enable            ),
        //
        .data_out               (ch0_conv_out           )
);

conv_kernel_2ch_add     ch1_conv_kernel_2ch_add(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // 
        .data0                  (ch1_out_0              ),
        .data1                  (ch1_out_1              ),
        .data2                  (ch1_out_2              ),
        .data3                  (ch1_out_3              ),
        .data4                  (ch1_out_4              ),
        .data5                  (ch1_out_5              ),
        .data6                  (ch1_out_6              ),
        .data7                  (ch1_out_7              ),
        .bias                   (ch1_bias               ),
        .bias_enable            (bias_enable            ),
        //
        .data_out               (ch1_conv_out           )
);

endmodule
