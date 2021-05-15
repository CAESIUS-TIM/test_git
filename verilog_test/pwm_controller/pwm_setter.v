`include "../util/util.v"
module pwm_setter #(
           parameter CNT_NUM = 8,
		   parameter CNT_WIDTH = get_width(CNT_NUM)
       )(
           input wire clk,
           input wire rst,
           input wire [CNT_WIDTH-1:0] cnt2_wire,
           output wire out
       );

function integer get_width(input integer x);
	for(get_width = 0; x > 0; get_width = get_width + 1)
		x = x >> 1;
endfunction

reg [CNT_WIDTH-1:0] cnt1;
reg [CNT_WIDTH-1:0] cnt2;

always@(posedge clk, negedge rst) begin
	if(!rst)
		cnt1 <= {CNT_WIDTH{1'b0}};
	else begin
		if(cnt1 >= CNT_NUM - 1)
			cnt1 <= {CNT_WIDTH{1'b0}};
		else
			cnt1 <= cnt1 + 1'b1;
	end
end

always@(posedge clk, negedge rst) begin
	if(!rst) begin
		cnt2 <= 0;
	end
	else begin
		if(cnt2_wire > CNT_NUM)
			cnt2 <= CNT_NUM;
		else
			cnt2 <= cnt2_wire;
	end
end

assign out = (cnt1 < cnt2) ? 1'b0: 1'b1;
endmodule
