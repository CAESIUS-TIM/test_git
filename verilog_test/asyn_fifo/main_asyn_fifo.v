`include "../debounce/debounce.v"
`include "../segment/segment.v"
`include "../divider/divider.v"
`define EN_WR 0
`define EN_RD 1
module main_asyn_fifo#(
           parameter ADDR_WIDTH = 3, // 8KB
           parameter DATA_WIDTH = 8
       )(
           // extend
           input wire clk,
           input wire k1,
           input wire k2,
           input wire k3,
           input wire k4,

           output wire [8:0]seg_led_1,
           output wire [8:0]seg_led_2,

           output wire r1,
           output wire g1,
           output wire b1,
           output wire r2,
           output wire g2,
           output wire b2,

           output [7:0] led
       );

/*----parameter----*/
parameter CNT_OSC = 12_000_000;

/*----value----*/
wire clk_wr;
wire clk_rd;
wire rst;
wire en_wr;
wire en_rd;

reg[DATA_WIDTH-1:0] Din;
reg[DATA_WIDTH-1:0] Dout;
wire[DATA_WIDTH-1:0] Dout_wire;

wire empty;
wire full;

wire[ADDR_WIDTH:0] head_bin;
wire[ADDR_WIDTH:0] tail_bin;

reg[2:0] i;

wire [3:0]seg_data_1;
wire [3:0]seg_data_2;

reg mode;
reg en;
reg k2_undone;

wire k2_pulse;
wire w1;
wire w0;

wire clk_300ms;
reg en_clk_300ms;
reg clk_300ms_rst_pre;
reg clk_300ms_rst;
/*----module----*/
asyn_fifo #(
              .ADDR_WIDTH(ADDR_WIDTH), // 8KB
              .DATA_WIDTH(DATA_WIDTH)
          ) u_asyn_fifo (
              .clk_wr(clk_wr),
              .clk_rd(clk_rd),
              .rst(rst),
              .en_wr(en_wr),
              .en_rd(en_rd),
              .Din(Din),
              .Dout(Dout_wire),
              .empty(empty),
              .full(full),
              // test
              .head_bin(head_bin),
              .tail_bin(tail_bin)
              // .head_gray(head_gray),
              // .tail_gray(tail_gray)
          );

segment u_segment(
            .seg_data_1(seg_data_1),
            .seg_data_2(seg_data_2),
            .seg_led_1(seg_led_1[6:0]),
            .seg_led_2(seg_led_2[6:0])
        );

debounce #(
             .N(3)
         )u_debounce(
             .clk(clk),
             .rst(rst),
             .key({k2,k3,k4}),
             .key_pulse({k2_pulse,w1,w0})
         );

divider #(
            .N(CNT_OSC / 10 * 3)
        )u_divider(
            .clk_in(clk),
            .rst_n(en_clk_300ms),
            .clk_out(clk_300ms)
        );
/*----assignment----*/
assign rst = k1;

assign en_wr = (mode == `EN_WR);
assign en_rd = (mode == `EN_RD);

assign clk_wr = (mode == `EN_WR) ? en : 0;
assign clk_rd = (mode == `EN_RD) ? en : 0;

assign seg_data_1 = tail_bin[ADDR_WIDTH-1:0];
assign seg_data_2 = (mode == `EN_WR) ? i : head_bin[ADDR_WIDTH-1:0];
assign seg_led_1[8] = 0;
assign seg_led_2[8] = 0;
assign seg_led_1[7] = tail_bin[ADDR_WIDTH];
assign seg_led_2[7] = (mode == `EN_WR) ? 0 : head_bin[ADDR_WIDTH] ;

/* negative logic */
assign r2 = !full;
assign g2 = full || empty;
assign b2 = !empty;

assign r1 = (mode == `EN_WR) ? 0 : 1;
assign g1 = (mode == `EN_WR) ? 0 : 1;
assign b1 = (mode == `EN_WR) ? 0 : 1;

assign led = ~((mode == `EN_RD) ? Dout : Din);

assign clk_300ms_neg = clk_300ms_rst_pre && !clk_300ms_rst;

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		clk_300ms_rst_pre <= 0;
		clk_300ms_rst <= 0;
	end
	else begin
		clk_300ms_rst_pre <= clk_300ms_rst;
		clk_300ms_rst <= clk_300ms;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		en <= 0;
		mode <= 0;
        k2_undone <= 1;
		en_clk_300ms <= 0;
	end
	else if(k2_pulse && !en_clk_300ms) begin
        k2_undone <= 1;
		en_clk_300ms <= 1;
	end
	else if(k2_pulse && en_clk_300ms) begin
		mode = mode ^ k2_undone;
        k2_undone <= 0;
        en_clk_300ms <= 0;
	end
	else if(clk_300ms_neg) begin
		en_clk_300ms <= 0;
		en <= k2_undone;
	end
	else begin
		en <= 0;
	end
end



always @(negedge clk, negedge rst) begin
	if(!rst) begin
		i <= 0;
		Din <= 0;
	end
	else if(w1 && (mode == `EN_WR)) begin
		i <= i + 1;
		Din[i] <= 1;
	end
	else if(w0 && (mode == `EN_WR)) begin
		i <= i + 1;
		Din[i] <= 0;
	end
	else begin
		i <= i;
		Din[i] <= Din[i];
	end

end

always @(negedge en,negedge rst) begin
	if(!rst) begin
		Dout <= 0;
	end
	else if(mode == `EN_RD) begin
		Dout <= Dout_wire;
	end
	else begin
		Dout <= Dout;
	end
end

endmodule
