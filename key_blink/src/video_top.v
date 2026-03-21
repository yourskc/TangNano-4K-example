module video_top(
input clk,
input rst_n,
input [1:0]key,
output led_o
);

wire key_output; 

// 1. key + led 
// blink blink_ins ( .clk(clk), .rst_n(rst_n), .key(key), .led_o(led_o) );

// 2. key and led  
key key_ins ( .key(key), .key_output(key_output) );
led led_ins ( .clk(clk), .rst_n(rst_n), .led_start(key_output) , .led_o(led_o));

endmodule 


