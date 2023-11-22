module  layer13_bias_tx(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        output  wire    [63:0]  bias_data               ,
        output  reg             bias_valid              ,       
        output  wire            bias_last               ,       
        input                   ready                          
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
localparam      INDEX_END       =       'd256                   ;


wire    [31:0]                  bias_arr[INDEX_END-1:0]         ;
reg     [ 8:0]                  index                           ;       


//=============================================================================
//**************    Main Code   **************
//=============================================================================
assign bias_arr[ 0] = 1369; 
assign bias_arr[ 1] = 66; 
assign bias_arr[ 2] = 293; 
assign bias_arr[ 3] = 1534; 
assign bias_arr[ 4] = -46; 
assign bias_arr[ 5] = 1280; 
assign bias_arr[ 6] = 1230; 
assign bias_arr[ 7] = 736; 
assign bias_arr[ 8] = 958; 
assign bias_arr[ 9] = 1479; 
assign bias_arr[10] = 1478; 
assign bias_arr[11] = 500; 
assign bias_arr[12] = -613; 
assign bias_arr[13] = 1006; 
assign bias_arr[14] = 259; 
assign bias_arr[15] = -542; 
assign bias_arr[16] = 288; 
assign bias_arr[17] = 1303; 
assign bias_arr[18] = 78; 
assign bias_arr[19] = -123; 
assign bias_arr[20] = 991; 
assign bias_arr[21] = -352; 
assign bias_arr[22] = -259; 
assign bias_arr[23] = -642; 
assign bias_arr[24] = 1316; 
assign bias_arr[25] = 1372; 
assign bias_arr[26] = 532; 
assign bias_arr[27] = 710; 
assign bias_arr[28] = -158; 
assign bias_arr[29] = 906; 
assign bias_arr[30] = 675; 
assign bias_arr[31] = -388; 
assign bias_arr[32] = 714; 
assign bias_arr[33] = 891; 
assign bias_arr[34] = 787; 
assign bias_arr[35] = 904; 
assign bias_arr[36] = 1089; 
assign bias_arr[37] = 434; 
assign bias_arr[38] = 1084; 
assign bias_arr[39] = 1720; 
assign bias_arr[40] = 1679; 
assign bias_arr[41] = 1029; 
assign bias_arr[42] = 650; 
assign bias_arr[43] = 738; 
assign bias_arr[44] = 883; 
assign bias_arr[45] = 537; 
assign bias_arr[46] = 250; 
assign bias_arr[47] = 798; 
assign bias_arr[48] = -259; 
assign bias_arr[49] = 1543; 
assign bias_arr[50] = 958; 
assign bias_arr[51] = 218; 
assign bias_arr[52] = 1117; 
assign bias_arr[53] = 922; 
assign bias_arr[54] = -329; 
assign bias_arr[55] = 1189; 
assign bias_arr[56] = -140; 
assign bias_arr[57] = -172; 
assign bias_arr[58] = 1184; 
assign bias_arr[59] = 1003; 
assign bias_arr[60] = 707; 
assign bias_arr[61] = -57; 
assign bias_arr[62] = 849; 
assign bias_arr[63] = -520; 
assign bias_arr[64] = -214; 
assign bias_arr[65] = 1157; 
assign bias_arr[66] = 911; 
assign bias_arr[67] = -730; 
assign bias_arr[68] = -1556; 
assign bias_arr[69] = 1501; 
assign bias_arr[70] = 329; 
assign bias_arr[71] = 34; 
assign bias_arr[72] = 1360; 
assign bias_arr[73] = -505; 
assign bias_arr[74] = 339; 
assign bias_arr[75] = 686; 
assign bias_arr[76] = 610; 
assign bias_arr[77] = 886; 
assign bias_arr[78] = 815; 
assign bias_arr[79] = -555; 
assign bias_arr[80] = 768; 
assign bias_arr[81] = 482; 
assign bias_arr[82] = 949; 
assign bias_arr[83] = -611; 
assign bias_arr[84] = 472; 
assign bias_arr[85] = 1398; 
assign bias_arr[86] = 295; 
assign bias_arr[87] = 1787; 
assign bias_arr[88] = 1350; 
assign bias_arr[89] = 738; 
assign bias_arr[90] = 1088; 
assign bias_arr[91] = 1698; 
assign bias_arr[92] = 596; 
assign bias_arr[93] = -440; 
assign bias_arr[94] = 378; 
assign bias_arr[95] = -132; 
assign bias_arr[96] = 692; 
assign bias_arr[97] = 798; 
assign bias_arr[98] = 1495; 
assign bias_arr[99] = 22; 
assign bias_arr[100] = -609; 
assign bias_arr[101] = 303; 
assign bias_arr[102] = 1698; 
assign bias_arr[103] = -681; 
assign bias_arr[104] = 513; 
assign bias_arr[105] = -109; 
assign bias_arr[106] = -349; 
assign bias_arr[107] = 1046; 
assign bias_arr[108] = 1010; 
assign bias_arr[109] = 1412; 
assign bias_arr[110] = 1481; 
assign bias_arr[111] = -601; 
assign bias_arr[112] = -476; 
assign bias_arr[113] = 669; 
assign bias_arr[114] = 1187; 
assign bias_arr[115] = 1936; 
assign bias_arr[116] = 658; 
assign bias_arr[117] = 1293; 
assign bias_arr[118] = 1209; 
assign bias_arr[119] = 298; 
assign bias_arr[120] = 607; 
assign bias_arr[121] = 575; 
assign bias_arr[122] = 975; 
assign bias_arr[123] = 42; 
assign bias_arr[124] = 800; 
assign bias_arr[125] = 809; 
assign bias_arr[126] = 455; 
assign bias_arr[127] = 1100; 
assign bias_arr[128] = 509; 
assign bias_arr[129] = 367; 
assign bias_arr[130] = 1652; 
assign bias_arr[131] = 955; 
assign bias_arr[132] = 263; 
assign bias_arr[133] = 1467; 
assign bias_arr[134] = 1347; 
assign bias_arr[135] = 930; 
assign bias_arr[136] = -1330; 
assign bias_arr[137] = 943; 
assign bias_arr[138] = 399; 
assign bias_arr[139] = 863; 
assign bias_arr[140] = 337; 
assign bias_arr[141] = -487; 
assign bias_arr[142] = 1857; 
assign bias_arr[143] = 560; 
assign bias_arr[144] = -530; 
assign bias_arr[145] = 938; 
assign bias_arr[146] = 1503; 
assign bias_arr[147] = 955; 
assign bias_arr[148] = 916; 
assign bias_arr[149] = 1755; 
assign bias_arr[150] = 824; 
assign bias_arr[151] = -133; 
assign bias_arr[152] = 371; 
assign bias_arr[153] = 582; 
assign bias_arr[154] = 700; 
assign bias_arr[155] = 1450; 
assign bias_arr[156] = 1738; 
assign bias_arr[157] = 274; 
assign bias_arr[158] = 1385; 
assign bias_arr[159] = 728; 
assign bias_arr[160] = 667; 
assign bias_arr[161] = 1055; 
assign bias_arr[162] = 166; 
assign bias_arr[163] = 1345; 
assign bias_arr[164] = 1031; 
assign bias_arr[165] = 1079; 
assign bias_arr[166] = 1363; 
assign bias_arr[167] = 1608; 
assign bias_arr[168] = 1045; 
assign bias_arr[169] = 1686; 
assign bias_arr[170] = -172; 
assign bias_arr[171] = -166; 
assign bias_arr[172] = -598; 
assign bias_arr[173] = 304; 
assign bias_arr[174] = 1074; 
assign bias_arr[175] = 1310; 
assign bias_arr[176] = 433; 
assign bias_arr[177] = 467; 
assign bias_arr[178] = -121; 
assign bias_arr[179] = 1144; 
assign bias_arr[180] = 1917; 
assign bias_arr[181] = 1061; 
assign bias_arr[182] = 1288; 
assign bias_arr[183] = -873; 
assign bias_arr[184] = 623; 
assign bias_arr[185] = 1059; 
assign bias_arr[186] = 745; 
assign bias_arr[187] = 1216; 
assign bias_arr[188] = 147; 
assign bias_arr[189] = 1067; 
assign bias_arr[190] = 281; 
assign bias_arr[191] = 1709; 
assign bias_arr[192] = 1322; 
assign bias_arr[193] = -408; 
assign bias_arr[194] = 849; 
assign bias_arr[195] = -1192; 
assign bias_arr[196] = 350; 
assign bias_arr[197] = 1367; 
assign bias_arr[198] = 1197; 
assign bias_arr[199] = 1011; 
assign bias_arr[200] = 1107; 
assign bias_arr[201] = 1207; 
assign bias_arr[202] = 689; 
assign bias_arr[203] = 402; 
assign bias_arr[204] = 1148; 
assign bias_arr[205] = 565; 
assign bias_arr[206] = 658; 
assign bias_arr[207] = 822; 
assign bias_arr[208] = 1256; 
assign bias_arr[209] = -162; 
assign bias_arr[210] = 1236; 
assign bias_arr[211] = 1193; 
assign bias_arr[212] = 1374; 
assign bias_arr[213] = -141; 
assign bias_arr[214] = 1510; 
assign bias_arr[215] = -570; 
assign bias_arr[216] = 1430; 
assign bias_arr[217] = 743; 
assign bias_arr[218] = 569; 
assign bias_arr[219] = 313; 
assign bias_arr[220] = -39; 
assign bias_arr[221] = 967; 
assign bias_arr[222] = 196; 
assign bias_arr[223] = 1411; 
assign bias_arr[224] = 1218; 
assign bias_arr[225] = 260; 
assign bias_arr[226] = 1368; 
assign bias_arr[227] = -188; 
assign bias_arr[228] = 46; 
assign bias_arr[229] = 973; 
assign bias_arr[230] = 1399; 
assign bias_arr[231] = -2054; 
assign bias_arr[232] = 677; 
assign bias_arr[233] = 551; 
assign bias_arr[234] = 952; 
assign bias_arr[235] = 667; 
assign bias_arr[236] = -232; 
assign bias_arr[237] = 559; 
assign bias_arr[238] = 502; 
assign bias_arr[239] = -336; 
assign bias_arr[240] = 915; 
assign bias_arr[241] = 452; 
assign bias_arr[242] = 498; 
assign bias_arr[243] = 676; 
assign bias_arr[244] = 1135; 
assign bias_arr[245] = 784; 
assign bias_arr[246] = 1713; 
assign bias_arr[247] = -104; 
assign bias_arr[248] = -248; 
assign bias_arr[249] = -852; 
assign bias_arr[250] = 1428; 
assign bias_arr[251] = -269; 
assign bias_arr[252] = 455; 
assign bias_arr[253] = 203; 
assign bias_arr[254] = 1000; 
assign bias_arr[255] = -1242; 



assign  bias_data       =       {bias_arr[1+index*2], bias_arr[index*2]};
assign  bias_last       =       (index == (INDEX_END/2-1)) ? 1'b1 : 1'b0;

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                bias_valid      <=      1'b0;
        else if(index < (INDEX_END/2-1))
                bias_valid      <=      1'b1;
        else
                bias_valid      <=      1'b0;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                index   <=      'd0;
        else if(bias_valid == 1'b1 && ready == 1'b1 && index < (INDEX_END/2))
                index   <=      index + 1'b1;
end


endmodule
