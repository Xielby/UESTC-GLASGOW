`timescale 1ns / 1ps  
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/01 
// Design Name: 
// Module Name: data_path
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
module data_path (
	 clk,rst,en_pc,pc_ctrl,offset,ldr_sel,en_in,reg_en,ldr_offset,alu_in_sel,alu_func,rd,rs,en_out,pc_out,ldr_rom,rom_addr,rom_data
);

input clk,rst,en_pc;
input [7:0] offset;
input [1:0] en_in,pc_ctrl,rd,alu_in_sel,rs,ldr_sel;
input [4:0]  reg_en;
input [3:0] alu_func;
input [15:0] ldr_offset;
output  en_out;
output [1:0]ldr_rom;
output [15:0] pc_out,rom_addr,rom_data;

wire en_out_group ,en_out_ldr,en_out_alu_mux,ZF_ctrl;  
wire [15:0] rd_q, rs_q ,alu_a ,alu_b ,alu_out;	




pc pc1(
         .clk(clk),
         .rst(rst),       
		 .en_in(en_pc),
		 .pc_ctrl({ZF_ctrl|pc_ctrl[1],ZF_ctrl|pc_ctrl[0]}),
		 .offset_addr(offset), 		 			 
		 .pc_out(pc_out)	
    );

reg_group reg_group1(
				.clk(clk),
				.rst(rst),
				.en_in(en_in),
				.reg_en(reg_en),
				.d_in(alu_out),
				.rd(rd),
				.rs(rs),
				.rd_q(rd_q),
				.rs_q(rs_q),
				.en_out(en_out_group),
				.ZF_ctrl(ZF_ctrl)
			);
			
ldr_str_mux ldr_str_mux1(
				.clk(clk),
				.rst(rst),
				.en_in(en_out_group),
				.rs_q(rs_q),
				.rd_q(rd_q),
				.ldr_sel(ldr_sel),
				.ldr_rom(ldr_rom),
				.rom_addr(rom_addr),
				.rom_data(rom_data),
				.en_out(en_out_ldr)
				);

alu_mux alu_mux1(             
					.clk(clk),                           
					.rst(rst),
					.en_in(en_out_ldr),
					.rd_q(rd_q),
					.rs_q(rs_q),
					.offset(offset),
					.ldr_offset(ldr_offset),
					.alu_in_sel(alu_in_sel),
					.alu_a(alu_a),				
					.alu_b(alu_b),
					.en_out(en_out_alu_mux)	
				);

alu alu1 (
					.clk(clk),    
					.rst(rst),
					.en_in(en_out_alu_mux),					
					.alu_a(alu_a),
					.alu_b(alu_b),
					.alu_func(alu_func),
					.en_out(en_out),
					.alu_out(alu_out ) 
				);				
				
endmodule				
				