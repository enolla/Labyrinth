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


module Labyrinth(input logic clk, logic aclMISO,
                 output logic aclMOSI, logic aclSCK, logic aclSS,
                 output logic [6:0]seg, logic[7:0]an,
                 output logic[3:0] vgaRed, logic [3:0] vgaBlue, logic [3:0] vgaGreen, logic Vsync, logic Hsync);

    parameter WRITE = 8'b00001010;
    parameter READ = 8'b00001011;
    parameter XDATA = 8'h08;
    parameter YDATA = 8'h09;
    parameter FILTER_CTL = 8'h2C;
    parameter FILTER_INIT = 8'b00010111;
    parameter POWER_CTL = 8'h2D;
    parameter POWER_INIT = 8'b00000010;

    logic[10:0] xcenter;
    logic[9:0] ycenter;
    logic[3:0] SPIslow;
    logic[2:0] init = 0;
    logic SPIclk;
    logic vgaclk;
    logic [7:0] instruction;
    logic [7:0] address;
    logic [7:0] data_in;
    logic [7:0] xdata_out;
    logic [7:0] ydata_out;
    logic [7:0] xdata;
    logic [7:0] ydata;
    logic [5:0] transmission;
    logic start;
    logic finish;

    assign aclSCK = SPIclk;

    clk_wiz_0 VGAClk(clk, vgaclk);
    
    always_ff@(posedge vgaclk)begin
        SPIslow <= SPIslow + 1;
        if(!SPIslow) SPIclk <= !SPIclk;
    end
    
    always_ff@(posedge SPIclk)begin
    
        transmission <= transmission + 1;
        
        if(finish)start <= 0;
        
        if(!transmission && start == 0)begin
            case(init)
                0:begin
                    instruction <= WRITE;
                    address <= FILTER_CTL;
                    data_in <= FILTER_INIT;
                    start <= 1;
                    init <= 1;
                end
                1:begin
                    address <= POWER_CTL;
                    data_in <= POWER_INIT;
                    start <= 1;
                    init <= 2;
                end
                default:begin
                    instruction <= READ;
                    address <= XDATA;
                    start <= 1;
                end
            endcase
        end
        
        if(transmission == 25 && instruction == WRITE)transmission <= 62;
        if(transmission == 39)transmission <= 62;

        
//        if(transmission == 31 && instruction == READ) xdata <= xdata_out;
        
//        if(transmission == 39 && instruction == READ)begin
//            ydata <= ydata_out - 6;
//            transmission <= 62;
//        end
    end
    
//module SPI(input logic clk, logic start, logic[7:0]address, logic[7:0]instruction, logic[7:0]data_in, logic MISO,
//               output logic SS, logic MOSI, logic[7:0]xdata_out,  logic[7:0]ydata_out, logic finish);
    SPI Accel(SPIclk, start, address, instruction, data_in, aclMISO, aclSS, aclMOSI, xdata_out, ydata_out, finish);
    Display Data(SPIclk, xdata_out, ydata_out, seg, an);
    Calc Center(SPIclk, xdata_out, ydata_out, xcenter, ycenter);
    VGA Out(vgaclk, xcenter, ycenter, vgaRed, vgaBlue, vgaGreen, Vsync, Hsync);
endmodule