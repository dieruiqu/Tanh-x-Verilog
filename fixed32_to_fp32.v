/***************************************************
 - Author :     RUIZ QUINTANA, Diego
 - Module :     fixed32_to_fp32
 - Description: This module performs the swap between
	the format S13.18 Q format and the IEEE-754. There
	is not implemented rounding mode, but the accurady
	of the hyperbolic tangente has a MSE of 10e-11.
	
***************************************************/
module fixed32_to_fp32
(
	input clock,
	input resetn,
	input [31:0] X,
	output reg unsigned [31:0] Y
);

	wire unsigned [7:0] exponent;
	wire signed [8:0] shift_s;
	wire unsigned [8:0] shift_u;
	wire unsigned [7:0] first_one;
	reg unsigned [7:0] first_one_s;
	wire unsigned [31:0] mant_shift, X_u;
	wire sign;
	
	// Regs for sign and v
	reg sign1, sign2, sign_shift;
	reg unsigned [31:0] S1, S2, S3;
	
	// 1er registro
	assign sign = X[31];
	assign X_u = (sign && 1'b1) ? (~X + 1) : X;
	
	// 2º registro
	// Gets the first one and signal "v" to check if zeros
	CLZ_32bits CLZ_32bits_ (S1, first_one);
	
	// Calculates the exponent as exp = 127 - 18 + first_one
	// and the shift as shift = 132 - exp
	reg unsigned [8:0] shift_u_s;
	reg unsigned [7:0] exponent_s;
	assign exponent = first_one_s + 8'b01101101;
	assign shift_s = 8'b00010111 - first_one_s;
	assign shift_u = (shift_s[8]) ? (~shift_s + 1'b1) : shift_s;
	assign mant_shift = (sign_shift) ? (S3 >> shift_u_s) : (S3 << shift_u_s);
	
	always @(posedge clock)
		if (resetn == 1'b0) begin
			Y <= 0;
			S1 <= 0;
			S2 <= S1;
			S3 <= S2;
		end else begin
			// 1ª estapa registrada
			S1 <= X_u;
			
			// 2ª etapa registrada
			S2 <= S1;
			first_one_s <= first_one;
			
			// 3ª etapa registrada
			sign_shift <= shift_s[8];
			S3 <= S2;
			shift_u_s <= shift_u;
			exponent_s <= exponent;

			Y <= {1'b0, exponent_s, mant_shift[22:0]};
		end
	
	
	
endmodule

// This module has been created via the following paper:
// Journal of ELECTRICAL ENGINEERING, VOL. 66, NO. 6, 2015, 329–333
module CLZ_32bits
(
	input [31:0] X,
	output unsigned [7:0] Y
);

	wire unsigned [15:0] p;
	wire unsigned [7:0]  v_clz4b;
	wire unsigned [2:0]  y_bne;
	wire unsigned [1:0]  y_mux;
	wire unsigned [2:0]  y_bne_n;
	wire unsigned [1:0]  y_mux_n;
	wire unsigned Q;
	
	priority_encoder_4b pe8(X[31:28], p[1:0],   v_clz4b[0]); // Priority encoder 4 bits for X[31:28]
	priority_encoder_4b pe7(X[27:24], p[3:2],   v_clz4b[1]); // Priority encoder 4 bits for X[27:24]
	priority_encoder_4b pe6(X[23:20], p[5:4],   v_clz4b[2]); // Priority encoder 4 bits for X[23:20]
	priority_encoder_4b pe5(X[19:16], p[7:6],   v_clz4b[3]); // Priority encoder 4 bits for X[19:16]
	priority_encoder_4b pe4(X[15:12], p[9:8],   v_clz4b[4]); // Priority encoder 4 bits for X[15:12]
	priority_encoder_4b pe3(X[11:8],  p[11:10], v_clz4b[5]); // Priority encoder 4 bits for X[11:8]
	priority_encoder_4b pe2(X[7:4],   p[13:12], v_clz4b[6]); // Priority encoder 4 bits for X[7:4] 
	priority_encoder_4b pe1(X[3:0],   p[15:14], v_clz4b[7]); // Priority encoder 4 bits for X[3:0]
	
	BNE BNE_(v_clz4b, y_bne, Q);
	
	mux_282 mux_282_(y_bne, p, y_mux);
	
	assign y_bne_n = ~y_bne;
	assign y_mux_n = ~y_mux;
	assign Y = Q ? 8'b10010011 : {3'b000, y_bne_n, y_mux_n};
	
endmodule

module priority_encoder_4b
(
	input [3:0] X,
	output[1:0] Y,
	output v
);

	wire unsigned [1:0]Out_;
	wire unsigned v_;
	
	reg unsigned [1:0] Out;
	reg unsigned v_reg;
	
	assign Out_[0] = X[3] || (~X[2] && X[1]);
	assign Out_[1] = X[3] || X[2];
	assign v_ = X[3] || X[2] || X[0] || X[1];
	
	assign Y = ~Out_;
	assign v = ~v_;
	
endmodule

module BNE
(
	input unsigned [7:0] a,
	output unsigned[2:0] y,
	output unsigned Q
);
	assign Q = a[0] && a[1] && a[2] && a[3] &&
				  a[4] && a[5] && a[6] && a[7];
	
	assign y[0] = (a[0] && (~a[1] || (a[2] && ~a[3]))) || 
					  (a[0] && a[2] && a[4] && (~a[5] || a[6]));
	
	assign y[1] = a[0] && a[1] && (~a[2] || ~a[3] || (a[4] && a[5]));
	
	assign y[2] = a[0] && a[1] && a[2] && a[3];

endmodule


module mux_282
(
	input  unsigned [2:0]  S,
	input  unsigned [15:0] X,
	output reg unsigned [1:0]  Y	
);

	wire unsigned[1:0] Y_;
	always @(*) begin
		case(S)
			3'b000:  Y <= X[1:0];
			3'b001:  Y <= X[3:2];
			3'b010:  Y <= X[5:4];
			3'b011:  Y <= X[7:6];
			3'b100:  Y <= X[9:8];
			3'b101:  Y <= X[11:10];
			3'b110:  Y <= X[13:12];
			3'b111:  Y <= X[15:14];
			default: Y <= 2'b00;
		endcase
	end
endmodule
