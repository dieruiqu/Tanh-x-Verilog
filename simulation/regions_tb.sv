

module regions_tb;

	// CLK scale units
	timeunit 1ns;

	integer delay = 2;
	real max_value = 0.0625;

	reg clock;
	reg resetn;
	real x;
	reg signed[31:0] y;
	reg [1:0] region;

	real value_w, gold, fpga;
	integer seed;

	enum integer
	{
		Hyperbolic=0,
		Saturation=1,
		Linear=2
	} regions;

	// Init declaration of signals
	initial begin
		clock  = 1;
		resetn = 0;
		#40;
		resetn = 1;
		x = -max_value;
	end

	// CLK declaration always 5 ns
	always 
		#5 clock =! clock;

	task set_values; 
	begin
		
		if(x >= max_value)
		begin
			x = -max_value;
		end
		else begin
			x = x + 1e-3;
		end
		
		/*
		seed = $random;
		x = $itor($dist_normal(seed, 0*(2**f_bits), 2*(2**f_bits))) / (2**(f_bits+0));
		// mode = $urandom_range(1,0);
		mode = 1;
		*/
		
	end
	endtask
	
	
	always @(x)
	begin
		value_w <= repeat(delay) @(posedge clock) x;
		gold <= repeat(delay) @(posedge clock) $tanh(x);
		regions <= repeat(delay) @(posedge clock) regions;
		fpga <= $bitstoshortreal(y);
	end
	

	// Always a positive edge of clock, the X
	// value is update
	always @(posedge clock)
	begin
		if (region == 0)
			regions = Hyperbolic;
		else if (region == 1)
			regions = Saturation;
		if (region == 2)
			regions = Linear;

		if (resetn == 0) begin
			x = 0.0;
		end	else begin
			set_values();
		end
	end

	regions regions_
	(
		.clock  (clock),
		.resetn (resetn),
		.x ($shortrealtobits(x)),
		.region (region)
	);

	linear_out linear_out_
	(
		.clock  (clock),
		.resetn (resetn),
		.region (region),
		.x ($shortrealtobits(x)),
		.y (y)
	);

endmodule