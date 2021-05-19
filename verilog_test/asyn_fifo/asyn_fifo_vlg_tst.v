`include "./asyn_fifo.v"

`define clk_cycle_wr 20
`define clk_cycle_rd 50

module asyn_fifo_vlg_tst;

/*----parameter----*/
parameter ADDR_WIDTH = 4;
parameter DATA_WIDTH = 8;

/*----value----*/
reg clk_wr;
reg clk_rd;
reg rst;
reg en_wr;
reg en_rd;
reg[DATA_WIDTH-1:0] Din;
wire[DATA_WIDTH-1:0] Dout;
wire empty;
wire full;

wire[ADDR_WIDTH:0] head_bin;
wire[ADDR_WIDTH:0] tail_bin;
wire[ADDR_WIDTH:0] head_gray;
wire[ADDR_WIDTH:0] tail_gray;

reg[ADDR_WIDTH:0] i;

/*----module----*/
asyn_fifo #(
              .ADDR_WIDTH(ADDR_WIDTH), // 8KB
              .DATA_WIDTH(DATA_WIDTH)
          ) uut (
              .clk_wr(clk_wr),
              .clk_rd(clk_rd),
              .rst(rst),
              .en_wr(en_wr),
              .en_rd(en_rd),
              .Din(Din),
              .Dout(Dout),
              .empty(empty),
              .full(full),
              // test
              .head_bin(head_bin),
              .tail_bin(tail_bin),
              .head_gray(head_gray),
              .tail_gray(tail_gray)
          );

/*----assignment----*/
always #`clk_cycle_wr clk_wr = ~clk_wr;
always #`clk_cycle_rd clk_rd = ~clk_rd;

initial begin
	$stop; // add wave 
end

initial begin
	clk_wr = 0;
	clk_rd = 0;
	rst = 1;
	en_wr = 0;
	en_rd = 0;
	Din = 0;
	#`clk_cycle_wr rst = 0;
	#`clk_cycle_wr rst = 1;

	/*----clear----*/
	$display("State: clearing memory...");
	@(negedge clk_wr)
	 en_wr = 1;
	i = 0;
	@(posedge clk_wr);
	while(!full) begin // memory置零
		@(negedge clk_wr)
		 i = i + 1;
		if(i > (1 << ADDR_WIDTH)) begin // full功能测试
			$display("Error: full is not work well.");
			$stop;
		end
		@(posedge clk_wr);
	end
	if(i != (1 << ADDR_WIDTH)) begin // full功能测试
		$display("Error: full is not work well.");
		$stop;
	end
	en_wr = 0;

	$display("State: memory is cleared, and then check clearing memory is cleared successfully");
	@(negedge clk_rd)
	 en_rd = 1;
	i = 0;
	@(posedge clk_rd);
	while(!empty) begin // memory置零
		@(negedge clk_wr)
		 i = i + 1;
		if(i > (1 << ADDR_WIDTH)) begin // empty功能测试
			$display("Error: empty is not work well.");
			$stop;
		end
		if(Dout != 0) begin
			$display("Error: memory is not cleared successfully.");
			$stop;
		end
		@(posedge clk_rd);
	end
	if(i != (1 << ADDR_WIDTH)) begin // empty功能测试
		$display("Error: empty is not work well.");
		$stop;
	end
	en_rd = 0;

	/*----set----*/
	Din = ~0;
	$display("State: setting memory...");
	@(negedge clk_wr);
	en_wr = 1;
	i = 0;
	@(posedge clk_wr);
	while(!full) begin // memory置零
		@(negedge clk_wr);
		i = i + 1;
		if(i > (1 << ADDR_WIDTH)) begin // full功能测试
			$display("Error: full is not work well.");
			$stop;
		end
		@(posedge clk_wr);
	end
	if(i != (1 << ADDR_WIDTH)) begin // full功能测试
		$display("Error: full is not work well.");
		$stop;
	end
	en_wr = 0;

	$display("State: memory is setted, and then check setting memory is setted successfully");
	@(negedge clk_rd);
	en_rd = 1;
	i = 0;
	@(posedge clk_rd);
	while(!empty) begin // memory置零
		@(negedge clk_wr);
		i = i + 1;
		if(i > (1 << ADDR_WIDTH)) begin // empty功能测试
			$display("Error: empty is not work well.");
			$stop;
		end
		if(Dout != {DATA_WIDTH{1'b1}}) begin
			$display("Error: memory is not setted successfully.");
			$stop;
		end
		@(posedge clk_rd);
	end
	if(i != (1 << ADDR_WIDTH)) begin // empty功能测试
		$display("Error: empty is not work well.");
		$stop;
	end
	en_rd = 0;

    $stop;
end

endmodule

