
module linear_out
(
	input  clock,
	input  resetn,
	input [1:0] region,
	input  [31:0] x,
	output reg [31:0] y
);
	
	always @(posedge clock) begin
		if (!resetn)
			y <= 32'h00000000;
		else begin
			// Biggest saturation region
			if ((region == 2'b01) && (x[31] == 1'b0))
				y <= 32'h3F800000; // 1
			// Samallest saturation region
			else if ((region == 2'b01) && (x[31] == 1'b1))
				y <= 32'hBF800000; // -1
			// Linear region
			else if (region == 2'b10)
				y <= x;
			// Hyperbolic region: here drives the core module
			else
				y <= 32'h00000000; // 0
		end
	end
		
endmodule

