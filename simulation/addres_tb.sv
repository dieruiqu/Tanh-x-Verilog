
module address_tb;

	// CLK scale units
	timeunit 1ns;

	integer f_bits = 18;
	integer delay = 11;
	real max_value = 7.99;

	reg clock;
	reg resetn;
	real x;
	reg signed[31:0] y;
	reg mode;

	real value_w, gold, fpga, error, mse;
	integer seed;

	enum integer
	{
		Tanh=1,
		Sigmoid=0
	} modes;

	// Init declaration of signals
	initial begin
		clock  = 1;
		resetn = 0;
		#40;
		resetn = 1;
		mode  = 1;
	        modes = Tanh;
		// x = -max_value;
		x = -max_value;
	end

	// CLK declaration always 5 ns
	always 
		#5 clock =! clock;

	
	// Task to set values from -5 to 5 with 
	// 16 fractional bits
	task set_values; 
	begin
		
		if(x >= max_value)
		begin
			x = -max_value;
			// mode = mode + 1;
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
		// fpga <= $itor(y) / (2**18);
		fpga <= $bitstoshortreal(y);
		error <= fpga - gold;
		value_w <= repeat(delay) @(posedge clock) x;
		modes <= repeat(delay) @(posedge clock) modes;

		if (mode == 1)
			gold <= repeat(delay) @(posedge clock) $tanh(x);
		else if (mode == 0)
			gold <= repeat(delay) @(posedge clock) 1 / (1 + $exp(-x));
			// gold <= repeat(delay) @(posedge clock) (x/2+1) / 2;
		else if (mode == 2)
			gold <= repeat(delay) @(posedge clock) $exp(x);
		/*
		assertion1 : assert (abs_error < 50e-4)
			else $display("Absolute Error > 50e-6: %e", abs_error);
		*/
	end
	

	// Always a positive edge of clock, the X
	// value is update
	always @(posedge clock)
	begin
		// FPGA <= $itor(Y) / (2**f_bits);
		// error = (gold - FPGA);
		// abs_error = (error <= 0) ? -error : error;
		if (mode == 1)
			modes = Tanh;
		else if (mode == 0)
			modes = Sigmoid;

		if (resetn == 0) begin
			x = 0.0;
		end	else begin
			set_values();
		end
	end

	core core_
	(
		.clock  (clock),
		.resetn (resetn),
		.x ($shortrealtobits(x)),
		.y (y)
	);

endmodule