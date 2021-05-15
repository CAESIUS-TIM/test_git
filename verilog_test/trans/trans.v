`ifndef trans
`define trans
module trans(
           input wire key,
           input wire rst,
           output reg led
       );

always @(posedge key, negedge rst)
    if (!rst)
        led <= 1;
    else if(key)
        led <= ~led;
    else
        led <= led;
endmodule
`endif