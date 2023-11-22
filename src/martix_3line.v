module  martix_3line(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        input           [63:0]  data_in                 , 
        input                   data_in_vld             ,       
        input           [ 2:0]  feature_col_select      ,       
        input           [ 6:0]  padding_row_cnt         ,      // connect with conv_padding module 
        //
        output  wire    [63:0]  line2_data              ,
        output  reg     [63:0]  line1_data              ,
        output  reg     [63:0]  line0_data              ,
        output  wire            line_data_vld           
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


reg     [63:0]                  shift_reg_arr0[417:0]           ;
reg     [63:0]                  shift_reg_arr1[417:0]           ;



//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  line_data_vld   =       (padding_row_cnt >= 'd2) ? data_in_vld : 1'b0;
assign  line2_data      =       data_in;

always  @(*) begin
        case(feature_col_select)
                0: begin
                        line1_data      =       shift_reg_arr1[COL_418-1];
                        line0_data      =       shift_reg_arr0[COL_418-1];
                end
                1: begin
                        line1_data      =       shift_reg_arr1[COL_210-1];
                        line0_data      =       shift_reg_arr0[COL_210-1];
                end
                2: begin
                        line1_data      =       shift_reg_arr1[COL_106-1];
                        line0_data      =       shift_reg_arr0[COL_106-1];
                end
                3: begin
                        line1_data      =       shift_reg_arr1[COL_54-1];
                        line0_data      =       shift_reg_arr0[COL_54-1];
                end
                4: begin
                        line1_data      =       shift_reg_arr1[COL_28-1];
                        line0_data      =       shift_reg_arr0[COL_28-1];
                end
                5: begin
                        line1_data      =       shift_reg_arr1[COL_15-1];
                        line0_data      =       shift_reg_arr0[COL_15-1];
                end
                default: begin
                        line1_data      =       shift_reg_arr1[COL_418-1];
                        line0_data      =       shift_reg_arr0[COL_418-1];
                end
        endcase
end

always  @(posedge sclk) begin
        shift_reg_arr1[0]       <=      line2_data;
        shift_reg_arr0[0]       <=      line1_data;
end

genvar i;
generate
        for(i=1;i<=417;i=i+1) begin
                always  @(posedge sclk) begin
                        shift_reg_arr1[i]       <=      shift_reg_arr1[i-1];
                        shift_reg_arr0[i]       <=      shift_reg_arr0[i-1];
                end
        end
endgenerate


endmodule
