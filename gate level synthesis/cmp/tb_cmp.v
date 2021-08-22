`timescale 1ns / 1ns  
module tb_cmp;  
reg clk;  
wire out;  
  
reg [3:0] A;  
reg [3:0] B;  
  
  
cmp_synth c(.clk(clk),  
.A(A),  
.B(B),  
.out(out));  
  
  
	initial begin  
		$dumpfile("tb_cmp.vcd");  
		$dumpvars(0, tb_cmp);    
		clk = 1'b0;  
		  
		A = 4'b1010;  
		B = 4'b1010;  
		  
		#4  
		  
		A = 4'b1001;  
		B = 4'b1010;  
		  
		#4  
		  
		A = 4'b1011;  
		B = 4'b1100;  
		  
		#4  
		  
		A = 4'b1011;  
		B = 4'b1011;  
		  
		#4  
		  
		A = 4'b1100;  
		B = 4'b1010;  
		  
		#4 $finish;  
	  
	end  
  
always #1 clk = ~clk;  
endmodule
