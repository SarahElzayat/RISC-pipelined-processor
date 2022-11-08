module Register #(parameter size = 8)(D,clk,Q);
input [size-1:0] D; 
input clk; 
output reg [size-1:0] Q;
always @(posedge clk) 
begin
 Q <= D; 
end 
endmodule 
