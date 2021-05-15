`include "../debounce/debounce.v"
`include "../segment/segment.v"
`define EN_WR 0
`define EN_RD 1
module main_asyn_fifo#(
           parameter ADDR_WIDTH = 3, // 8KB
           parameter DATA_WIDTH = 8
       )(
           // extend
           input wire clk,
           input wire sw1,
           input wire k1,
           input wire k2,
           input wire k3,
           input wire k4,

           output wire [8:0]seg_led_1,
           output wire [8:0]seg_led_2,

           output wire g1,
           output wire r1,
           output wire g2,
           output wire r2,

           output [7:0] led
       );

/*----parameter----*/

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


wire en;
wire w1;
wire w0;

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
              .tail_bin(tail_bin),
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
             .key_pulse({en,w1,w0})
         );

/*----assignment----*/
assign rst = k1;

assign en_wr = (sw1 == `EN_WR);
assign en_rd = (sw1 == `EN_RD);

assign clk_wr = (sw1 == `EN_WR) ? en : 0;
assign clk_rd = (sw1 == `EN_RD) ? en : 0;

assign seg_data_1 = tail_bin[ADDR_WIDTH-1:0];
assign seg_data_2 = (sw1 == `EN_WR) ? i : head_bin[ADDR_WIDTH-1:0];
assign seg_led_1[8] = 0;
assign seg_led_2[8] = 0;
assign seg_led_1[7] = tail_bin[ADDR_WIDTH];
assign seg_led_2[7] = (sw1 == `EN_WR) ? 0 : head_bin[ADDR_WIDTH] ;

/* negative logic */
assign g1 = empty;
assign r1 = !empty;

assign g2 = full;
assign r2 = !full;

assign led = ~((sw1 == `EN_RD) ? Dout : Din);

always @(negedge clk, negedge rst) begin
	if(!rst) begin
		i <= 0;
		Din <= 0;
	end
	else if(w1 && (sw1 == `EN_WR)) begin
		i <= i + 1;
		Din[i] <= 1;
	end
	else if(w0 && (sw1 == `EN_WR)) begin
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
	else if(sw1 == `EN_RD) begin
		Dout <= Dout_wire;
	end
	else begin
		Dout <= Dout;
	end
end

endmodule
