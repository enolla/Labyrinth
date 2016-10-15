`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2016 03:31:09 PM
// Design Name: 
// Module Name: testbench
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


//module testbench;

//    logic clock = 0;
//    logic [7:0]xaccel = 0;
//    logic [7:0]yaccel = 0 ;
//    logic [10:0]xcenter;
//    logic [9:0]ycenter;

    
//    always_ff@(posedge clock)begin
//        xaccel <= xaccel + 1;
//        yaccel <= yaccel + 1;
//    end

//always begin
//    #5 clock = !clock;
//end

////module Calc(input logic clk, logic [7:0]x_accel, logic [7:0]y_accel,
////            output logic [10:0]xcenter, logic [9:0] ycenter);

//    Calc Center(clock, xaccel, yaccel, xcenter, ycenter);

//endmodule

module testbench;


    parameter WRITE = 8'b00001010;
    parameter READ = 8'b00001011;
    parameter XDATA = 8'h08;
    parameter YDATA = 8'h09;
    parameter FILTER_CTL = 8'h2C;
    parameter FILTER_INIT = 8'b00010111;
    parameter POWER_CTL = 8'h2D;
    parameter POWER_INIT = 8'b00000010;

    logic clock = 0;
    logic[2:0] init = 0;
    logic [7:0] instruction;
    logic [7:0] address;
    logic [7:0] data_in;
    logic [7:0] xdata_out;
    logic [7:0] ydata_out;
    logic [7:0] xdata;
    logic [7:0] ydata;
    logic [5:0] transmission = 0;
    logic start = 0;
    logic finish = 0;
    logic SS = 1;
    logic MISO = 1;
    logic MOSI;

    always begin
        #5 clock = !clock;
    end
    
    always_ff@(posedge clock)begin
        
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
            
            if(transmission == 31 && instruction == READ) xdata <= xdata_out;
            
            if(transmission == 39 && instruction == READ)begin
                ydata <= ydata_out - 6;
                transmission <= 62;
            end
        end

SPI DUT(clock, start, address, instruction, data_in, MISO, SS, MOSI, xdata_out, ydata_out, finish);

endmodule
