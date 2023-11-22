module  max_pool_8ch(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        input                   padding_start           ,      
        input                   pool_stride             ,       // 0:stride=2, 1:stride=1
        input           [ 7:0]  ch0_data_in             ,       
        input           [ 7:0]  ch1_data_in             ,       
        input           [ 7:0]  ch2_data_in             ,       
        input           [ 7:0]  ch3_data_in             ,       
        input           [ 7:0]  ch4_data_in             ,       
        input           [ 7:0]  ch5_data_in             ,       
        input           [ 7:0]  ch6_data_in             ,       
        input           [ 7:0]  ch7_data_in             ,       
        input                   data_in_vld             ,       
        //
        output  wire    [ 7:0]  ch0_data_out            ,       
        output  wire    [ 7:0]  ch1_data_out            ,       
        output  wire    [ 7:0]  ch2_data_out            ,       
        output  wire    [ 7:0]  ch3_data_out            ,       
        output  wire    [ 7:0]  ch4_data_out            ,       
        output  wire    [ 7:0]  ch5_data_out            ,       
        output  wire    [ 7:0]  ch6_data_out            ,       
        output  wire    [ 7:0]  ch7_data_out            ,       
        output  reg             data_out_vld                
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
reg                             data_in_vld_r1                  ;     
reg                             fifo_wr_en                      ;       
reg                             fifo_rd_en                      ;   
reg                             col_even_flag                   ;       
reg                             row_even_flag                   ;   

reg     [ 3:0]                  row_cnt                         ;

wire                            clear                           ;

//=============================================================================
//**************    Main Code   **************
//=============================================================================
always  @(posedge sclk) begin
        data_in_vld_r1  <=      data_in_vld;
        if(pool_stride == 1'b1)
                data_out_vld    <=      data_in_vld_r1;
        else 
                data_out_vld    <=      fifo_rd_en;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                col_even_flag   <=      1'b0;
        else if(data_in_vld == 1'b1 && pool_stride == 1'b0)
                col_even_flag   <=      ~col_even_flag;
        else
                col_even_flag   <=      1'b0;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                fifo_wr_en      <=      1'b0;
        else if(pool_stride == 1'b1 && row_cnt <= 'd11)
                fifo_wr_en      <=      data_in_vld;
        else if(row_even_flag == 1'b1 && col_even_flag == 1'b1)
                fifo_wr_en      <=      1'b1;
        else
                fifo_wr_en      <=      1'b0;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                fifo_rd_en      <=      1'b0;
        else if(pool_stride == 1'b1 && row_cnt >= 'd1)
                fifo_rd_en      <=      data_in_vld;
        else if(row_even_flag == 1'b0 && col_even_flag == 1'b1)
                fifo_rd_en      <=      1'b1;
        else
                fifo_rd_en      <=      1'b0;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                row_even_flag   <=      1'b0;
        else if(data_in_vld == 1'b1 && data_in_vld_r1 == 1'b0 && pool_stride == 1'b0)
                row_even_flag   <=      ~row_even_flag;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                row_cnt <=      'd0;
        else if(padding_start == 1'b1)
                row_cnt <=      'd0;
        else if(data_in_vld == 1'b0 && data_in_vld_r1 == 1'b1 && pool_stride == 1'b1)
                row_cnt <=      row_cnt + 1'b1;
end

assign  clear   =       (pool_stride == 1'b1) ? ~padding_start : 1'b1;

max_pool        ch0_max_pool_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n & clear        ),
        // 
        .pool_stride            (pool_stride            ),
        .row_cnt                (row_cnt                ),
        .data_in_vld            (data_in_vld            ),
        .data_in                (ch0_data_in            ),
        .data_out               (ch0_data_out           ),
        .fifo_wr_en             (fifo_wr_en             ),
        .fifo_rd_en             (fifo_rd_en             )
);

max_pool        ch1_max_pool_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n & clear        ),
        // 
        .pool_stride            (pool_stride            ),
        .row_cnt                (row_cnt                ),
        .data_in_vld            (data_in_vld            ),
        .data_in                (ch1_data_in            ),
        .data_out               (ch1_data_out           ),
        .fifo_wr_en             (fifo_wr_en             ),
        .fifo_rd_en             (fifo_rd_en             )
);

max_pool        ch2_max_pool_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n & clear        ),
        // 
        .pool_stride            (pool_stride            ),
        .row_cnt                (row_cnt                ),
        .data_in_vld            (data_in_vld            ),
        .data_in                (ch2_data_in            ),
        .data_out               (ch2_data_out           ),
        .fifo_wr_en             (fifo_wr_en             ),
        .fifo_rd_en             (fifo_rd_en             )
);

max_pool        ch3_max_pool_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n & clear        ),
        // 
        .pool_stride            (pool_stride            ),
        .row_cnt                (row_cnt                ),
        .data_in_vld            (data_in_vld            ),
        .data_in                (ch3_data_in            ),
        .data_out               (ch3_data_out           ),
        .fifo_wr_en             (fifo_wr_en             ),
        .fifo_rd_en             (fifo_rd_en             )
);

max_pool        ch4_max_pool_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n & clear        ),
        // 
        .pool_stride            (pool_stride            ),
        .row_cnt                (row_cnt                ),
        .data_in_vld            (data_in_vld            ),
        .data_in                (ch4_data_in            ),
        .data_out               (ch4_data_out           ),
        .fifo_wr_en             (fifo_wr_en             ),
        .fifo_rd_en             (fifo_rd_en             )
);

max_pool        ch5_max_pool_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n & clear        ),
        // 
        .pool_stride            (pool_stride            ),
        .row_cnt                (row_cnt                ),
        .data_in_vld            (data_in_vld            ),
        .data_in                (ch5_data_in            ),
        .data_out               (ch5_data_out           ),
        .fifo_wr_en             (fifo_wr_en             ),
        .fifo_rd_en             (fifo_rd_en             )
);

max_pool        ch6_max_pool_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n & clear        ),
        // 
        .pool_stride            (pool_stride            ),
        .row_cnt                (row_cnt                ),
        .data_in_vld            (data_in_vld            ),
        .data_in                (ch6_data_in            ),
        .data_out               (ch6_data_out           ),
        .fifo_wr_en             (fifo_wr_en             ),
        .fifo_rd_en             (fifo_rd_en             )
);

max_pool        ch7_max_pool_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n & clear        ),
        // 
        .pool_stride            (pool_stride            ),
        .row_cnt                (row_cnt                ),
        .data_in_vld            (data_in_vld            ),
        .data_in                (ch7_data_in            ),
        .data_out               (ch7_data_out           ),
        .fifo_wr_en             (fifo_wr_en             ),
        .fifo_rd_en             (fifo_rd_en             )
);

endmodule
