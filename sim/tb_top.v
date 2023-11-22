`timescale      1ns/1ns 

module  tb_top;

reg             sclk;
reg             s_rst_n;

reg     [31:0]  slave_lite_reg0;

initial begin
        sclk    =       1;
        s_rst_n <=      0;
		slave_lite_reg0 <= 32'h0;
        #100
        s_rst_n <=      1;
		#100
		slave_lite_reg0 <= 32'h66_D784;
		#10
		slave_lite_reg0 <= 32'h66_D780;
end

always  #5      sclk    =       ~sclk;

//////////////////////////////////////////////////
wire    [63:0]  m_axis_mm2s_tdata       ;       
wire    [ 7:0]  m_axis_mm2s_tkeep       ;       
wire            m_axis_mm2s_tvalid      ;       
wire            m_axis_mm2s_tready      ;              
wire            m_axis_mm2s_tlast       ;       
// Lite-Reg
// wire    [31:0]  slave_lite_reg0         ;
wire    [31:0]  slave_lite_reg1         ;
wire    [31:0]  slave_lite_reg2         ;
wire    [31:0]  slave_lite_reg3         ;
//
wire            task_finish             ;





yolo_accel_top          yolo_accel_top_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // Axi4-Lite Reg
        .slave_lite_reg0        (slave_lite_reg0        ),
        .slave_lite_reg1        (slave_lite_reg1        ),
        .slave_lite_reg2        (slave_lite_reg2        ),
        .slave_lite_reg3        (slave_lite_reg3        ),
        // Axi4-Strea Rx
        .s_axis_mm2s_tdata      (m_axis_mm2s_tdata      ),
        .s_axis_mm2s_tkeep      (m_axis_mm2s_tkeep      ),
        .s_axis_mm2s_tvalid     (m_axis_mm2s_tvalid     ),
        .s_axis_mm2s_tready     (m_axis_mm2s_tready     ),
        .s_axis_mm2s_tlast      (m_axis_mm2s_tlast      ),
        // Axi4-Stream TX
        .s_axis_s2mm_tdata      (                       ),
        .s_axis_s2mm_tkeep      (                       ),
        .s_axis_s2mm_tvalid     (                       ),
        .s_axis_s2mm_tready     (1'b1                   ),
        .s_axis_s2mm_tlast      (                       ),
        // Generate Intr
        .task_finish            (task_finish            )
);




endmodule
