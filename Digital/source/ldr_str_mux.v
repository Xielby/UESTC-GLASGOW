`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/28 19:40:26
// Design Name: 
// Module Name: ldr_mux
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


module ldr_str_mux(
    clk,rst,
    en_in,en_out,
    rd_q,rs_q,ldr_sel,
    ldr_rom,rom_addr,rom_data
    );
    input [15:0] rs_q,rd_q;
    input [1:0] ldr_sel;
    input clk,rst,en_in;
    output reg en_out;
    output reg [1:0]ldr_rom;
    output reg [15:0] rom_addr,rom_data;
    reg en_del;
    reg [1:0] en_ldr_rom,reg_ldr_rom;



    always @(*) begin
        if(rst ==1'b0)
           begin
                
                rom_addr<=16'b0000_0000_0000_0000;
                en_out <= 1'b0;
                en_del<=0;
                ldr_rom<=0;
                en_ldr_rom<=0;
           end		
           else 
           begin
              if(en_in == 1'b1)
                  begin
                    
                    case (ldr_sel)
                        2'b00: begin
                            en_ldr_rom<=0; 
                            rom_addr<=16'b0000_0000_0000_0000;//避免锁存器
                            rom_data<=16'b0000_0000_0000_0000;
                            en_out<=1; 
                        end
                        2'b01:begin
                            en_ldr_rom<=2'b01;
                            rom_addr<=rs_q;
                            rom_data<=16'b0000_0000_0000_0000;
                            en_out<=1; 
                        end
                        2'b10:begin
                            en_ldr_rom<=2'b10;
                            rom_addr<=rs_q;
                            rom_data<=rd_q;
                            en_out<=0; 
                        end
                        default: begin
                            en_ldr_rom<=0; 
                            rom_addr<=16'b0000_0000_0000_0000;
                            rom_data<=16'b0000_0000_0000_0000;
                            en_out<=0; 
                        end
                    endcase
                  end
              else
                  en_out <= 1'b0;
            end
    end


    always @(posedge clk or negedge rst) 
    begin
        if(!rst) begin
            reg_ldr_rom <= 2'b00;
        end
        else begin
            reg_ldr_rom <= en_ldr_rom;
        end
    end    
    always @(en_ldr_rom or reg_ldr_rom) begin
        ldr_rom <= en_ldr_rom & (~reg_ldr_rom);
    end
endmodule
