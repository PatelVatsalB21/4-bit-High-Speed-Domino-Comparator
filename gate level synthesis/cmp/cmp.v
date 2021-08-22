module cmp(
	clk,
	A,
	B,
	out
	);

	input clk;
	input [3:0] A;
	input [3:0] B;

	output out;
	reg out;
	
	always @ (clk)
	if(clk)
	begin
		if(A == B)
			out = 1'b0;
		else
			out = 1'b1;
		end
	else
	out = 1'b0;
endmodule