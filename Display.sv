`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2016 03:10:22 PM
// Design Name: 
// Module Name: Display
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


module Display(input logic clk, logic [7:0]xdata, logic [7:0]ydata,
               output logic [6:0]seg, output logic [7:0]an);

    //logic[31:0]display;// move display to input for a value from another module
    logic[7:0]slow; // to see what's really happening increase slow
    logic[2:0]cycle;
    logic[6:0]seg0;
    logic[6:0]seg1;
    logic[6:0]seg2;
    logic[6:0]seg3;
    logic[6:0]seg4;
    logic[6:0]seg5;
    logic[6:0]seg6;
    logic[6:0]seg7;
    logic[22:0]capture;
    logic[7:0]xcapture;
    logic[7:0]ycapture;
    
//    SevenSeg An0(xdata[3:0], seg0[6:0]);
//    SevenSeg An1(xdata[7:4], seg1[6:0]);
//    SevenSeg An2(xdata[10:8], seg2[6:0]);
//    SevenSeg An3(4'h0, seg3[6:0]);
//    SevenSeg An4(ydata[3:0], seg4[6:0]);
//    SevenSeg An5(ydata[7:4], seg5[6:0]);
//    SevenSeg An6(ydata[9:8], seg6[6:0]);
//    SevenSeg An7(4'h0, seg7[6:0]);
    
    SevenSeg An0(xcapture[0], seg0[6:0]);
    SevenSeg An1(xcapture[2], seg1[6:0]);
    SevenSeg An2(xcapture[2], seg2[6:0]);
    SevenSeg An3(xcapture[3], seg3[6:0]);
    SevenSeg An4(xcapture[4], seg4[6:0]);
    SevenSeg An5(xcapture[5], seg5[6:0]);
    SevenSeg An6(xcapture[6], seg6[6:0]);
    SevenSeg An7(xcapture[7], seg7[6:0]);
    
//    SevenSeg An0(ycapture[0], seg0[6:0]);
//    SevenSeg An1(ycapture[1], seg1[6:0]);
//    SevenSeg An2(ycapture[2], seg2[6:0]);
//    SevenSeg An3(ycapture[3], seg3[6:0]);
//    SevenSeg An4(ycapture[4], seg4[6:0]);
//    SevenSeg An5(ycapture[5], seg5[6:0]);
//    SevenSeg An6(ycapture[6], seg6[6:0]);
//    SevenSeg An7(ycapture[7], seg7[6:0]);

    always_ff@(posedge clk) begin
        slow <= slow + 1;
        capture <= capture + 1;
        
        if(capture == 1000000)begin
            capture <= 0;
            xcapture <= xdata;
            ycapture <= ydata;
        end

        if(!slow)begin
            
            an <= 'b11111111;
            case(cycle)
                0: begin
                    seg <= seg0;
                    an[0] <= 0;
                end
                1: begin
                    seg <= seg1;
                    an[1] <= 0;
                end
                2: begin
                    seg <= seg2;
                    an[2] <= 0;
                end
                3: begin
                    seg <= seg3;
                    an[3] <= 0;
                end
                4:begin
                    seg <= seg4;
                    an[4] <= 0;
                end
                5:begin
                    seg <= seg5;
                    an[5] <= 0;
                end
                6:begin
                    seg <= seg6;
                    an[6] <= 0;
                end
                7:begin
                    seg <= seg7;
                    an[7] <= 0;
                end
            endcase
        
            cycle <= cycle + 1;
        end
    end      
endmodule


module SevenSeg( input logic [3:0]value,
                 output logic [6:0]seg);
    
    always_comb begin
        case(value)
        0: seg = 'b1000000;
        1: seg = 'b1111001;
        2: seg = 'b0100100;
        3: seg = 'b0110000;
        4: seg = 'b0011001;
        5: seg = 'b0010010;
        6: seg = 'b0000010;
        7: seg = 'b1111000;
        8: seg = 'b0000000;
        9: seg = 'b0011000;
        10: seg = 'b0001000;
        11: seg = 'b0000011;
        12: seg = 'b1000110;
        13: seg = 'b0100001;
        14: seg = 'b0000110;
        15: seg = 'b0001110;
        endcase    
    end
endmodule
