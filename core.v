
/****************************************************************

 - Author :     RUIZ QUINTANA, Diego
 - Module :     Core
 - Description: This module performs the hyperbolic 
	tangent for AI purposes. It has a latency of 11
	clock cycles and a Slow Fmax of 160 MHz and a 
	fast fmax of 315 MHz. The number of ALM's are 210
	and a total of 289 registers. The input is in 
	IEEE-754 standard, the intermediate calculus are
	performed in S13.18 Q format in fixed point and 
	output is in the IEEE-754 standard of 32 bits.
	
	The used method to calculate the Tanh(x) is via
	table interpolation doing use of 2 ROMS of 1024
	addresses, one of them with a length word of 19
	bits and the other with only 12 bits of length word.

	The tricky here is resolve the address of table 
	interpolator ROM with the SMB's of the IEEE-754 input 
	mantissa, avoiding in this way the hardware necessary 
	to swap between IEEE-754 and fixed point, but 
	the values in ROM are stored in Fixed Point.
	
	One of the advantages of this arch. is the possibility 
	of adding new math functions, using the same interpolator
	and address resolver. In this way can be implemented 
	the sigmoid function or the exp function, at the expense of
	only a little more logic (multipliers and adders).
	
	One particularity of the Tanh(x) function is the 3 regions in it:
	Saturation, Hyperbolic and lineal. Taking in count this, the input values
	greaters or equals than 8 are in the saturation region, it is to say that
	the output from the function will be 1. Values in range from 0 to
	1/32 are in the lineal region, therefore Tanh(x) = x and finally is
	the hyperbolic region defined between 1/32 <= x < 8 --> This module
	implements the calculus in the hyperbolic region. Because of the Tanh(x) 
	function is a impar function, then: Tanh(-x) = -Tanh(x), so the regions
	mentioned are aplicables in the negative range of input values.
	
	The linear and saturation region they don't need be calculated via interpolation,
	in this way the hardware resources are also relaxed. Modules "regions"
	and "linear_out" implement the saturation and linear regions of Tanh(x).
	
****************************************************************/

module core
(
	input clock,
	input resetn,
	input [31:0] x,
	output reg [31:0] y
);	
	wire [7:0]  shift;
	wire [17:0] adder;
   wire [18:0] multp;
	
	wire [9:0] address;
	wire [18:0] data_a;
	wire [11:0] data_b;
	wire [10:0] diff;
	wire [3:0]  msb;
	
	wire unsigned [30:0] interpolation;
	wire unsigned [31:0] result;
	wire unsigned [31:0] result_fp32;
	
	wire unsigned [31:0] x_reg;
	wire unsigned [9:0] address_reg;
	wire unsigned [3:0]  msb_reg;
	
	wire unsigned sign_reg5, sign_reg11;
	
	// Se retrasan las señales el numero de cilos necesarios para 
	// mantener el sincronismo dentro de la arquitectura pipelined
	pipe_signals _pipe_signals(clock, resetn,
										x, address, msb,
										sign_reg5, sign_reg11,
										x_reg, address_reg, msb_reg);
	
	// Se setean las primeras variables y se resuelven las direcciones
	address_resolver _address_resolver (x, address, msb);
	
	// Se cogen los valores de las ROMs
	ROM1 _ROM1(address, clock, data_a);
	ROM2 _ROM2(address, clock, data_b);
	
	// Se interpola y ajusta el resultado a la funcion deseada
	interpolator _interpolator(clock, x_reg, msb_reg, address_reg[9:0], data_a, data_b, interpolation);
	
	// Se convierte a IEEE-754 el resultado generado
	fixed32_to_fp32 _fixed32_to_fp32 (clock, resetn, {1'b0, interpolation}, result_fp32);
	
	always @(posedge clock)
		if (resetn == 1'b0) begin
			y <= 0;
		end else begin
			y <= {sign_reg11, result_fp32[30:0]};
		end

endmodule

// Interpolator that works in fixed point
module interpolator
(
	input clock,
	input  [31:0] x,
	input  [3:0]  msb,
	input  [9:0]  address,
	input  [18:0] data_a,
	input  [11:0] data_b,
	output [30:0] interpolation
);

	wire signed   [23:0] d1;
	wire unsigned [20:0] d2;
	wire unsigned [11:0] diff_1;
	wire unsigned [20:0] diff_2;
	wire signed   [31:0] interp_1, interp_2, interp_3;
	
	reg unsigned [18:0] reg_data_a_1, reg_data_a_2, reg_data_a_3, reg_data_a_4;
	reg unsigned [11:0] reg_data_b_1;
	reg signed   [20:0] reg_d1;
	reg unsigned [20:0] reg_d2;
	reg unsigned [10:0] reg_diff_1;
	reg unsigned [20:0] reg_diff_2;

	wire unsigned [5:0] shift_mnt = (4'b1101 - msb);
	
	reg unsigned [30:0] reg_interp_1, reg_interp_2, reg_interp_3;
	
	assign d1 = {1'b1, x[22:0]} >> shift_mnt;
	assign d2 = {address, 10'b0000000000};
	
	
	assign diff_1 = reg_data_b_1;
	assign diff_2 = (reg_d1 - reg_d2);
	
	assign interp_1 = ((reg_diff_1 * reg_diff_2) + 256);
	assign interp_2 = (reg_interp_1[30:10]);
	
	assign interpolation = reg_data_a_4 + reg_interp_2;
	
	
	always @(posedge clock) begin
		reg_data_b_1  <= data_b;
		
		reg_data_a_1  <= data_a;
		reg_data_a_2  <= reg_data_a_1;
		reg_data_a_3  <= reg_data_a_2;
		reg_data_a_4  <= reg_data_a_3;
		
		reg_d1 <= d1;
		reg_d2 <= d2;
		reg_diff_1 <= diff_1; 
		reg_diff_2 <= diff_2;
		
		reg_interp_1 <= interp_1[30:0];
		reg_interp_2 <= interp_2[30:0];
		
	end

endmodule

// Resolve the address via MSB's of the mantissa
module address_resolver
(
	input [31:0] x,
	output [9:0]  address,
	output[3:0] msb
);
	parameter param_shift_tanh     = 8'b10001000; // -120
	parameter param_address__shift = 4'b1010;    // 10
	
	reg signed [7:0] shift;
	
	wire unsigned [7:0] msb_;
	assign msb_ = x[30:23] + param_shift_tanh;
	assign msb = msb_[3:0];
	
	wire unsigned [20:0] address_;
	assign address_ = {1'b1, x[22:13]} >> (param_address__shift - msb);
	assign address = address_[10:0];

endmodule
