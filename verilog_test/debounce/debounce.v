`ifndef debounce
`define debounce

module debounce 
#(
    parameter N = 1
)(
    input wire clk,
    input wire rst,
    input wire [N-1:0] key,
    output wire [N-1:0] key_pulse
); 

/*---------------------------------------------------------------------------*/
reg [N-1:0] key_rst; 
reg [N-1:0] key_rst_pre;
wire [N-1:0] key_edge;
/*---------------------------------------------------------------------------*/
reg [17:0] cnt;
/*---------------------------------------------------------------------------*/
reg [N-1:0] key_sec;
reg [N-1:0] key_sec_pre;
/*---------------------------------------------------------------------------*/
always @(posedge clk, negedge rst) begin 
    if (!rst) begin 
        key_rst <= {N{1'b1}};
        key_rst_pre <= {N{1'b1}};
    end else begin 
        key_rst <= key;
        key_rst_pre <= key_rst;
    end 
end 
/*---------------------------------------------------------------------------*/
assign key_edge = key_rst_pre & (~key_rst);
/*---------------------------------------------------------------------------*/
always @(posedge clk, negedge rst) begin 
    if(!rst)          cnt <= 18'h0;
    else if(key_edge) cnt <= 18'h0;
    else              cnt <= cnt + 1'h1;
end 
/*---------------------------------------------------------------------------*/
always @(posedge clk, negedge rst) begin 
    if (!rst)                key_sec <= {N{1'b1}};
    else if (cnt==18'h3ffff) key_sec <= key;
end

always @(posedge clk, negedge rst) begin 
    if (!rst) key_sec_pre <= {N{1'b1}};
    else      key_sec_pre <= key_sec; 
end 
/*---------------------------------------------------------------------------*/
assign key_pulse = key_sec_pre & (~key_sec); 
endmodule
`endif