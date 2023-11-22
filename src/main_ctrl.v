`include "debug_ctrl.h"

module  main_ctrl(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // Axi4-Lite Reg
        input           [31:0]  slave_lite_reg0         ,
        input           [31:0]  slave_lite_reg1         ,
        input           [31:0]  slave_lite_reg2         ,
        input           [31:0]  slave_lite_reg3         ,
        // 
        output  wire            read_start              ,       
        output  reg     [ 5:0]  state                   ,
        output  wire    [ 1:0]  data_type               ,       
        output  wire            conv_type               ,       
        output  wire    [ 1:0]  site_type               ,       
        output  wire    [ 1:0]  batch_type              ,       
        output  wire    [ 2:0]  feature_col_select      ,       
        output  wire    [ 6:0]  feature_row             ,       
        output  wire    [ 7:0]  wbuffer_rd_addr         ,       
        output  wire    [ 7:0]  bbuffer_rd_addr         ,       
        output  wire    [14:0]  mult                    ,       
        output  wire    [ 7:0]  shift                   ,       
        output  wire    [ 7:0]  zero_point_in           ,
        output  wire    [ 7:0]  zero_point_out          ,
        input                   write_finish            ,
        input                   read_finish             ,
        input                   conv_finish             ,
        input                   upsample_finish         ,
        output  wire            task_finish             ,
        output  wire            weight_store_start      , 
        output  wire            conv1x1_start           ,         
        output  wire            padding_start           ,
        output  wire            pool_stride             ,
        output  wire            is_pool                 
        
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
localparam      S_IDLE          =       6'b00_0001              ;
localparam      S_WRITE         =       6'b00_0010              ;
localparam      S_READ          =       6'b00_0100              ;
localparam      S_CONV          =       6'b00_1000              ;
localparam      S_UPSAMPLE      =       6'b01_0000              ;
localparam      S_FINISH        =       6'b10_0000              ;

`ifndef  SIM
localparam      FINISH_END      =       'd200                   ;
`else
localparam      FINISH_END      =       'd0                     ;
`endif

// REG0
wire                            write_start                     ;       
//wire                            read_start                      ;       
wire                            conv_start                      ;       
wire                            upsample_start                  ;       
// wire    [ 1:0]                  data_type                       ;       
// wire                            conv_type                       ;       
wire                            is_padding                      ;       
// wire                            is_pool                         ;       
// wire    [ 1:0]                  site_type                       ;       
// wire    [ 1:0]                  batch_type                      ;       
// wire    [ 2:0]                  feature_col_select              ;       
// wire    [ 5:0]                  feature_row                     ;       
// REG1
// wire    [ 7:0]                  wbuffer_rd_addr                 ;       
// wire    [ 7:0]                  bbuffer_rd_addr                 ;       
// wire    [15:0]                  mult                            ;       
// REG2
// wire    [ 7:0]                  zero_point_in                   ;       
// wire    [ 7:0]                  zero_point_out                  ;       
wire    [ 7:0]                  zero_point_act                  ;       
// wire    [ 7:0]                  shift                           ;       
// FSM
// reg     [ 5:0]                  state                           ;
reg     [ 7:0]                  finish_cnt                      ;
//=============================================================================
//**************    Main Code   **************
//=============================================================================
assign  write_start             =       slave_lite_reg0[0];
assign  read_start              =       slave_lite_reg0[1];
assign  conv_start              =       slave_lite_reg0[2];
assign  upsample_start          =       slave_lite_reg0[3];
assign  data_type               =       slave_lite_reg0[5:4];
assign  conv_type               =       slave_lite_reg0[6];
assign  is_padding              =       slave_lite_reg0[7];
assign  is_pool                 =       slave_lite_reg0[8];
assign  site_type               =       slave_lite_reg0[10:9];
assign  batch_type              =       slave_lite_reg0[12:11];
assign  pool_stride             =       slave_lite_reg0[13];
assign  feature_col_select      =       slave_lite_reg0[16:14];
assign  feature_row             =       slave_lite_reg0[23:17];
                             
assign  wbuffer_rd_addr         =       slave_lite_reg1[7:0];
assign  bbuffer_rd_addr         =       slave_lite_reg1[15:8];
assign  mult                    =       slave_lite_reg1[31:16];
  
assign  zero_point_in           =       slave_lite_reg2[7:0];
assign  zero_point_out          =       slave_lite_reg2[15:8];
assign  zero_point_act          =       slave_lite_reg2[23:16];  
assign  shift                   =       slave_lite_reg2[31:24];  

assign  weight_store_start      =       (data_type == 2'b01) ? write_start : 1'b0;
assign  padding_start           =       (conv_type == 1'b0) ? conv_start : 1'b0;
assign  conv1x1_start           =       (conv_type == 1'b1) ? conv_start : 1'b0;



//////////////////////////////////////////////////////
assign  task_finish             =       state[5]; 


always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                state   <=      S_IDLE;
        else case(state)
                S_IDLE: 
                        if(write_start == 1'b1)
                                state   <=      S_WRITE;
                        else if(read_start == 1'b1)
                                state   <=      S_READ;
                        else if(conv_start == 1'b1)
                                state   <=      S_CONV;
                        else if(upsample_start == 1'b1)
                                state   <=      S_UPSAMPLE;
                        else
                                state   <=      S_IDLE;
                S_WRITE:
                        if(write_finish == 1'b1)
                                state   <=      S_FINISH;
                        else
                                state   <=      S_WRITE;
                S_READ:
                        if(read_finish == 1'b1)
                                state   <=      S_FINISH;
                        else
                                state   <=      S_READ;
                S_CONV:
                        if(conv_finish == 1'b1)
                                state   <=      S_FINISH;
                        else
                                state   <=      S_CONV;
                S_UPSAMPLE:
                        if(upsample_finish == 1'b1)
                                state   <=      S_FINISH;
                        else
                                state   <=      S_UPSAMPLE;
                S_FINISH:
                        if(finish_cnt >= FINISH_END)
                                state   <=      S_IDLE;
                        else
                                state   <=      S_FINISH;
                default:
                        state   <=      S_IDLE;
        endcase
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                finish_cnt      <=      'd0;
        else if(state == S_FINISH)
                finish_cnt      <=      finish_cnt + 1'b1;
        else
                finish_cnt      <=      'd0;
end


endmodule
