module tx_tb;
reg clk=0, baud_tick=0,start=0, rst;
reg [7:0]data;
wire tx,done;
uart_tx dut( clk,baud_tick,data,start, rst,tx,done);
always #1 clk=~clk;
always # 2baud_tick=~baud_tick;



initial begin
rst=1'b1;
#10 rst=0;
start=1'b1;data=8'b10101110;
end
endmodule
