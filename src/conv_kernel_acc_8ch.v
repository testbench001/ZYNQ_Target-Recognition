module  conv_kernel_acc_8ch(
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
        input           [ 1:0]  batch_type              ,       
        // 
        output  wire signed [31:0]      ch0_data_out    ,       
        output  wire signed [31:0]      ch1_data_out    ,       
        output  wire signed [31:0]      ch2_data_out    ,       
        output  wire signed [31:0]      ch3_data_out    ,       
        output  wire signed [31:0]      ch4_data_out    ,       
        output  wire signed [31:0]      ch5_data_out    ,       
        output  wire signed [31:0]      ch6_data_out    ,       
        output  wire signed [31:0]      ch7_data_out    ,       
        output  reg                     data_out_vld
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/



//=============================================================================
//**************    Main Code   **************
//=============================================================================
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0) begin
                data_out_vld    <=      1'b0;
        end
        else if(batch_type == 'd2) begin
                data_out_vld    <=      data_in_vld;
        end
end


conv_kernel_acc         ch0_conv_kernel_acc_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch0_data_in            ),
        .data_in_vld            (data_in_vld            ),
        .batch_type             (batch_type             ),
        // 
        .data_out               (ch0_data_out           )
);

conv_kernel_acc         ch1_conv_kernel_acc_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch1_data_in            ),
        .data_in_vld            (data_in_vld            ),
        .batch_type             (batch_type             ),
        // 
        .data_out               (ch1_data_out           )
);

conv_kernel_acc         ch2_conv_kernel_acc_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch2_data_in            ),
        .data_in_vld            (data_in_vld            ),
        .batch_type             (batch_type             ),
        // 
        .data_out               (ch2_data_out           )
);

conv_kernel_acc         ch3_conv_kernel_acc_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch3_data_in            ),
        .data_in_vld            (data_in_vld            ),
        .batch_type             (batch_type             ),
        // 
        .data_out               (ch3_data_out           )
);


conv_kernel_acc         ch4_conv_kernel_acc_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch4_data_in            ),
        .data_in_vld            (data_in_vld            ),
        .batch_type             (batch_type             ),
        // 
        .data_out               (ch4_data_out           )
);

conv_kernel_acc         ch5_conv_kernel_acc_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch5_data_in            ),
        .data_in_vld            (data_in_vld            ),
        .batch_type             (batch_type             ),
        // 
        .data_out               (ch5_data_out           )
);

conv_kernel_acc         ch6_conv_kernel_acc_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch6_data_in            ),
        .data_in_vld            (data_in_vld            ),
        .batch_type             (batch_type             ),
        // 
        .data_out               (ch6_data_out           )
);

conv_kernel_acc         ch7_conv_kernel_acc_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .data_in                (ch7_data_in            ),
        .data_in_vld            (data_in_vld            ),
        .batch_type             (batch_type             ),
        // 
        .data_out               (ch7_data_out           )
);



endmodule
