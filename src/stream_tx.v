module  stream_tx(
        // system siganls
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        output  wire    [63:0]  s_axis_s2mm_tdata       ,       
        output  wire            s_axis_s2mm_tvalid      ,       
        input                   s_axis_s2mm_tready      ,       
        output  reg             s_axis_s2mm_tlast       ,      
        // 
        output  wire            buffer_rd_en            ,       
        input           [63:0]  buffer_rd_data          ,
        input           [ 5:0]  state                   ,
        input           [12:0]  buffer_data_count       ,
        output  wire            read_finish                    
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

reg     [12:0]                  tx_cnt                          ;       

//=============================================================================
//**************    Main Code   **************
//=============================================================================
assign  s_axis_s2mm_tvalid      =       state[2];
assign  buffer_rd_en            =       s_axis_s2mm_tvalid & s_axis_s2mm_tready;
assign  s_axis_s2mm_tdata       =       buffer_rd_data;
assign  read_finish             =       s_axis_s2mm_tlast;

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                tx_cnt  <=      'd0;
        else if(s_axis_s2mm_tvalid == 1'b0)
                tx_cnt  <=      'd0;    
        else if(buffer_rd_en == 1'b1)
                tx_cnt  <=      tx_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                s_axis_s2mm_tlast       <=      1'b0;
        else if(s_axis_s2mm_tvalid == 1'b1 && tx_cnt == (buffer_data_count-2))
                s_axis_s2mm_tlast       <=      1'b1;
        else
                s_axis_s2mm_tlast       <=      1'b0;
end

endmodule
