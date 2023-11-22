module  max_pool(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // 
        input                   pool_stride             ,
        input           [ 3:0]  row_cnt                 ,
        input                   data_in_vld             ,
        input           [ 7:0]  data_in                 ,       
        output  reg     [ 7:0]  data_out                ,
        input                   fifo_wr_en              ,       
        input                   fifo_rd_en                     
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
reg     [ 7:0]                  data_in_r1                      ;       
wire    [ 7:0]                  max_data                        ;       
wire    [ 7:0]                  fifo_rd_data                    ;
reg     [ 7:0]                  fifo_wr_data                    ;
//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  max_data        =       fifo_wr_data;

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                data_in_r1      <=      'd0;
        else if(data_in_vld == 1'b1)
                data_in_r1      <=      data_in;
        else 
                data_in_r1      <=      'd0;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                fifo_wr_data    <=      'd0;
        else if(data_in_r1 >= data_in)
                fifo_wr_data    <=      data_in_r1;
        else
                fifo_wr_data    <=      data_in;
end


always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                data_out        <=      'd0;
        else if(pool_stride == 1'b1 && row_cnt == 'd0)
                data_out        <=      max_data;
        else if(max_data >= fifo_rd_data)
                data_out        <=      max_data;
        else
                data_out        <=      fifo_rd_data;
end

pool_fifo_ip    pool_fifo_ip (
        .clk                    (sclk                   ),      // input wire clk
        .srst                   (~s_rst_n               ),      // input wire srst
        .din                    (fifo_wr_data           ),      // input wire [7 : 0] din
        .wr_en                  (fifo_wr_en             ),      // input wire wr_en
        .rd_en                  (fifo_rd_en             ),      // input wire rd_en
        .dout                   (fifo_rd_data           ),      // output wire [7 : 0] dout
        .full                   (                       ),      // output wire full
        .empty                  (                       ),      // output wire empty
        .data_count             (                       )       // output wire [8 : 0] data_count
);


endmodule
