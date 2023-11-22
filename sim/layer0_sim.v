module  layer0_sim(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // 
        output  reg     [63:0]  m_axis_mm2s_tdata       ,       
        output  wire    [ 7:0]  m_axis_mm2s_tkeep       ,       
        output  reg             m_axis_mm2s_tvalid      ,       
        input                   m_axis_mm2s_tready      ,       
        output  reg             m_axis_mm2s_tlast       ,       
        // Lite-Reg
        output  reg     [31:0]  slave_lite_reg0         ,
        output  reg     [31:0]  slave_lite_reg1         ,
        output  reg     [31:0]  slave_lite_reg2         ,
        output  reg     [31:0]  slave_lite_reg3         ,
        //
        input                   task_finish                    
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
localparam      S_IDLE          =       8'h01                   ;
localparam      S_BIAS_TX       =       8'h02                   ;
localparam      S_LEAKYRELU_TX  =       8'h04                   ;
localparam      S_WEIGHT_TX     =       8'h08                   ;
localparam      S_FEATURE_TX    =       8'h10                   ;
localparam      S_CONV_CAL      =       8'h20                   ;
localparam      S_DMA_RX        =       8'h40                   ;
localparam      S_FINISH        =       8'h80                   ;

// localparam      TX_END          =       'd5                     ;
localparam      TX_END          =       'd59                    ;

reg     [ 7:0]                  state                           ;       

wire    [63:0]                  bias_data                       ;       
wire                            bias_valid                      ;       
wire                            bias_last                       ;       

wire    [63:0]                  leakyrelu_data                  ;       
wire                            leakyrelu_valid                 ;       
wire                            leakyrelu_last                  ;       

wire    [63:0]                  weight_data                     ;       
wire                            weight_valid                    ;       
wire                            weight_last                     ;       

wire    [63:0]                  feature_data                    ;       
wire                            feature_valid                   ;       
wire                            feature_last                    ;       

reg     [ 7:0]                  tx_cnt                          ;

//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  m_axis_mm2s_tkeep       =       8'hFF;

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0) begin
                state           <=      S_IDLE;
                slave_lite_reg0 <=      32'h0;
                slave_lite_reg1 <=      32'h0;
                slave_lite_reg2 <=      32'h0;
                slave_lite_reg3 <=      32'h0;
        end
        else case(state)
                S_IDLE: begin
                        state           <=      S_BIAS_TX;
                        slave_lite_reg0 <=      32'h21;
                        slave_lite_reg1 <=      32'h4B5A0101;   // Bias和Weight地址控制为1,计算后8个输出通道的结果
                        slave_lite_reg2 <=      32'h09004100;
                end
                S_BIAS_TX: begin
                        if(task_finish == 1'b1) begin
                                state   <=      S_LEAKYRELU_TX;
                                slave_lite_reg0 <=      32'h31;
                        end 
                        else begin
                                state   <=      S_BIAS_TX;
                                slave_lite_reg0 <=      32'h20;
                        end 
                end
                S_LEAKYRELU_TX: begin
                        if(task_finish == 1'b1) begin 
                                state   <=      S_WEIGHT_TX;
                                slave_lite_reg0 <=      32'h11;
                        end 
                        else begin
                                state   <=      S_LEAKYRELU_TX;
                                slave_lite_reg0 <=      32'h30;
                        end 
                end
                S_WEIGHT_TX: begin
                        if(task_finish == 1'b1) begin
                                state           <=      S_FEATURE_TX;
                                slave_lite_reg0 <=      32'h10_1181;
                        end 
                        else begin
                                state   <=      S_WEIGHT_TX;
                                slave_lite_reg0 <=      32'h10;
                        end 
                end
                S_FEATURE_TX: begin
                        if(task_finish == 1'b1) begin
                                state   <=      S_CONV_CAL;
                                slave_lite_reg0 <=      {slave_lite_reg0[31:4], 4'h4};
                        end 
                        else begin
                                state   <=      S_FEATURE_TX;
                                slave_lite_reg0 <=      {slave_lite_reg0[31:4], 4'h0};
                        end 
                end
                S_CONV_CAL: begin
                        if(task_finish == 1'b1) begin
                                state   <=      S_DMA_RX;
                                slave_lite_reg0 <=      {slave_lite_reg0[31:4], 4'h2};
                        end 
                        else begin
                                state   <=      S_CONV_CAL;
                                slave_lite_reg0 <=      {slave_lite_reg0[31:4], 4'h0};
                        end 
                end
                S_DMA_RX: begin
                        if(task_finish == 1'b1 && tx_cnt == TX_END)
                                state           <=      S_FINISH;
                        else if(task_finish == 1'b1 && tx_cnt < (TX_END-1)) begin
                                state           <=      S_FEATURE_TX;
                                slave_lite_reg0 <=      32'h10_1381;
                        end 
                        else if(task_finish == 1'b1 && tx_cnt == (TX_END-1)) begin
                                state           <=      S_FEATURE_TX;
                                slave_lite_reg0 <=      32'h4_1581;
                        end 
                        else begin
                                state           <=      S_DMA_RX;
                                slave_lite_reg0 <=      {slave_lite_reg0[31:4], 4'h0};
                        end 
                end 
                S_FINISH: begin
                        state           <=      S_FINISH;
                        slave_lite_reg0 <=      32'h00;
                end 
                default: begin
                        state           <=      S_IDLE;
                        slave_lite_reg0 <=      32'h0;
                        slave_lite_reg0 <=      32'h0;
                        slave_lite_reg0 <=      32'h0;
                        slave_lite_reg0 <=      32'h0;
                end
        endcase
end

always  @(*) begin
        case(state)
                S_BIAS_TX: begin
                        m_axis_mm2s_tdata       =       bias_data;
                        m_axis_mm2s_tvalid      =       bias_valid;
                        m_axis_mm2s_tlast       =       bias_last;
                end
                S_LEAKYRELU_TX: begin
                        m_axis_mm2s_tdata       =       leakyrelu_data;
                        m_axis_mm2s_tvalid      =       leakyrelu_valid;
                        m_axis_mm2s_tlast       =       leakyrelu_last;
                end
                S_WEIGHT_TX: begin
                        m_axis_mm2s_tdata       =       weight_data;
                        m_axis_mm2s_tvalid      =       weight_valid;
                        m_axis_mm2s_tlast       =       weight_last;
                end
                S_FEATURE_TX: begin
                        m_axis_mm2s_tdata       =       feature_data;
                        m_axis_mm2s_tvalid      =       feature_valid;
                        m_axis_mm2s_tlast       =       feature_last;
                end
                default: begin
                        m_axis_mm2s_tdata       =       64'h0;
                        m_axis_mm2s_tvalid      =       1'b0;
                        m_axis_mm2s_tlast       =       1'b0;
                end
        endcase
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                tx_cnt  <=      'd0;
        else if(state == S_FINISH)
                tx_cnt  <=      'd0;
        else if(state == S_DMA_RX && task_finish == 1'b1)
                tx_cnt  <=      tx_cnt + 1'b1;
end


layer0_bias_tx  layer0_bias_tx_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n & state[1]     ),
        //
        .bias_data              (bias_data              ),
        .bias_valid             (bias_valid             ),
        .bias_last              (bias_last              ),
        .ready                  (m_axis_mm2s_tready     )
);

layer0_leakyrelu_tx     layer0_leakyrelu_tx_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n & state[2]     ),
        //
        .leakyrelu_data         (leakyrelu_data         ),
        .leakyrelu_valid        (leakyrelu_valid        ),
        .leakyrelu_last         (leakyrelu_last         ),
        .ready                  (m_axis_mm2s_tready     )
);

layer0_weight_tx        layer0_weight_tx_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n & state[3]     ),
        //
        .weight_data            (weight_data            ),
        .weight_valid           (weight_valid           ),
        .weight_last            (weight_last            ),
        .ready                  (m_axis_mm2s_tready     )
);

layer0_feature_tx       layer0_feature_tx_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        //
        .feature_data           (feature_data           ),
        .feature_valid          (feature_valid          ),
        .feature_last           (feature_last           ),
        .ready                  (m_axis_mm2s_tready     ),
        .tx_cnt                 (tx_cnt                 ),
        .state                  (state                  )
);

endmodule
