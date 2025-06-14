module uart_tb;
 reg clk=0,reset=0,start=0;
  reg [31:0] divisor;
 reg[7:0]data;
  wire [7:0]out;
  wire done;
  
 uart_top dut(clk,reset,start,divisor,data,out,done);
 
 always #5clk=~clk;
 
initial begin
reset=1'b1;
#10 reset=1'b0;
divisor=10'd651;start=1'b1;data=8'b01010101;
end

endmodule