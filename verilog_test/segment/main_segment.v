`include "../divider/divider.v"

module main_segment #(
           parameter SEG_MAX_1 = 9;
           parameter SEG_MAX_2 = 9;
       ) (
           input wire clk,
           input wire rst,
           output wire [8:0] seg_led_1,
           output wire [8:0] seg_led_2
       );

wire clk_out;
reg [3:0] seg_data_1;
reg [3:0] seg_data_2;

divider #(
            6_000_000
        ) u_divider (
            clk,
            rst,
            clk_out
        );

segment u_segment (
            seg_data_1,
            seg_data_2,
            seg_led_1,
            seg_led_2
        );

always @(posedge clk_out, negedge rst) begin
	if(!rst) begin
		seg_data_1 <= 0;
		seg_data_2 <= 0;
	end
	else begin
		seg_data_2 = seg_data_2 + 1;
		if(seg_data_2 == 'd10) begin
			seg_data_2 <= 0;
			if(seg_data_1 == 'd9)
				seg_data_1 <= 0;
			else
				seg_data_1 <= seg_data_1 + 1;
		end
        if((seg_data_1 == SEG_MAX_1) && (seg_data_2 == SEG_MAX_2)) begin
            seg_data_1 <= 0;
		    seg_data_2 <= 0;
        end
	end
end

endmodule
