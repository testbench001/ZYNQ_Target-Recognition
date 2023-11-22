module  conv1x1_read_ctrl(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // Lite Reg
        input                   conv1x1_start           ,       
        input           [ 2:0]  feature_col_select      ,       
        input           [ 6:0]  feature_row             ,       
        //
        output  reg             buffer_rd_en            ,       
        output  wire            conv1x1_read_finish     ,       
        // 
        output  reg     [ 6:0]  row_cnt                 ,       
        output  reg     [ 8:0]  col_cnt                        
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
localparam      COL_26          =       'd26                    ;
localparam      COL_13          =       'd13                    ;



reg     [ 8:0]                  col_cnt_reg                     ;

reg                             buffer_rd_en_r1                 ;       
//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  conv1x1_read_finish     =       ~buffer_rd_en & buffer_rd_en_r1;

always  @(posedge sclk) begin
        buffer_rd_en_r1 <=      buffer_rd_en;
end 

always  @(posedge sclk) begin
        case(feature_col_select)
                4:      col_cnt_reg     <=      COL_26;
                5:      col_cnt_reg     <=      COL_13;
                default:col_cnt_reg     <=      COL_13;
        endcase
end



always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                col_cnt <=      'd0;
        else if(buffer_rd_en == 1'b1 && col_cnt >= (col_cnt_reg-1))
                col_cnt <=      'd0;
        else if(buffer_rd_en == 1'b1)
                col_cnt <=      col_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                row_cnt <=      'd0;
        else if(buffer_rd_en == 1'b0)
                row_cnt <=      'd0;
        else if(buffer_rd_en == 1'b1 && col_cnt >= (col_cnt_reg-1))
                row_cnt <=      row_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                buffer_rd_en    <=      1'b0;
        else if(row_cnt >= feature_row && col_cnt >= (col_cnt_reg-1) && buffer_rd_en == 1'b1)
                buffer_rd_en    <=      1'b0;
        else if(conv1x1_start == 1'b1)
                buffer_rd_en    <=      1'b1;
        
end

endmodule
