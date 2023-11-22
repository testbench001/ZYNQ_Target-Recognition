module  weight_single_buffer(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // Stream Data
        input                   weight_data_in_vld      ,       
        input           [ 7:0]  weight_data_in          ,       
        input                   wr_en                   ,       
        input           [ 7:0]  wr_addr                 ,
        input           [ 2:0]  ch_cnt                  ,
        input                   conv_type               ,
        // 
        input           [ 7:0]  wbuffer_rd_addr         ,       
        output  wire    [71:0]  ch0_weight_3x3          ,       
        output  wire    [71:0]  ch1_weight_3x3          ,       
        output  wire    [71:0]  ch2_weight_3x3          ,       
        output  wire    [71:0]  ch3_weight_3x3          ,       
        output  wire    [71:0]  ch4_weight_3x3          ,       
        output  wire    [71:0]  ch5_weight_3x3          ,       
        output  wire    [71:0]  ch6_weight_3x3          ,       
        output  wire    [71:0]  ch7_weight_3x3                 
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/



wire                            ram0_wr_en                      ;       
wire                            ram1_wr_en                      ;       
wire                            ram2_wr_en                      ;       
wire                            ram3_wr_en                      ;       
wire                            ram4_wr_en                      ;       
wire                            ram5_wr_en                      ;       
wire                            ram6_wr_en                      ;       
wire                            ram7_wr_en                      ;       

reg     [71:0]                  wr_data                         ;       
//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  ram0_wr_en      =       (ch_cnt == 'd0) ? wr_en : 1'b0;
assign  ram1_wr_en      =       (ch_cnt == 'd1) ? wr_en : 1'b0;
assign  ram2_wr_en      =       (ch_cnt == 'd2) ? wr_en : 1'b0;
assign  ram3_wr_en      =       (ch_cnt == 'd3) ? wr_en : 1'b0;
assign  ram4_wr_en      =       (ch_cnt == 'd4) ? wr_en : 1'b0;
assign  ram5_wr_en      =       (ch_cnt == 'd5) ? wr_en : 1'b0;
assign  ram6_wr_en      =       (ch_cnt == 'd6) ? wr_en : 1'b0;
assign  ram7_wr_en      =       (ch_cnt == 'd7) ? wr_en : 1'b0;
            

always  @(posedge sclk) begin
        if(conv_type == 1'b0 && weight_data_in_vld == 1'b1)
                wr_data <=      {weight_data_in, wr_data[71:8]};
        else 
                wr_data <=      {64'h0, weight_data_in};
end



weight_ram_ip ch0_weight_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (ram0_wr_en             ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [7 : 0] addra
        .dina                   (wr_data                ),      // input wire [71 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (wbuffer_rd_addr        ),      // input wire [7 : 0] addrb
        .doutb                  (ch0_weight_3x3         )       // output wire [71 : 0] doutb
);

weight_ram_ip ch1_weight_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (ram1_wr_en             ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [7 : 0] addra
        .dina                   (wr_data                ),      // input wire [71 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (wbuffer_rd_addr        ),      // input wire [7 : 0] addrb
        .doutb                  (ch1_weight_3x3         )       // output wire [71 : 0] doutb
);

weight_ram_ip ch2_weight_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (ram2_wr_en             ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [7 : 0] addra
        .dina                   (wr_data                ),      // input wire [71 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (wbuffer_rd_addr        ),      // input wire [7 : 0] addrb
        .doutb                  (ch2_weight_3x3         )       // output wire [71 : 0] doutb
);

weight_ram_ip ch3_weight_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (ram3_wr_en             ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [7 : 0] addra
        .dina                   (wr_data                ),      // input wire [71 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (wbuffer_rd_addr        ),      // input wire [7 : 0] addrb
        .doutb                  (ch3_weight_3x3         )       // output wire [71 : 0] doutb
);

weight_ram_ip ch4_weight_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (ram4_wr_en             ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [7 : 0] addra
        .dina                   (wr_data                ),      // input wire [71 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (wbuffer_rd_addr        ),      // input wire [7 : 0] addrb
        .doutb                  (ch4_weight_3x3         )       // output wire [71 : 0] doutb
);

weight_ram_ip ch5_weight_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (ram5_wr_en             ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [7 : 0] addra
        .dina                   (wr_data                ),      // input wire [71 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (wbuffer_rd_addr        ),      // input wire [7 : 0] addrb
        .doutb                  (ch5_weight_3x3         )       // output wire [71 : 0] doutb
);

weight_ram_ip ch6_weight_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (ram6_wr_en             ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [7 : 0] addra
        .dina                   (wr_data                ),      // input wire [71 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (wbuffer_rd_addr        ),      // input wire [7 : 0] addrb
        .doutb                  (ch6_weight_3x3         )       // output wire [71 : 0] doutb
);

weight_ram_ip ch7_weight_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (ram7_wr_en             ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [7 : 0] addra
        .dina                   (wr_data                ),      // input wire [71 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (wbuffer_rd_addr        ),      // input wire [7 : 0] addrb
        .doutb                  (ch7_weight_3x3         )       // output wire [71 : 0] doutb
);


endmodule
