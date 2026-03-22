// -----------------------------------------------------------------------------
// Module : video_top
// Description:
//   Top-level control for LED blink behavior on TangNano-4K.
//   - ~key[0]: triggers LED to flash 1 time
//   - ~key[1]: triggers LED to flash 3 times
//   - Automatic: LED flashes 1 time every 10 seconds, independent of key input
// -----------------------------------------------------------------------------
module video_top(
input clk,
input rst_n,
input [1:0]key,
output led_o
);

wire led_start;
// if ~key[0], led flashes 1 time; if ~key[1], led flashes 3 times
wire [5:0] key_flash_count = ~key[0] ? 6'd1 : (~key[1] ? 6'd3 : 6'd0);
wire [5:0] flash_count;

localparam clk_frequency = 27_000_000;
localparam auto_flash_ticks = clk_frequency * 10;
reg [$clog2(auto_flash_ticks)-1:0] auto_flash_cnt;
reg auto_led_start;

assign led_start = ~key[0] | ~key[1] | auto_led_start;
assign flash_count = (~key[0] | ~key[1]) ? key_flash_count : (auto_led_start ? 6'd1 : 6'd0);

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		auto_flash_cnt <= 'd0;
		auto_led_start <= 1'b0;
	end
	else if (auto_flash_cnt < auto_flash_ticks - 1) begin
		auto_flash_cnt <= auto_flash_cnt + 'd1;
		auto_led_start <= 1'b0;
	end
	else begin
		auto_flash_cnt <= 'd0;
		auto_led_start <= 1'b1;
	end
end

// 1. key + led 
// blink blink_ins ( .clk(clk), .rst_n(rst_n), .key(key), .led_o(led_o) );

// 2. key and led  
led led_ins ( .clk(clk), .rst_n(rst_n), .led_start(led_start), .flash_count(flash_count), .led_o(led_o));

endmodule 


