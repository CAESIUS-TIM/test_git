`ifndef main_trans
`define main_trans

`include "../debounce/debounce.v"
`include "trans.v"

module main_trans
       #(
           parameter N = 4
       )
       (
           input wire clk,
           input wire rst,
           input wire [N-1:0] key,
           output wire [N-1:0] led
       );

wire [N-1:0] key_pulse;

debounce #(
             N
         )u_debounce(
             clk,rst,key,key_pulse
         );

genvar genvar_i;
generate
    for(genvar_i = 0; genvar_i < N; genvar_i = genvar_i + 1) begin: namespace_trans
        trans u_trans(key_pulse[genvar_i],rst,led[N - genvar_i - 1]);
    end
endgenerate

endmodule
`endif