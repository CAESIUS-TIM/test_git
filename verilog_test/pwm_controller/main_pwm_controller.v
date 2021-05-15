`include "../debounce/debounce.v"
`include "../pwm_controller/pwm_controller.v"
module main_pwm_controller
       (
           input wire clk,
           input wire rst,
           input wire key_up,
           input wire key_down,
           output wire led,
           output wire out
       );

wire key_up_pulse;
wire key_down_pulse;
wire clk_n;
assign clk_n = ~clk;
assign out = led;

debounce u_debounce_up(
             clk,
             rst,
             key_up,
             key_up_pulse
         );

debounce u_debounce_down(
             clk,
             rst,
             key_down,
             key_down_pulse
         );

pwm_contoller u_pwm_contoller(
                clk_n,
                rst,
                key_up_pulse,
                key_down_pulse,
                led
            );

endmodule
