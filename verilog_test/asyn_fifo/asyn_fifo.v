`ifndef asyn_fifo
`define asyn_fifo

        module asyn_fifo #(
            parameter ADDR_WIDTH = 13, // 8KB
            parameter DATA_WIDTH = 8
        )(
            input wire clk_wr,
            input wire clk_rd,
            input wire rst,
            input wire en_wr,
            input wire en_rd,
            input wire[DATA_WIDTH-1:0] Din,
            output reg[DATA_WIDTH-1:0] Dout,
            output wire empty,
            output wire full,
            // test
            output reg[ADDR_WIDTH:0] head_bin,
            output reg[ADDR_WIDTH:0] tail_bin,
            output reg[ADDR_WIDTH:0] head_gray,
            output reg[ADDR_WIDTH:0] tail_gray
        );
/*----parameter----*/
parameter DATA_SIZE = 1 << ADDR_WIDTH;

/*----value----*/
reg[DATA_WIDTH-1:0] memory[DATA_SIZE-1:0];

// reg[ADDR_WIDTH:0] head_bin;
// reg[ADDR_WIDTH:0] tail_bin;
// reg[ADDR_WIDTH:0] head_gray;
// reg[ADDR_WIDTH:0] tail_gray;

wire[ADDR_WIDTH-1:0] head_addr;
wire[ADDR_WIDTH-1:0] tail_addr;

/*----assignment----*/
assign head_addr = head_bin[ADDR_WIDTH-1:0];
assign tail_addr = tail_bin[ADDR_WIDTH-1:0];
// TODO: a stable bin is needed to drive gray
assign empty = (head_gray == tail_gray);
/*
bin gray coin_gray
000 000 000
001 001 001
010 011 011
011 010 010
--- --- ---
100 110 100
101 111 101
110 101 111
111 100 110
*/


assign full = (
           (head_gray[ADDR_WIDTH:ADDR_WIDTH-1] == ~tail_gray[ADDR_WIDTH:ADDR_WIDTH-1]) &&
           (head_gray[ADDR_WIDTH-2:0] == tail_gray[ADDR_WIDTH-2:0])
       );

always @(posedge clk_wr, negedge rst) begin
	if(!rst) begin
		tail_bin <= 0;
		tail_gray <= 0;
	end
	else if(en_wr && !full) begin
		memory[tail_addr] <= Din;
		tail_bin <= tail_bin + 1;
		tail_gray <= bin2gray(tail_bin + 1);
	end
	else begin
		tail_bin <= tail_bin;
		tail_gray <= tail_gray;
	end
end

always @(posedge clk_rd, negedge rst) begin
	if(!rst) begin
		Dout <= ~0;
		head_bin <= 0;
		head_gray <= 0;
	end
	else if(en_rd && !empty) begin
		Dout <= memory[head_addr];
		head_bin <= head_bin + 1;
		head_gray <= bin2gray(head_bin + 1);
	end
	else begin
		Dout <= ~0;
		head_bin <= head_bin;
		head_gray <= head_gray;
	end
end

/*----function----*/
function [ADDR_WIDTH:0] bin2gray(input[ADDR_WIDTH:0] bin);
	bin2gray = bin ^ (bin >> 1);
endfunction
endmodule

`endif //`ifndef asyn_fifo
