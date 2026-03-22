module led#(
    parameter clk_frequency = 27_000_000
)(
    input                   clk , 
    input                   rst_n,
    input                led_start,
    input        [5:0]   flash_count, // number of times LED blinks per trigger
    output      led_o
);

parameter count_ms = clk_frequency / 1000 ;
parameter count_100ms = count_ms * 100 -1 ;

reg [$clog2(count_100ms)-1:0] count_100ms_reg;

reg led = 1'b1;
reg [5:0] led_flash_cnt = 6'd0;

// LED Toggle
always @(posedge clk or negedge rst_n) begin
     if(!rst_n) begin
        led <= 1'd1;
        count_100ms_reg <= 'd0 ;
        led_flash_cnt <= 6'd0;
     end
    else begin
        if (led_start)
            led_flash_cnt <= flash_count;

        if(count_100ms_reg < count_100ms)
            count_100ms_reg <= count_100ms_reg+'d1;
        else begin
            count_100ms_reg <= 'd0 ;

            if (~led) begin // 1->0 dark->light 
                if(led_flash_cnt) begin
                    led_flash_cnt <= led_flash_cnt - 'd1;
                    led <= 1'd1 ;
                end 
                else  // 0->1 light->dark 
                    led <= 1'd0 ;
            end
            else
                led <= 1'd0 ;
        end

 end // rst_n

end

assign led_o = led ;

endmodule