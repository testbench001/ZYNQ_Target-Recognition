module  stream_rx(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // Stream Rx
        input           [63:0]  s_axis_mm2s_tdata       ,       
        input           [ 7:0]  s_axis_mm2s_tkeep       ,       
        input                   s_axis_mm2s_tvalid      ,       
        output  wire            s_axis_mm2s_tready      ,       
        input                   s_axis_mm2s_tlast       ,     
        // Main Ctrl
        input           [ 1:0]  data_type               ,
        input           [ 5:0]  state                   ,       
        output  wire            write_finish            , 
        // 
        output  wire    [63:0]  stream_rx_data          ,       
        output  wire            stream_feature_vld      ,       
        output  wire            stream_weight_vld       ,       
        output  wire            stream_bias_vld         ,       
        output  wire            stream_leakyrelu_vld           
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
localparam      FEATURE_DATA    =       2'b00                   ;
localparam      WEIGHT_DATA     =       2'b01                   ;
localparam      BIAS_DATA       =       2'b10                   ;
localparam      LEAKYRELU_DATA  =       2'b11                   ;



wire                            stream_data_vld                 ;       

//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  s_axis_mm2s_tready      =       state[1];
assign  write_finish            =       s_axis_mm2s_tlast & stream_data_vld;
assign  stream_data_vld         =       s_axis_mm2s_tvalid & s_axis_mm2s_tready;

assign  stream_rx_data          =       s_axis_mm2s_tdata;
assign  stream_feature_vld      =       (data_type == FEATURE_DATA) ? stream_data_vld : 1'b0;
assign  stream_weight_vld       =       (data_type == WEIGHT_DATA) ? stream_data_vld : 1'b0;
assign  stream_bias_vld         =       (data_type == BIAS_DATA) ? stream_data_vld : 1'b0;
assign  stream_leakyrelu_vld    =       (data_type == LEAKYRELU_DATA) ? stream_data_vld : 1'b0;


endmodule
