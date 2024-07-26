`timescale 1ns / 1ps  
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/01 
// Design Name: 
// Module Name: state_transition
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
module state_transition(clk,rst,alu_end,rd,rs,ldr_sel,opcode,en_fetch,en_pc,pc_ctrl,reg_en,alu_in_sel,alu_func,en_group_pulse

);
input clk,rst;
input alu_end;
input [1:0] rd,rs;
input [3:0] opcode;
output reg en_fetch;
output reg en_pc;
output reg [1:0] en_group_pulse;
output reg [1:0] pc_ctrl;
output reg [4:0] reg_en;
output reg [1:0] alu_in_sel,ldr_sel;
output reg [3:0] alu_func;

reg [1:0] en_group_reg, en_group;
reg [4:0] current_state,next_state;
parameter Initial       = 5'b00000;
parameter Fetch         = 5'b00001; 			
parameter Decode        = 5'b00010; 		
parameter Execute_Moveb = 5'b00011;  
parameter Execute_Addb  = 5'b00100;    
parameter Execute_Subb   = 5'b00101;    
parameter Execute_And   = 5'b00110;    
parameter Execute_Or    = 5'b00111;


parameter Execute_Jz    = 5'b01000;
parameter Execute_Cmp   = 5'b01011;

parameter Execute_Ldr   = 5'b01101;
parameter Execute_Str   = 5'b01100;


parameter Execute_NOR   = 5'b01110;
parameter Execute_XNOR  = 5'b01111;

parameter Execute_Jump  = 5'b01010;   
parameter Write_back    = 5'b01001; 

parameter Execute_Shift = 5'b10000;
parameter Execute_Move  = 5'b10001;
parameter Execute_Add   = 5'b10010;
parameter Execute_Sub   = 5'b10011;




always @ (posedge clk or negedge rst) begin
	if(!rst)
		current_state <= Initial;
	else 
		current_state <= next_state;
end

// Below codes defines state transition for "next_state"
always @ (*) 
begin
	case (current_state)
		Initial: 
		begin
			if(rst)
				next_state = Fetch;
			else
				next_state = Initial;
		end
		Fetch:	
		begin
			next_state = Decode;
        end
		Decode:
			begin
				case(opcode)
                4'b0000: next_state = Execute_Moveb;
				4'b0001: next_state = Execute_Move;

                4'b0010: next_state = Execute_Addb;
				4'b0011: next_state = Execute_Add;

                4'b0100: next_state = Execute_Subb;
				4'b0101: next_state = Execute_Sub;

				4'b0110: next_state = Execute_Shift;

                4'b0111: next_state = Execute_And;
                4'b1001: next_state = Execute_Or;
                4'b1010: next_state = Execute_Jump;


				4'b1000: next_state = Execute_Jz;
				4'b1011: next_state = Execute_Cmp;

				4'b1101: next_state = Execute_Ldr;
				4'b1100: next_state = Execute_Str;

				4'b1110: next_state = Execute_NOR;
				4'b1111: next_state = Execute_XNOR;
                default: next_state = current_state;
            endcase
			end



		Execute_Moveb: 
		begin
			if(alu_end)
				next_state = Write_back;
			else
				next_state = current_state;
		end

		Execute_Move: 
		begin
			if(alu_end)
				next_state = Write_back;
			else
				next_state = current_state;
		end

		Execute_Addb: 
		begin
			if(alu_end)
				next_state = Write_back;
			else
				next_state = current_state;
		end

		Execute_Add: 
		begin
			if(alu_end)
				next_state = Write_back;
			else
				next_state = current_state;
		end

		Execute_Subb: 
		begin
			if(alu_end)
				next_state = Write_back;
			else
				next_state = current_state;
		end

		Execute_Sub: 
		begin
			if(alu_end)
				next_state = Write_back;
			else
				next_state = current_state;
		end

		Execute_And: 
		begin
            // Please add your code here

			if(alu_end)
				next_state = Write_back;
			else
				next_state = current_state;

		end   
		Execute_Or: 
		begin
	        // Please add your code here

			if(alu_end)
				next_state = Write_back;
			else
				next_state = current_state;

        end
		



		Execute_Cmp:
		begin
			if(alu_end)
			next_state = Write_back;
		else
			next_state = current_state;
		end


		Execute_Ldr: 
		begin
	        // Please add your code here

			if(alu_end)
				next_state = Write_back;
			else
				next_state = current_state;

        end

		Execute_Str: next_state = Fetch;


		Execute_NOR: 
		begin
	        // Please add your code here

			if(alu_end)
				next_state = Write_back;
			else
				next_state = current_state;

        end

		Execute_XNOR: 
		begin
	        // Please add your code here

			if(alu_end)
				next_state = Write_back;
			else
				next_state = current_state;

        end
		
		Execute_Shift: 
		begin
	        // Please add your code here

			if(alu_end)
				next_state = Write_back;
			else
				next_state = current_state;

        end


		Execute_Jz: next_state = Fetch;
		Execute_Jump: next_state = Fetch;
		Write_back: next_state = Fetch;
		default: next_state = current_state;
	endcase
end

// Below codes provide control signals
always @ (*) begin
	if(!rst) begin
		en_fetch = 1'b0;
		en_group = 1'b0;
		en_pc = 1'b0;
		pc_ctrl = 2'b00;
		reg_en = 4'b0000;
		alu_in_sel = 1'b0;
		alu_func = 3'b000;
		ldr_sel = 1'b0;

	end
	else begin
		case (next_state) // Using next_state to decide control signals
			Initial: 
			begin
				en_fetch = 1'b0;
				en_group = 1'b0;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;
				alu_func = 3'b000;
				ldr_sel = 1'b0;

			end
			Fetch: 
			begin
				en_fetch = 1'b1;
				en_group = 1'b0;
				en_pc = 1'b1;
				pc_ctrl = 2'b01;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;
				alu_func = 3'b000;
				ldr_sel = 1'b0;

			end
			Decode: 
			begin
				en_fetch = 1'b0;
				en_group = 1'b0;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;
				alu_func = 3'b000;
				ldr_sel = 1'b0;

			end
			Execute_Moveb: 
			begin
				en_fetch = 1'b0;
				en_group = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;
				alu_func = 3'b000;
				ldr_sel = 1'b0;

			end
			Execute_Move: 
			begin
				en_fetch = 1'b0;
				en_group = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;
				alu_func = 3'b000;
				ldr_sel = 1'b0;

			end
			Execute_Addb: 
			begin
				en_fetch = 1'b0;
				en_group = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;
				alu_func = 3'b001;
				ldr_sel = 1'b0;

			end
			Execute_Add: 
			begin
				en_fetch = 1'b0;
				en_group = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;
				alu_func = 3'b001;
				ldr_sel = 1'b0;

			end
			Execute_Subb: 
			begin
				en_fetch = 1'b0;
				en_group = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;
				alu_func = 3'b010;
				ldr_sel = 1'b0;

			end
			Execute_Sub: 
			begin
				en_fetch = 1'b0;
				en_group = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;
				alu_func = 3'b010;
				ldr_sel = 1'b0;

			end
			Execute_And: 
			begin
				// en_fetch = 
				en_fetch=1'b0;

				en_group = 1'b1;
				en_pc = 1'b0;
				// pc_ctrl = 
				pc_ctrl=1'b0;

				reg_en = 4'b0000;
				alu_in_sel = 1'b1;
				// alu_func =
				alu_func=3'b011;
				ldr_sel = 1'b0;

				
			end
			Execute_Or: 
			begin
				// en_fetch = 
				en_fetch=1'b0;

				en_group = 1'b1; 
				en_pc = 1'b0;
				// pc_ctrl = 
				pc_ctrl=1'b0;

				reg_en = 4'b0000;
				alu_in_sel = 1'b1;
				// alu_func = 
				alu_func=3'b100;
				ldr_sel = 1'b0;


			end

			Execute_Cmp:
			begin
				// en_fetch = 
				en_fetch=1'b0;

				en_group = 1'b1; 
				en_pc = 1'b0;
				// pc_ctrl = 
				pc_ctrl=1'b0;

				reg_en = 4'b0000;
				alu_in_sel = 2'b01;
				// alu_func = 
				alu_func=4'b1011;
				ldr_sel = 2'b00;

			end


			Execute_Ldr: 
			begin
				// en_fetch = 
				en_fetch=1'b0;

				en_group = 1'b1; 
				en_pc = 1'b0;
				// pc_ctrl = 
				pc_ctrl=1'b0;

				reg_en = 4'b0000;
				alu_in_sel = 2'b10;
				// alu_func = 
				alu_func=4'b1101;
				ldr_sel = 2'b01;


			end

			Execute_Str: 
			begin
				// en_fetch = 
				en_fetch=1'b0;

				en_group = 1'b1;
				en_pc = 1'b0;
				// pc_ctrl = 
				pc_ctrl=1'b0;

				reg_en = 4'b0000;
				alu_in_sel = 2'b10;
				// alu_func = 
				alu_func=4'b1100;
				ldr_sel = 2'b10;


			end


			Execute_NOR: 
			begin
				// en_fetch = 
				en_fetch=1'b0;

				en_group = 1'b1; 
				en_pc = 1'b0;
				// pc_ctrl = 
				pc_ctrl=1'b0;

				reg_en = 4'b0000;
				alu_in_sel = 1'b1;
				// alu_func = 
				alu_func=4'b1110;
				ldr_sel = 1'b0;


			end

			Execute_XNOR: 
			begin
				// en_fetch = 
				en_fetch=1'b0;

				en_group = 1'b1; 
				en_pc = 1'b0;
				// pc_ctrl = 
				pc_ctrl=1'b0;

				reg_en = 4'b0000;
				alu_in_sel = 1'b1;
				// alu_func = 
				alu_func=4'b1111;
				ldr_sel = 1'b0;

			end

			Execute_Jz:
			begin
				en_fetch = 1'b0;
				en_group = 2'b10; 
				en_pc = 1'b1;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;
				alu_func = 3'b000;
				ldr_sel = 1'b0;
			end

			Execute_Jump: 
			begin
				en_fetch = 1'b0;
				en_group = 1'b0; 
				en_pc = 1'b1;
				pc_ctrl = 2'b11;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;
				alu_func = 3'b000;
				ldr_sel = 1'b0;

			end

			Execute_Shift:
			begin
				case (rd)
					2'b01:begin
						en_fetch = 1'b0;
						en_group = 1'b1;
						en_pc = 1'b0;
						pc_ctrl = 2'b00;
						reg_en = 4'b0000;
						alu_in_sel = 1'b1;
						alu_func = 3'b110;
						ldr_sel = 1'b0;
					end 
					2'b10:begin
						en_fetch = 1'b0;
						en_group = 1'b1;
						en_pc = 1'b0;
						pc_ctrl = 2'b00;
						reg_en = 4'b0000;
						alu_in_sel = 1'b1;
						alu_func = 3'b101;
						ldr_sel = 1'b0;
					end
					default: begin
						en_fetch = 1'b0;
						en_group = 1'b0;
						en_pc = 1'b0;
						pc_ctrl = 2'b00;
						reg_en = 4'b0000;
						alu_in_sel = 1'b0;
						alu_func = 3'b000;
						ldr_sel = 1'b0;
					end
				endcase
			end

			Write_back:begin
				if (opcode==4'b1011) 
				reg_en=5'b10000;
				else if(opcode==4'b0110)begin
					case (rs)
						2'b00: reg_en = 4'b0001;
						2'b01: reg_en = 4'b0010;
						2'b10: reg_en = 4'b0100;
						2'b11: reg_en = 4'b1000;
						default: reg_en = 4'b0000;
						endcase
				end
				else
					begin
					case(rd)
						2'b00: reg_en = 4'b0001;
						2'b01: reg_en = 4'b0010;
						2'b10: reg_en = 4'b0100;
						2'b11: reg_en = 4'b1000;
						default: reg_en = 4'b0000;
					endcase
					end
				
				en_fetch = 1'b0;
				en_group = 1'b0;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				alu_in_sel = 1'b0;
				alu_func = 3'b000;
				ldr_sel = 1'b0;
				end
			
			default: 
			begin
				en_fetch = 1'b0;
				en_group = 1'b0;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;
				alu_func = 3'b000;
				ldr_sel = 1'b0;

			end
		endcase
	end
end

always @ (posedge clk or negedge rst) 
begin
	if(!rst) begin
		en_group_reg <= 2'b00;
	end
	else begin
		en_group_reg <= en_group;
	end
end

always @ (en_group_reg or en_group) 
begin
	en_group_pulse <= en_group & (~en_group_reg);
end
endmodule