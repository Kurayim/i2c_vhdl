`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2025 11:41:45 PM
// Design Name: 
// Module Name: crc_8
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


module crc_8(
    input wire clk,
    input wire rst,
    input wire run,
    input wire[7:0] data_in,
    output reg ready,
    output[7:0] crc
    );
    
    
    
    parameter IDLE = 2'b00, XOR_ASS = 2'b01, CAL_CRC = 2'b10;
    parameter BITS = 8;
    parameter POLY = 8'h31;
    
    
    reg[7:0] val = 8'hff;
    reg[7:0] num = 0;
    reg[1:0] state   = IDLE;
    reg old_run      = 0;
    

    
    
    always@(posedge clk)begin
        
        old_run <= run;
        if(rst == 0)begin
            state <= IDLE;
        end
        else begin
            case(state)
                IDLE:begin
                    val   <= 8'hff;
                    num   <= 8'h00;
                    state <= XOR_ASS;
                end
                XOR_ASS:begin
                    
                    if(old_run == 0 & run == 1)begin
                        val   <= val ^ data_in;
                        state <= CAL_CRC;
                        
                    end
                end
                CAL_CRC:begin
                    num <= num + 1;
                    if(num <= 7)begin
                        val <= {val[BITS-2:0], 1'b0} ^ (val[BITS-1] ? POLY : 0);
                    end
                    else begin
                        state <= XOR_ASS;
                        ready <= 1;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
    
    
    assign crc = val;
    
    
endmodule







