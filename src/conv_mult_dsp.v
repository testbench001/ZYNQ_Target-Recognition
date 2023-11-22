module  conv_mult_dsp(
        // system signals
        input                   sclk                    ,       
        //
        input   signed  [ 7:0]  data_a                  ,
        input   signed  [ 7:0]  data_d                  ,
        input   signed  [ 7:0]  data_b                  ,
        //
        output  wire signed [15:0]  data_ab             ,
        output  wire signed [15:0]  data_db             
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/


wire    signed  [24:0]          dsp_a                           ;
wire    signed  [24:0]          dsp_d                           ;
wire    signed  [17:0]          dsp_b                           ;

wire    signed  [42:0]          dsp_p                           ;

//=============================================================================
//**************    Main Code   **************
//=============================================================================

assign  dsp_a   =       {data_a[7],data_a, 16'h0};
assign  dsp_d   =       {{17{data_d[7]}}, data_d};
assign  dsp_b   =       {{10{data_b[7]}}, data_b};

assign  data_db =       dsp_p[15:0];
assign  data_ab =       (data_db[15] == 1'b1) ? (dsp_p[31:16]+1) : dsp_p[31:16];

xbip_dsp48_macro_0 xbip_dsp48_macro_0_inst (
        .CLK                    (sclk                   ),      // input wire CLK
        .A                      (dsp_a                  ),      // input wire [24 : 0] A
        .B                      (dsp_b                  ),      // input wire [17 : 0] B
        .D                      (dsp_d                  ),      // input wire [24 : 0] D
        .P                      (dsp_p                  )       // output wire [42 : 0] P
);

endmodule
