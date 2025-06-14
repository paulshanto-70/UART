module rx_tb;
reg clk=0, baud_tick=0,tx=0, rst;
wire [7:0]out;
wire done;
uart_rx dut(clk ,rst,baud_tick,tx,out,done);
always #1 clk=~clk;
always # 1baud_tick=~baud_tick;



initial begin
rst=1'b1;
#10 rst=0;
tx=1'b0;
#8 tx=1'b1;
#8 tx=1'b0;
#8 tx=1'b1;
#8 tx=1'b0;
#8 tx=1'b1;
#8 tx=1'b0;
#8 tx=1'b1;
#8 tx=1'b0;
end
endmodule