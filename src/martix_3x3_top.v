module  martix_3x3_top(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // 
        input           [63:0]  line2_data              ,
        input           [63:0]  line1_data              ,
        input           [63:0]  line0_data              ,
        input                   line_data_vld           ,       
        input           [ 8:0]  padding_col_cnt         ,
        // 
        output  wire    [71:0]  ch0_martix_3x3_data     ,       
        output  wire    [71:0]  ch1_martix_3x3_data     ,       
        output  wire    [71:0]  ch2_martix_3x3_data     ,       
        output  wire    [71:0]  ch3_martix_3x3_data     ,       
        output  wire    [71:0]  ch4_martix_3x3_data     ,       
        output  wire    [71:0]  ch5_martix_3x3_data     ,       
        output  wire    [71:0]  ch6_martix_3x3_data     ,       
        output  wire    [71:0]  ch7_martix_3x3_data     ,       
        output  wire            martix_3x3_data_vld     
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/




//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  martix_3x3_data_vld     =       (padding_col_cnt >= 'd2) ? line_data_vld : 1'b0;

martix_3x3      ch0_martix_3x3_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .line2_data             (line2_data[7:0]        ),
        .line1_data             (line1_data[7:0]        ),
        .line0_data             (line0_data[7:0]        ),
        // 
        .martix_3x3_data        (ch0_martix_3x3_data    )
);

martix_3x3      ch1_martix_3x3_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .line2_data             (line2_data[15:8]       ),
        .line1_data             (line1_data[15:8]       ),
        .line0_data             (line0_data[15:8]       ),
        // 
        .martix_3x3_data        (ch1_martix_3x3_data    )
);


martix_3x3      ch2_martix_3x3_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .line2_data             (line2_data[23:16]      ),
        .line1_data             (line1_data[23:16]      ),
        .line0_data             (line0_data[23:16]      ),
        // 
        .martix_3x3_data        (ch2_martix_3x3_data    )
);

martix_3x3      ch3_martix_3x3_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .line2_data             (line2_data[31:24]      ),
        .line1_data             (line1_data[31:24]      ),
        .line0_data             (line0_data[31:24]      ),
        // 
        .martix_3x3_data        (ch3_martix_3x3_data    )
);

martix_3x3      ch4_martix_3x3_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .line2_data             (line2_data[39:32]      ),
        .line1_data             (line1_data[39:32]      ),
        .line0_data             (line0_data[39:32]      ),
        // 
        .martix_3x3_data        (ch4_martix_3x3_data    )
);

martix_3x3      ch5_martix_3x3_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .line2_data             (line2_data[47:40]      ),
        .line1_data             (line1_data[47:40]      ),
        .line0_data             (line0_data[47:40]      ),
        // 
        .martix_3x3_data        (ch5_martix_3x3_data    )
);


martix_3x3      ch6_martix_3x3_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .line2_data             (line2_data[55:48]      ),
        .line1_data             (line1_data[55:48]      ),
        .line0_data             (line0_data[55:48]      ),
        // 
        .martix_3x3_data        (ch6_martix_3x3_data    )
);

martix_3x3      ch7_martix_3x3_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .line2_data             (line2_data[63:56]      ),
        .line1_data             (line1_data[63:56]      ),
        .line0_data             (line0_data[63:56]      ),
        // 
        .martix_3x3_data        (ch7_martix_3x3_data    )
);

endmodule
