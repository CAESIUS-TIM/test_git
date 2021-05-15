`include "../util/util.v"
module pwm_contoller #(
           parameter CNT_NUM = 8
       )(
           input wire clk,
           input wire rst,
           input wire key_up,
           input wire key_down,
           output wire out
       );

parameter CNT_WIDTH = util.get_width(CNT_NUM);
reg [CNT_WIDTH-1:0] cnt1;
reg [CNT_WIDTH-1:0] cnt2;

always@(posedge clk, negedge rst) begin
    if(!rst)
        cnt1 <= {CNT_WIDTH{1'b0}};
    else begin
        if(cnt1 >= CNT_NUM - 1)
            cnt1 <= {CNT_WIDTH{1'b0}};
        else
            cnt1 <= cnt1 + 1'b1;
    end
end

always@(posedge clk, negedge rst) begin
    if(!rst)
        cnt2 <= CNT_NUM/2;
    else if(key_up) begin
        if(cnt2 < CNT_NUM)
            cnt2 <= cnt2 + 1'b1;
        else
            cnt2 <= cnt2;
    end
    else if(key_down) begin
        if(cnt2 > 0)
            cnt2 <= cnt2 - 1'b1;
        else
            cnt2 <= cnt2;
    end
    else
        cnt2 <= cnt2;
end

assign out = (cnt1 < cnt2) ? 1'b0: 1'b1;
endmodule
