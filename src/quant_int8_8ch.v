module  quant_int8_8ch(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        input   signed  [23:0]  ch0_data_in             ,       
        input   signed  [23:0]  ch1_data_in             ,       
        input   signed  [23:0]  ch2_data_in             ,       
        input   signed  [23:0]  ch3_data_in             ,       
        input   signed  [23:0]  ch4_data_in             ,       
        input   signed  [23:0]  ch5_data_in             ,       
        input   signed  [23:0]  ch6_data_in             ,       
        input   signed  [23:0]  ch7_data_in             ,       
        input                   data_in_vld             ,       
        //
        input           [14:0]  mult                    ,       
        input           [ 7:0]  shift                   ,       
        input           [ 7:0]  zero_point              ,       
        //
        output  wire    [ 7:0]  ch0_data_out            ,       
        output  wire    [ 7:0]  ch1_data_out            ,       
        output  wire    [ 7:0]  ch2_data_out            ,       
        output  wire    [ 7:0]  ch3_data_out            ,       
        output  wire    [ 7:0]  ch4_data_out            ,       
        output  wire    [ 7:0]  ch5_data_out            ,       
        output  wire    [ 7:0]  ch6_data_out            ,       
        output  wire    [ 7:0]  ch7_data_out            ,       
        output  wire            data_out_vld                   
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/



//=============================================================================
//**************    Main Code   **************
//=============================================================================
shift_reg #(
        .DLY_CNT                (5                      )
)shift_reg_inst(
        .sclk                   (sclk                   ),
        .data_in                (data_in_vld            ),
        .data_out               (data_out_vld           )
);


quant_int8      ch0_quant_int8_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch0_data_in            ),
        //
        .mult                   (mult                   ),
        .shift                  (shift                  ),
        .zero_point             (zero_point             ),
        //
        .data_out               (ch0_data_out           )
);

quant_int8      ch1_quant_int8_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch1_data_in            ),
        //
        .mult                   (mult                   ),
        .shift                  (shift                  ),
        .zero_point             (zero_point             ),
        //
        .data_out               (ch1_data_out           )
);

quant_int8      ch2_quant_int8_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch2_data_in            ),
        //
        .mult                   (mult                   ),
        .shift                  (shift                  ),
        .zero_point             (zero_point             ),
        //
        .data_out               (ch2_data_out           )
);

quant_int8      ch3_quant_int8_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch3_data_in            ),
        //
        .mult                   (mult                   ),
        .shift                  (shift                  ),
        .zero_point             (zero_point             ),
        //
        .data_out               (ch3_data_out           )
);

quant_int8      ch4_quant_int8_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch4_data_in            ),
        //
        .mult                   (mult                   ),
        .shift                  (shift                  ),
        .zero_point             (zero_point             ),
        //
        .data_out               (ch4_data_out           )
);

quant_int8      ch5_quant_int8_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch5_data_in            ),
        //
        .mult                   (mult                   ),
        .shift                  (shift                  ),
        .zero_point             (zero_point             ),
        //
        .data_out               (ch5_data_out           )
);

quant_int8      ch6_quant_int8_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch6_data_in            ),
        //
        .mult                   (mult                   ),
        .shift                  (shift                  ),
        .zero_point             (zero_point             ),
        //
        .data_out               (ch6_data_out           )
);

quant_int8      ch7_quant_int8_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch7_data_in            ),
        //
        .mult                   (mult                   ),
        .shift                  (shift                  ),
        .zero_point             (zero_point             ),
        //
        .data_out               (ch7_data_out           )
);

endmodule
