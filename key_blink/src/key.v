module key#(
    parameter clk_frequency = 27_000_000 
)(
    input                   clk , // Clock in
    input                   rst_n,
    input  [1:0]            key,
    output reg key_output
); 

parameter count_ms = clk_frequency / 1000 ;

parameter count_20ms = count_ms * 20 -1 ;

reg [($clog2(count_20ms)-1)+10:0] count_20ms_reg;

reg led = 1'b1;
reg [5:0] led_flash_cnt = 6'd0;

// key flag

// reg key_input ;
reg [1:0] key_input2 = 2'd3;

always @(posedge clk) begin
    key_output <= (~key[0])|(~key[1])  ;
end


reg key_flag = 1'b0;


// LED Toggle
always @(posedge clk or negedge rst_n) begin
     if(!rst_n) begin
        led <= 1'd1;
        count_20ms_reg <= 'd0;
     end
    else begin

// 偵測 按鍵
if(~key[0]|~key[1])
        count_20ms_reg <= count_20ms_reg + 'd1 ;
    else if(count_20ms_reg >= count_20ms) begin
            key_flag <= 'd1;
            count_20ms_reg <= 'd0;
    end
    else
        count_20ms_reg <= 'd0;

 end // rst_n

end


endmodule