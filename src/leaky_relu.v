module  leaky_relu(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // Stream Data
        input           [63:0]  stream_rx_data          ,       
        input                   stream_leakyrelu_vld    ,    
        input                   write_finish            ,        
        //
        input           [ 7:0]  ch0_data_i              ,       
        input           [ 7:0]  ch1_data_i              ,       
        input           [ 7:0]  ch2_data_i              ,       
        input           [ 7:0]  ch3_data_i              ,       
        input           [ 7:0]  ch4_data_i              ,       
        input           [ 7:0]  ch5_data_i              ,       
        input           [ 7:0]  ch6_data_i              ,       
        input           [ 7:0]  ch7_data_i              ,       
        input                   ch_data_vld_i           ,       
        //
        output  wire    [ 7:0]  ch0_data_o              ,       
        output  wire    [ 7:0]  ch1_data_o              ,       
        output  wire    [ 7:0]  ch2_data_o              ,       
        output  wire    [ 7:0]  ch3_data_o              ,       
        output  wire    [ 7:0]  ch4_data_o              ,       
        output  wire    [ 7:0]  ch5_data_o              ,       
        output  wire    [ 7:0]  ch6_data_o              ,       
        output  wire    [ 7:0]  ch7_data_o              ,       
        output  wire            ch_data_vld_o                  
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

reg     [ 4:0]                  wr_addr                         ;       

reg     [ 1:0]                  data_arr                        ;       
//=============================================================================
//**************    Main Code   **************
//=============================================================================
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                wr_addr <=      'd0;
        else if(write_finish == 1'b1 && stream_leakyrelu_vld == 1'b1)
                wr_addr <=      'd0;
        else if(stream_leakyrelu_vld == 1'b1)
                wr_addr <=      wr_addr + 1'b1;                
end

always  @(posedge sclk) begin
        data_arr        <=      {data_arr[0], ch_data_vld_i};
end

assign  ch_data_vld_o   =       data_arr[1];

leakyrelu_ram_ip        U0_leakyrelu_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (stream_leakyrelu_vld   ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [4 : 0] addra
        .dina                   (stream_rx_data         ),      // input wire [63 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (ch0_data_i             ),      // input wire [7 : 0] addrb
        .doutb                  (ch0_data_o             )       // output wire [7 : 0] doutb
);    

leakyrelu_ram_ip        U1_leakyrelu_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (stream_leakyrelu_vld   ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [4 : 0] addra
        .dina                   (stream_rx_data         ),      // input wire [63 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (ch1_data_i             ),      // input wire [7 : 0] addrb
        .doutb                  (ch1_data_o             )       // output wire [7 : 0] doutb
);    

leakyrelu_ram_ip        U2_leakyrelu_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (stream_leakyrelu_vld   ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [4 : 0] addra
        .dina                   (stream_rx_data         ),      // input wire [63 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (ch2_data_i             ),      // input wire [7 : 0] addrb
        .doutb                  (ch2_data_o             )       // output wire [7 : 0] doutb
);    

leakyrelu_ram_ip        U3_leakyrelu_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (stream_leakyrelu_vld   ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [4 : 0] addra
        .dina                   (stream_rx_data         ),      // input wire [63 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (ch3_data_i             ),      // input wire [7 : 0] addrb
        .doutb                  (ch3_data_o             )       // output wire [7 : 0] doutb
);    

leakyrelu_ram_ip        U4_leakyrelu_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (stream_leakyrelu_vld   ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [4 : 0] addra
        .dina                   (stream_rx_data         ),      // input wire [63 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (ch4_data_i             ),      // input wire [7 : 0] addrb
        .doutb                  (ch4_data_o             )       // output wire [7 : 0] doutb
);    


leakyrelu_ram_ip        U5_leakyrelu_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (stream_leakyrelu_vld   ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [4 : 0] addra
        .dina                   (stream_rx_data         ),      // input wire [63 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (ch5_data_i             ),      // input wire [7 : 0] addrb
        .doutb                  (ch5_data_o             )       // output wire [7 : 0] doutb
);    

leakyrelu_ram_ip        U6_leakyrelu_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (stream_leakyrelu_vld   ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [4 : 0] addra
        .dina                   (stream_rx_data         ),      // input wire [63 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (ch6_data_i             ),      // input wire [7 : 0] addrb
        .doutb                  (ch6_data_o             )       // output wire [7 : 0] doutb
);    

leakyrelu_ram_ip        U7_leakyrelu_ram_ip (
        .clka                   (sclk                   ),      // input wire clka
        .wea                    (stream_leakyrelu_vld   ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),      // input wire [4 : 0] addra
        .dina                   (stream_rx_data         ),      // input wire [63 : 0] dina
        .clkb                   (sclk                   ),      // input wire clkb
        .addrb                  (ch7_data_i             ),      // input wire [7 : 0] addrb
        .doutb                  (ch7_data_o             )       // output wire [7 : 0] doutb
);    

endmodule
