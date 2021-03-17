/***************************************************
 - Author :     RUIZ QUINTANA, Diego
 - Module :     fixed32_to_fp32
 - Description: This module only delays the signal to
	perform the pipelined architecture.
	
***************************************************/

module pipe_signals
(
	input clock,
	input resetn,
	input [31:0] x,
	
	input [9:0] address,
	input [3:0]  msb,
	
	output sign_reg_5, 
	output sign_reg_11,

	output [31:0] x_reg,
	output [9:0] address_reg,
	
	output [3:0]  msb_reg
);
	
	reg sign_reg1, sign_reg2,  sign_reg3,  sign_reg4;
	reg sign_reg5, sign_reg6,  sign_reg7,  sign_reg8;
	reg sign_reg9, sign_reg10;
	
	reg unsigned [9:0] address_reg1, address_reg2;
	
	reg unsigned [31:0] x_reg_;
	reg unsigned [3:0]  msb_reg_;
	
	always @(posedge clock)
	begin
		if (resetn == 1'b0) begin
			sign_reg1 <=  0;
			sign_reg2 <=  0;
			sign_reg3 <=  0;
			sign_reg4 <=  0;
			sign_reg5 <=  0;
			sign_reg6 <=  0;
			sign_reg7 <=  0;
			sign_reg8 <=  0;
			sign_reg9 <=  0;
			
			x_reg_ <= 0;
			msb_reg_ <= 0;
		end else begin
			sign_reg1 <= x[31];
			sign_reg2 <= sign_reg1;
			sign_reg3 <= sign_reg2;
			sign_reg4 <= sign_reg3;
			sign_reg5 <= sign_reg4;
			sign_reg6 <= sign_reg5;
			sign_reg7 <= sign_reg6;
			sign_reg8 <= sign_reg7;
			sign_reg9 <= sign_reg8;
			sign_reg10 <= sign_reg9;
			
			x_reg_ <= x;
			msb_reg_ <= msb;
			address_reg1 <= address;
			
		end
	end
	
	assign sign_reg_5  = sign_reg5;
	assign sign_reg_11 = sign_reg9;
	
	assign x_reg = x_reg_;
	assign address_reg = address_reg1;
	assign msb_reg = msb_reg_;
	
endmodule