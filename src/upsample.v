`include "debug_ctrl.h"

module  upsample(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        input           [ 5:0]  state                   ,       
        output  wire            buffer_rd_en            ,       
        input           [63:0]  buffer_rd_data          ,       
        // 
        output  wire    [63:0]  axis_tdata              ,       
        output  wire            axis_tvalid             ,       
        input                   axis_tready             ,       
        output  reg             axis_tlast              ,
        //
        output  wire            upsample_finish         
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
localparam      COL_END         =       'd26                    ;
`ifndef SIM
localparam      ROW_END         =       'd416                   ;
`else
localparam      ROW_END         =       'd26                    ;
`endif 


reg     [ 4:0]                  col_cnt                         ;       
reg     [ 8:0]                  row_cnt                         ;       

reg     [63:0]                  buffer_rd_data_r1               ;       

wire                            hand_shake                      ;       
wire                            fifo_wr_en                      ;       
wire                            fifo_rd_en                      ;       
wire    [63:0]                  fifo_rd_data                    ;       

//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  buffer_rd_en    =       (col_cnt[0] == 1'b0 && row_cnt[0] == 1'b0) ? hand_shake : 1'b0;
assign  axis_tdata      =       (row_cnt[0] == 1'b0) ? ((buffer_rd_en == 1'b1) ? buffer_rd_data : buffer_rd_data_r1) : fifo_rd_data;
assign  axis_tvalid     =       state[4];
assign  hand_shake      =       axis_tvalid & axis_tready;
assign  fifo_wr_en      =       (row_cnt[0] == 1'b0) ? hand_shake : 1'b0;
assign  fifo_rd_en      =       (row_cnt[0] == 1'b1) ? hand_shake : 1'b0;

assign  upsample_finish =       axis_tlast;


always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                col_cnt <=      'd0;
        else if(col_cnt == COL_END-1 && hand_shake == 1'b1)
                col_cnt <=      'd0;
        else if(hand_shake == 1'b1)
                col_cnt <=      col_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                row_cnt <=      'd0;
        else if(state[4] == 1'b0)
                row_cnt <=      'd0;
        else if(col_cnt == COL_END-1 && hand_shake == 1'b1)
                row_cnt <=      row_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                buffer_rd_data_r1       <=      64'h0;
        else if(buffer_rd_en == 1'b1)
                buffer_rd_data_r1       <=      buffer_rd_data;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                axis_tlast      <=      1'b0;
        else if(col_cnt == COL_END-2 && row_cnt == (ROW_END-1) && hand_shake == 1'b1)
                axis_tlast      <=      1'b1;
        else
                axis_tlast      <=      1'b0;
end


up_fifo_ip up_fifo_ip_inst (
        .clk                    (sclk                   ),      // input wire clk
        .srst                   (~s_rst_n               ),      // input wire srst
        .din                    (axis_tdata             ),      // input wire [63 : 0] din
        .wr_en                  (fifo_wr_en             ),      // input wire wr_en
        .rd_en                  (fifo_rd_en             ),      // input wire rd_en
        .dout                   (fifo_rd_data           ),      // output wire [63 : 0] dout
        .full                   (                       ),      // output wire full
        .empty                  (                       ),      // output wire empty
        .data_count             (                       )// output wire [5 : 0] data_count
);


endmodule
