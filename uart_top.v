module uart_top(
  input clk,
  input reset,
  input start,
  input [31:0] divisor,
  input [7:0]data,
  output [7:0]out,
  output done
);
wire baud_tick;
wire tx;
//  reg START,ARESET;
//  wire rx_or_tx;
  // module instantiations

  baudrate_generator bg ( .clk(clk), .start(start), .divisor(divisor), .areset(reset), .out(baud_tick) );
  uart_tx ut(clk ,baud_tick,data,start,reset,tx);
  uart_rx ur(clk ,reset,baud_tick,tx,out,done);
  
  
  
  
endmodule
             
