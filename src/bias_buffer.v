module  bias_buffer(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // Stream Data
        input           [63:0]  stream_rx_data          ,       
        input                   stream_bias_vld         ,   
        input                   write_finish            ,          
        // 
        input           [ 6:0]  bias_rd_addr            ,       
        output  wire    [31:0]  bias_ch0                ,       
        output  wire    [31:0]  bias_ch1                ,       
        output  wire    [31:0]  bias_ch2                ,       
        output  wire    [31:0]  bias_ch3                ,       
        output  wire    [31:0]  bias_ch4                ,       
        output  wire    [31:0]  bias_ch5                ,       
        output  wire    [31:0]  bias_ch6                ,       
        output  wire    [31:0]  bias_ch7                       
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

reg     [ 8:0]                  data_cnt                        ;       
wire    [ 6:0]                  wr_addr                         ;
wire                            ram0_wr_en                      ;       
wire                            ram1_wr_en                      ;       
wire                            ram2_wr_en                      ;       
wire                            ram3_wr_en                      ;       

wire    [ 1:0]                  ram_sel                         ;

//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  wr_addr         =       data_cnt[8:2];

assign  ram_sel         =       data_cnt[1:0];
assign  ram0_wr_en      =       (ram_sel == 'd0) ? stream_bias_vld : 1'b0;   
assign  ram1_wr_en      =       (ram_sel == 'd1) ? stream_bias_vld : 1'b0;   
assign  ram2_wr_en      =       (ram_sel == 'd2) ? stream_bias_vld : 1'b0;   
assign  ram3_wr_en      =       (ram_sel == 'd3) ? stream_bias_vld : 1'b0;   

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                data_cnt        <=      'd0;
        else if(write_finish == 1'b1 && stream_bias_vld == 1'b1)
                data_cnt        <=      'd0;
        else if(stream_bias_vld == 1'b1)
                data_cnt        <=      data_cnt + 1'b1;
end

bias_ram_ip     U0_bias_ram_ip_inst (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (ram0_wr_en             ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [6 : 0] addra
        .dina                   (stream_rx_data         ),      // input wire [63 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (bias_rd_addr           ),      // input wire [6 : 0] addrb
        .doutb                  ({bias_ch1, bias_ch0}   )       // output wire [63 : 0] doutb
);

bias_ram_ip     U1_bias_ram_ip_inst (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (ram1_wr_en             ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [6 : 0] addra
        .dina                   (stream_rx_data         ),      // input wire [63 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (bias_rd_addr           ),      // input wire [6 : 0] addrb
        .doutb                  ({bias_ch3, bias_ch2}   )       // output wire [63 : 0] doutb
);

bias_ram_ip     U2_bias_ram_ip_inst (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (ram2_wr_en             ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [6 : 0] addra
        .dina                   (stream_rx_data         ),      // input wire [63 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (bias_rd_addr           ),      // input wire [6 : 0] addrb
        .doutb                  ({bias_ch5, bias_ch4}   )       // output wire [63 : 0] doutb
);

bias_ram_ip     U3_bias_ram_ip_inst (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (ram3_wr_en             ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [6 : 0] addra
        .dina                   (stream_rx_data         ),      // input wire [63 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (bias_rd_addr           ),      // input wire [6 : 0] addrb
        .doutb                  ({bias_ch7, bias_ch6}   )       // output wire [63 : 0] doutb
);



endmodule
