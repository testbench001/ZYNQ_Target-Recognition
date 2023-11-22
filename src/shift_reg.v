module  shift_reg #(
        parameter       DLY_CNT =       'd8             
)(
        input                   sclk                    ,       
        input                   data_in                 ,       
        output  wire            data_out                       
);

reg     [DLY_CNT-1:0]           data_arr                        ;       

always  @(posedge sclk) begin
        data_arr        <=      {data_arr[DLY_CNT-2:0], data_in};
end

assign  data_out        =       data_arr[DLY_CNT-1];

endmodule
