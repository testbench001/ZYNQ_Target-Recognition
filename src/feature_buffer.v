module  feature_buffer(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // Stream Data
        input           [63:0]  stream_rx_data          ,       
        input                   stream_feature_vld      ,       
        // Read
        input                   feature_buffer_rd_en    ,       
        output  wire    [63:0]  feature_buffer_rd_data  ,
        //
        input           [ 7:0]  zero_point_in
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
wire    [ 7:0]                  ch0_data                        ;
wire    [ 7:0]                  ch1_data                        ;
wire    [ 7:0]                  ch2_data                        ;
wire    [ 7:0]                  ch3_data                        ;
wire    [ 7:0]                  ch4_data                        ;
wire    [ 7:0]                  ch5_data                        ;
wire    [ 7:0]                  ch6_data                        ;
wire    [ 7:0]                  ch7_data                        ;

wire    [63:0]                  fifo_wr_data                    ;

//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  ch0_data        =       stream_rx_data[7:0] - zero_point_in;
assign  ch1_data        =       stream_rx_data[15:8] - zero_point_in;
assign  ch2_data        =       stream_rx_data[23:16] - zero_point_in;
assign  ch3_data        =       stream_rx_data[31:24] - zero_point_in;
assign  ch4_data        =       stream_rx_data[39:32] - zero_point_in;
assign  ch5_data        =       stream_rx_data[47:40] - zero_point_in;
assign  ch6_data        =       stream_rx_data[55:48] - zero_point_in;
assign  ch7_data        =       stream_rx_data[63:56] - zero_point_in;

assign  fifo_wr_data    =       {ch7_data, ch6_data, ch5_data, ch4_data,
                                 ch3_data, ch2_data, ch1_data, ch0_data};

feature_fifo_ip feature_fifo_ip_inst (
        .clk                    (sclk                   ),      // input wire clk
        .srst                   (~s_rst_n               ),      // input wire srst
        .din                    (fifo_wr_data           ),      // input wire [63 : 0] din
        .wr_en                  (stream_feature_vld     ),      // input wire wr_en
        .rd_en                  (feature_buffer_rd_en   ),      // input wire rd_en
        .dout                   (feature_buffer_rd_data ),      // output wire [63 : 0] dout
        .full                   (                       ),      // output wire full
        .empty                  (                       ),      // output wire empty
        .data_count             (                       )       // output wire [12 : 0] data_count
);

endmodule
