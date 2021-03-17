
module regions
(
	input  clock,
	input  resetn,
	input  [31:0]x,
	output reg [1:0] region
);

	reg [1:0] region_, region1;
	always @(x[30:23]) 
	begin
		if (x[30:23] > 129)
			region_ = 2'b01; // Saturation region
		else if (x[30:23] < 123)
			region_ = 2'b10; // Linear region
		else
			region_ = 2'b00; // Hyperbolic region
	end
	
	always @(posedge clock)
	begin
		if (!resetn)
			region <= 2'b11;
		else begin
			region  <= region_;
		end
	end

endmodule

