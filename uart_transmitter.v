module uart_tx(
input clk,
input baud_tick,
input [7:0]data,
input start,
input rst,
output tx
);
reg [7:0]piso;
integer baud_counter=0;
integer data_counter=0;
parameter IDLE=2'b00;
parameter START=2'b01;
parameter DATA=2'b10;
parameter STOP=2'b11;
reg[1:0]ps,ns;
wire baud_counterw;

always @(posedge clk) begin
if(rst)
ps<=IDLE;
else if(baud_counter==5'd15)
ps<=ns;
else
ps<=ps;
end

always@(*) begin
case(ps)
IDLE: ns<=start?START:IDLE;
START:ns<=DATA;
DATA:ns<=(data_counter==4'd8)?STOP:DATA;
STOP:ns<=IDLE;
default:ns<=IDLE;
endcase
end

always@(posedge clk) begin
if(rst)
baud_counter=0;
else if(baud_counter==4'd15)
baud_counter=0;
else if(baud_tick)
baud_counter=baud_counter+1'd1;
end

always@(posedge clk) begin
if(rst)
data_counter=0;
else if(data_counter==4'd8)
data_counter=0;
else if(ps==DATA & baud_counterw)
data_counter=data_counter+1'd1;
else
data_counter=data_counter;
end 

always@(posedge clk) begin
if(rst)
piso<=8'd1;
else if(ns==START && baud_counterw)
piso<=data;
else if(ps==DATA && baud_counterw)
piso<={1'd1,piso[7:1]};
else
piso<=piso;
end

assign baud_counterw=(baud_counter==4'd15);
assign tx=(ps==START)?0:(ps==DATA)?piso[0]:1'b1;
endmodule
