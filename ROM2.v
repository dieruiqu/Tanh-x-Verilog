module ROM2
(
	input [9:0] addr,
	input clock,
	output reg [11:0] q
);

	reg [11:0] rom[1023:0];
	
	// Read the memory contents in the file dual_port_rom_init.txt.
	initial 
	begin
		$readmemb("ROM2_init.txt", rom);
	end
	
	// Assign values in the positive edge of the clock
	always @ (posedge clock)
	begin
		q <= rom[addr];
	end
endmodule