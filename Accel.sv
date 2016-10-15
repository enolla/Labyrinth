`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2016 01:48:50 PM
// Design Name: 
// Module Name: Accel
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


module Accel(input logic vgaclk, logic MISO,
             output logic MOSI, logic SS, logic SPIclk);
             
    parameter WRITE = 8'b00001010;
    parameter READ = 8'b00001011;
             
    logic[3:0] SPIslow;
    logic SPIclk;
             
    always_ff@(posedge vgaclk)begin
        SPIslow <= SPIslow + 1;
        if(!SPIslow)SPIclk <= SPIclk + 1;
    end

endmodule
