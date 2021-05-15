module segment (seg_data_1,seg_data_2,seg_led_1,seg_led_2);
input [3:0] seg_data_1; //数码管需显示0~9，故需要4位输入做译码 
input [3:0] seg_data_2; //小脚丫上第二个数码管 
output [8:0] seg_led_1;
output [8:0] seg_led_2;
reg [8:0] seg [9:0];

/*
 __0__     
|     |
5     1      
|__6__|
|     |   
4     2        
|__3__| (7)
*/
initial begin 
    seg[0] = 9'h3f;
    seg[1] = 9'h06; 
    seg[2] = 9'h5b; 
    seg[3] = 9'h4f; 
    seg[4] = 9'h66; 
    seg[5] = 9'h6d; 
    seg[6] = 9'h7d; 
    seg[7] = 9'h07; 
    seg[8] = 9'h7f; 
    seg[9] = 9'h6f;
end
assign seg_led_1 = seg[seg_data_1];
assign seg_led_2 = seg[seg_data_2];
endmodule

/*
seg_data_1(0) J12 seg_data_2(0) J9
seg_data_1(1) H11 seg_data_2(1) K14 
seg_data_1(2) H12 seg_data_2(2) J11
seg_data_1(3) H13 seg_data_2(3) J14
 
seg_led_1(0) E1 seg_led_2(0) A3 
seg_led_1(1) D2 seg_led_2(1) A2 
seg_led_1(2) K2 seg_led_2(2) P2 
seg_led_1(3) J2 seg_led_2(3) P1
seg_led_1(4) G2 seg_led_2(4) N1
seg_led_1(5) F5 seg_led_2(5) C1 
seg_led_1(6) G5 seg_led_2(6) C2 
seg_led_1(7) L1 seg_led_2(7) R2 
seg_led_1(8) E2 seg_led_2(8) B1
*/