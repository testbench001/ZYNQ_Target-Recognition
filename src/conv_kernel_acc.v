module  conv_kernel_acc(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        input   signed  [23:0]  data_in                 ,       
        input                   data_in_vld             ,       
        input           [ 1:0]  batch_type              ,       
        // 
        output  reg  signed [31:0]      data_out               
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

reg     signed  [31:0]          fifo_wr_data                    ;
wire    signed  [31:0]          fifo_rd_data                    ;
reg                             fifo_wr_en                      ;       
wire                            fifo_rd_en                      ;       


//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  fifo_rd_en      =       (batch_type > 'd0) ? data_in_vld : 1'b0;


always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0) begin
                fifo_wr_en      <=      1'b0;
                fifo_wr_data    <=      'd0;
        end
        else case(batch_type)
                0: begin
                        fifo_wr_en      <=      data_in_vld;
                        fifo_wr_data    <=      data_in;
                end
                1: begin
                        fifo_wr_en      <=      data_in_vld;
                        fifo_wr_data    <=      data_in + fifo_rd_data;
                end
                default: begin
                        fifo_wr_en      <=      1'b0;
                        fifo_wr_data    <=      'd0;
                end
        endcase
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0) begin
                data_out        <=      'd0;
        end
        else if(batch_type == 'd2) begin
                data_out        <=      data_in + fifo_rd_data;
        end
end

acc_fifo_ip acc_fifo_ip_inst (
        .clk                    (sclk                   ),      // input wire clk
        .srst                   (~s_rst_n               ),      // input wire srst
        .din                    (fifo_wr_data           ),      // input wire [31 : 0] din
        .wr_en                  (fifo_wr_en             ),      // input wire wr_en
        .rd_en                  (fifo_rd_en             ),      // input wire rd_en
        .dout                   (fifo_rd_data           ),      // output wire [31 : 0] dout
        .full                   (                       ),      // output wire full
        .empty                  (                       ),      // output wire empty
        .data_count             (                       )       // output wire [12 : 0] data_count
);

endmodule
