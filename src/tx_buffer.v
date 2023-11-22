module  tx_buffer(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // in 
        input           [63:0]  buffer_wr_data          ,       
        input                   buffer_wr_en            ,       
        // Read
        input                   buffer_rd_en            ,       
        output  wire    [63:0]  buffer_rd_data          ,
        // 
        input                   read_start              ,       
        output  reg     [12:0]  buffer_data_count              
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

wire    [12:0]                  data_count                      ;       


//=============================================================================
//**************    Main Code   **************
//=============================================================================
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                buffer_data_count       <=      'd0;
        else if(read_start == 1'b1)
                buffer_data_count       <=      data_count;
end

feature_fifo_ip feature_fifo_ip_inst (
        .clk                    (sclk                   ),      // input wire clk
        .srst                   (~s_rst_n               ),      // input wire srst
        .din                    (buffer_wr_data         ),      // input wire [63 : 0] din
        .wr_en                  (buffer_wr_en           ),      // input wire wr_en
        .rd_en                  (buffer_rd_en           ),      // input wire rd_en
        .dout                   (buffer_rd_data         ),      // output wire [63 : 0] dout
        .full                   (                       ),      // output wire full
        .empty                  (                       ),      // output wire empty
        .data_count             (data_count             )// output wire [12 : 0] data_count
);

endmodule
