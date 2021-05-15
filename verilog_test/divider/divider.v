`include "../util/util.v"
module divider #(
           parameter N = 5
       )
       (
           input wire clk_in,
           input wire rst_n,
           output wire clk_out
       );

parameter WIDTH = util.get_width(N);

reg clk_p, clk_n;
reg  [WIDTH-1:0] cnt_p, cnt_n;

always @(posedge clk_in, negedge rst_n) begin
	if(!rst_n)
		cnt_p <= 0;
	else if(cnt_p == (N-1))
		cnt_p <= 0;
	else
		cnt_p <= cnt_p + 1;
end

always @(posedge clk_in) begin
	if(!rst_n)
		clk_p <= 0;
	else if(cnt_p < (N>>1))
		clk_p <= 0;
	else
		clk_p <= 1;
end

always @(negedge clk_in, negedge rst_n) begin
	if(!rst_n)
		cnt_n <= 0;
	else if(cnt_n == (N-1))
		cnt_n <= 0;
	else
		cnt_n <= cnt_n + 1;
end

always @(negedge clk_in) begin
	if(!rst_n)
		clk_n <= 0;
	else if(cnt_n < (N>>1))
		clk_n <= 0;
	else
		clk_n <= 1;
end

assign clk_out = (N == 1) ? clk_in: (N[0]) ? (clk_p & clk_n) : clk_p;

endmodule
