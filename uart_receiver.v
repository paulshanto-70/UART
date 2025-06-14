module uart_rx(
  input clk,                  // System clock
  input rst,               // Active-high async reset
  input baud_tick,            // Tick from baud generator
  input rx,                   // Incoming serial data
  output [7:0] out_data,      // Received parallel data
  output  done             // High when frame reception is done
);

parameter IDLE=2'b00;
parameter START=2'b01;
parameter DATA=2'b10;
parameter STOP=2'b11;

reg [7:0]sipo;
integer baud_counter=0;
integer data_counter=0;
reg[1:0]ps,ns;
wire baud_counterw;
wire a;
always @(posedge clk) begin
if(rst)
ps<=IDLE;
else 
ps<=ns; 
end

always@(*) begin
case(ps)
IDLE: ns<=~rx?START:IDLE;
START:ns<=(baud_counter==3'd7)?DATA:START;
DATA:ns<=(data_counter == 4'd7 && baud_counterw) ? STOP : DATA;
STOP:ns<=(baud_counterw) ? IDLE : STOP;
default:ns<=IDLE;
endcase
end

always@(posedge clk) begin
if(rst)
baud_counter=0;
else if(baud_counter==4'd15)
baud_counter=0;
else if(ps==IDLE)
baud_counter=0;
else if(ps==START && baud_counter==3'd7)
baud_counter=0;
else if(baud_tick)
baud_counter=baud_counter+1'd1;
end

 always @(posedge clk)
    begin
      if (rst)
        sipo <= 8'd0;
      else if (a)
        sipo <= {rx,sipo[7:1]};
      else if (ps == STOP)
        sipo <= sipo;
      else if (ps == IDLE)
        sipo <= 8'd1;
      else 
        sipo <= sipo;
    end

always @(posedge clk)
    begin
      if (rst)
        data_counter = 4'd0;
      else if (data_counter == 4'd7 & a)
        data_counter  = 4'd0;
      else if ((ps == DATA) & baud_counterw)
        data_counter = data_counter + 'd1;
      else
        data_counter = data_counter;
    end 
    always@(posedge clk)begin
    if(done)
    $strobe("output=%b",out_data);
    end



assign  a = (ps == DATA & baud_counterw);
assign done = (ps == STOP);
assign out_data = (sipo & {8{(ps == STOP)}});
assign baud_counterw=(baud_counter == 4'd15);

endmodule
