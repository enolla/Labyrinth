`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2016 11:37:33 PM
// Design Name: 
// Module Name: VGA
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


module VGA(input logic clk, logic[10:0] xcenter, logic[9:0] ycenter,
           output logic [3:0] vgaRed, logic [3:0] vgaBlue, logic [3:0] vgaGreen, logic Vsync, logic Hsync);
        
    logic [10:0] width;
    logic [9:0]height;   
    logic [10:0]xbuf;
    logic [9:0]ybuf; 
    
    always_ff@(posedge clk) begin
        width <= width + 1;
        
        if(width >= 1679)begin //1680 total pixels = 0 to 1679
            width <= 0;
            if(height >= 827) 
            begin
                height <= 0;
                xbuf <= xcenter;
                ybuf <= ycenter;
            end
            else height <= height + 1;
        end
        
        if(((width - xbuf)*(width - xbuf)) + ((height - ybuf)*(height - ybuf)) < 100)begin
            vgaRed <= 15;
            vgaGreen <= 0;
            vgaBlue <= 0;
        end
        else if( width < 1280 && height < 800)begin
            vgaRed <= 15;
            vgaGreen <= 15;
            vgaBlue <= 15;
        end
        else begin
            vgaRed <= 0;
            vgaGreen <= 0;
            vgaBlue <= 0;
        end
        
        if(width > 1343 && width < 1480) Hsync <= 1;//Hsync starts at 1544
        else Hsync <= 0;
        
        if(height > 800 && height < 804)Vsync <= 1;//Vsync at 801
        else Vsync <= 0;

    end

endmodule
