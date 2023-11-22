module  conv_padding(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // Lite Reg
        input                   padding_start           ,       
        input           [ 1:0]  site_type               ,       
        input           [ 2:0]  feature_col_select      ,       
        input           [ 6:0]  feature_row             ,       
        //
        input           [63:0]  buffer_rd_data          ,       
        output  reg             buffer_rd_en            ,       
        output  wire    [63:0]  padding_data            ,       
        output  wire            padding_data_vld        ,  
        output  wire            padding_finish          ,
        // 
        output  reg     [ 6:0]  row_cnt                 ,       
        output  reg     [ 8:0]  col_cnt                        

);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
localparam      COL_418         =       'd418                   ;
localparam      COL_210         =       'd210                   ;
localparam      COL_106         =       'd106                   ;
localparam      COL_54          =       'd54                    ;
localparam      COL_28          =       'd28                    ;
localparam      COL_15          =       'd15                    ;


reg                             padding_work                    ;       
reg                             padding_work_r1                 ;       
// reg     [ 8:0]                  col_cnt                         ;
// reg     [ 6:0]                  row_cnt                         ;
reg     [ 8:0]                  col_cnt_reg                     ;


//=============================================================================
//**************    Main Code   **************
//=============================================================================
assign  padding_data            =       (buffer_rd_en == 1'b1) ? buffer_rd_data : 64'h0;
assign  padding_data_vld        =       padding_work;
assign  padding_finish          =       ~padding_work & padding_work_r1;

always  @(posedge sclk) begin
        padding_work_r1 <=      padding_work;
end 

always  @(posedge sclk) begin
        case(feature_col_select)
                0:      col_cnt_reg     <=      COL_418;
                1:      col_cnt_reg     <=      COL_210;
                2:      col_cnt_reg     <=      COL_106;
                3:      col_cnt_reg     <=      COL_54;
                4:      col_cnt_reg     <=      COL_28;
                5:      col_cnt_reg     <=      COL_15;
                default:col_cnt_reg     <=      COL_418;
        endcase
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                padding_work    <=      1'b0;
        else if(site_type == 'd1 && padding_work == 1'b1 && row_cnt >= feature_row && col_cnt >= (col_cnt_reg-1))
                padding_work    <=      1'b0;
		else if(site_type == 'd3 && padding_work == 1'b1 && row_cnt >= (feature_row+2) && col_cnt >= (col_cnt_reg-1))
                padding_work    <=      1'b0;
        else if(site_type[0] == 1'b0 && padding_work == 1'b1 && row_cnt >= (feature_row+1) && col_cnt >= (col_cnt_reg-1))
                padding_work    <=      1'b0;
        else if(padding_start == 1'b1)
                padding_work    <=      1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                col_cnt <=      'd0;
        else if(padding_work == 1'b1 && col_cnt >= (col_cnt_reg-1))
                col_cnt <=      'd0;
        else if(padding_work == 1'b1)
                col_cnt <=      col_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                row_cnt <=      'd0;
        else if(padding_work == 1'b0)
                row_cnt <=      'd0;
        else if(padding_work == 1'b1 && col_cnt >= (col_cnt_reg-1))
                row_cnt <=      row_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                buffer_rd_en    <=      1'b0;
        else if(padding_work == 1'b1)
                case(site_type)
                        0:      if(row_cnt >= 'd1 && col_cnt >= 'd0 && col_cnt < (col_cnt_reg-2))
                                        buffer_rd_en    <=      1'b1;
                                else 
                                        buffer_rd_en    <=      1'b0;
                        1:      if(col_cnt >= 'd0 && col_cnt < (col_cnt_reg-2))
                                        buffer_rd_en    <=      1'b1;
                                else 
                                        buffer_rd_en    <=      1'b0;
                        2:      if(col_cnt >= 'd0 && col_cnt < (col_cnt_reg-2) && row_cnt <= feature_row)
                                        buffer_rd_en    <=      1'b1;
                                else 
                                        buffer_rd_en    <=      1'b0;
						3:      if(col_cnt >= 'd0 && col_cnt < (col_cnt_reg-2) && row_cnt >= 'd1 && row_cnt <= (feature_row+1))
                                        buffer_rd_en    <=      1'b1;
                                else 
                                        buffer_rd_en    <=      1'b0;
                        default:
                                buffer_rd_en    <=      1'b0;

                endcase
        else
                buffer_rd_en    <=      1'b0;
end

endmodule
