`timescale 1 ns / 1 ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/01 
// Design Name: 
// Module Name: rom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module rom #(
	parameter DWIDTH = 16,
	parameter AWIDTH = 16,
	parameter DEPTH  = 32
)(
	input clk,
	input rst,
	input [AWIDTH - 1 : 0] addr,
	input ready,
	input [15:0]rom_data,

	input  [1:0]ldr_rom,
	input  [15:0]rom_addr,
	output [15:0]ldr_offset,

	output [DWIDTH - 1 : 0] dout,
	output en_out
);
	reg [DWIDTH - 1 : 0] mem[0 : DEPTH - 1];
    reg [15:0] result=0;
	reg valid;
	reg [15:0] result_reg;

	reg [15:0] ldr_result;
	reg [15:0] ldr_result_reg;
	

	initial begin

		// mem[0]  = 16'b0000_0000_0000_1010;  //MOV R0 #10
		// mem[1]  = 16'b0001_0100_0000_0000;  //MOV R1 R0
		// mem[2]  = 16'b0010_0000_0000_0001;  //ADD R0 #1
		// mem[3]  = 16'b0100_0100_0000_0001;  //SUB R1 #1
		// mem[4]  = 16'b0011_0001_0000_0000;  //ADD R0 R1
		// mem[5]  = 16'b0101_0001_0000_0000;  //SUB R0 R1
		// mem[6]  = 16'b1010_0000_0000_0000;  //JMP #0000
		// mem[7]  = 16'b1010_0000_0000_0000;  //JMP #0000
		// mem[8]  = 0;
		// mem[9]  = 16'b0000_0000_0000_1111;
		// mem[10] = 16'b0000_0000_0001_0000;

		


		// mem[0]  = 16'b0000_0000_0000_0010;  //MOV R0 #2  
		// mem[1]  = 16'b0110_1000_0000_0000;  //SHL R0 #1
		// mem[2]  = 16'b1010_0000_0000_0001;  //JMP #1


		mem[0]  = 16'b0000_0000_0000_1010;  //MOV R0 #10  
		mem[1]  = 16'b0000_0100_0000_0000;  //MOV R1 #0
		mem[2]  = 16'b0000_1000_0000_1100;  //MOV R2 #12
		mem[3]  = 16'b1100_0010_0000_0000;  //STR R0 [R2]
		mem[4]  = 16'b1101_0110_0000_0000;  //LDR R1 [R2]
		mem[5]  = 16'b1011_0001_0000_0000;  //CMP R0 R1
		mem[6]  = 16'b1000_0000_0000_0000;  //JZ #0000
		mem[7]  = 16'b1010_0000_0000_0000;  //JMP #0000
		mem[8]  = 0;
		mem[9]  = 0;
		mem[10] = 0;
		mem[11] = 0;
		mem[12] = 0;
		mem[13] = 0;
		mem[14] = 0;
		mem[15] = 0;



		// mem[0]  = 16'b0000_0000_0000_1000;  //MOV R0 #8  
		// mem[1]  = 16'b0000_0100_0000_1010;  //MOV R1 #10
		// mem[2]  = 16'b1011_0001_0000_0000;  //CMP R0 R1
		// mem[3]  = 16'b1000_1000_0000_0000;  //JNZ #0000
		// mem[4]  = 16'b0000_0000_0000_1010;  //MOV R0 #10
		// mem[5]  = 16'b1011_0000_0000_0000;  //CMP R0 R1
		// mem[6]  = 16'b1000_0000_0000_0000;  //JZ #0000





		// mem[0] = 16'b0000_0000_0000_1000;
		// mem[1] = 16'b0000_0100_0000_1010;
		// mem[2] = 16'b1011_0001_0000_0000;
		// mem[3] = 16'b1010_0000_0000_0000;
		// mem[4] = 0;
		// mem[5] = 0;
		// mem[6] = 0;
		// mem[7] = 0;
		// mem[8] = 0;
		// mem[9] = 16'b0000_0000_0000_1111;



		// mem[10] = 16'b0000_0000_0001_0000;

	end
	/*STR LDR
			mem[0] = 16'b0000_0000_0000_1000;  //MOV R0 #8  
			mem[1] = 16'b0000_0100_0000_1010;  //MOV R1 #10
			mem[2] = 16'b1101_1001_0000_0000;  //LDR R2 [R1]
			mem[3] = 16'b1100_0001_0000_0000;  //STR R0 [R1]
			mem[4] = 16'b1101_1001_0000_0000;  //LDR R2 [R1]
			mem[5] = 16'b1010_0000_0000_0000;  //JMP #0
			mem[6] = 0;
			mem[7] = 0;
			mem[8] = 0;
			mem[9] = 16'b0000_0000_0000_1111;
			mem[10] = 16'b0000_0000_0001_0000;

	*/

	always @(posedge clk or negedge rst) begin
		if (rst == 0) begin
			result_reg     <= 16'b0000_0000_0000_0000;
			ldr_result_reg <= 16'b0000_0000_0000_0000;
			ldr_result     <= 16'b0000_0000_0000_0000;
		end
		else begin
			result_reg <= result;
			ldr_result_reg<= ldr_result;
			
		end
	end

	always @(*) begin
		if (rst == 0) 
		begin
			result = 16'b0000_0000_0000_0000;
			valid  = 0;
		end
		else 
		begin
			if (ready) 
			begin 
				result = mem[addr];	
				valid = 1;	
			end
			else 
			begin
			 	result = result_reg;
				valid = 0;
			end
			case (ldr_rom)
				2'b00:begin
					ldr_result = ldr_result_reg;
				end 
				2'b01:begin
					ldr_result = mem[rom_addr];
				end
				3'b10:begin
					mem[rom_addr]=rom_data;
				end
				default: 
				ldr_result = ldr_result_reg;
			endcase
			// if(ldr_rom)
			// begin
			// 	ldr_result = mem[rom_addr];
			// end
			// else
			// begin
			// 	ldr_result = ldr_result_reg;
			// end
		end
	end
	
assign dout = result;
assign ldr_offset = ldr_result;
assign en_out = valid;

endmodule
