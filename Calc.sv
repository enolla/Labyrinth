`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2016 04:31:24 PM
// Design Name: 
// Module Name: Calc
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


module Calc(input logic clk, logic [7:0]x_accel, logic [7:0]y_accel,
            output logic [10:0]xcenter, logic [9:0] ycenter);
            
    //8'b11111111 = 255
    //8'b10000000 = 128
    //8'b01111111 = 127
           
    logic[10:0] xcenter = 640;
    logic[9:0] ycenter = 400;
    logic [7:0] x_vel = 0;
    logic [7:0] y_vel = 0;
    logic [22:0] slow = 0;
    
    always_ff@(posedge clk)begin
        slow <= slow + 1;
        
        if(slow == 5000000)begin
            if(x_accel[7] == 0)begin // move down
                if(x_vel - x_accel >  175)x_vel <= x_vel - x_accel;
            end
            else(x_accel[7] == 1)begin//move up
                if(x_vel + x_accel < 80)x_vel <= x_vel + ~x_accel;
            end
            
            if(y_accel[7] == 0)begin // move left
                if(y_vel - y_accel > 175)y_vel <= y_vel - y_accel;
            end
            else(y_accel[7] == 1)begin // move right
                if(y_vel + y_accel < 80)y_vel <= y_vel + ~y_accel;
            end
            
            if(x_vel[7] == 0)begin //move up
                if(ycenter + x_vel > 10) ycenter <= ycenter + x_vel;
            end
            
            if(x_vel[7] == 1)begin //move down
                if(ycenter + x_vel < 790) ycenter <= ycenter + x_vel;
            end
            
            if(y_vel[7] == 0)begin //move right
                if(xcenter + y_vel < 1270) xcenter <= xcenter + y_vel;
                else xcenter <= 1270;
            end
            
            if(y_vel[7] == 1)begin //move left
                if(xcenter + y_vel > 10) xcenter <= xcenter + y_vel;
                else xcenter <= 10;
            end
            
            slow <= 0;
        end
    
    end

endmodule
