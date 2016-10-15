`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2016 01:11:31 PM
// Design Name: 
// Module Name: SPI
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


module SPI(input logic clk, logic start, logic[7:0]address, logic[7:0]instruction, logic[7:0]data_in, logic MISO,
           output logic SS, logic MOSI, logic[7:0]xdata_out, logic[7:0]ydata_out, logic finish);
    
    parameter WRITE = 8'b00001010;
    parameter READ = 8'b00001011;
    
    logic[5:0]bitcount;
    logic[7:0]data_byte_sent;
    logic[7:0]xdata;
    logic[7:0]ydata;
    
    always_ff@(negedge clk)begin
    
        if(start)begin
            SS <= 0;    
            bitcount <= 0;
            MOSI <= instruction[7];
            data_byte_sent <= {instruction[6:0], 1'b0};
        end
    
        if(start && !SS) finish <= 1;
        if(finish && !start)finish <= 0;
    
        if(!SS)begin
            bitcount <= bitcount + 1;
            
            if(bitcount < 24)begin
                if(bitcount < 6)begin
                    MOSI <= data_byte_sent[7];
                    data_byte_sent <= {data_byte_sent[6:0], 1'b0};
                end
                else if(bitcount == 6)begin
                    MOSI <= data_byte_sent[7];
                    data_byte_sent <= address;
                end
                else if(bitcount > 6 && bitcount < 14)begin
                    MOSI <= data_byte_sent[7];
                    data_byte_sent <= {data_byte_sent[6:0], 1'b0};
                end
                else if(bitcount == 14 && instruction == WRITE)begin
                    MOSI <= data_byte_sent[7];
                    data_byte_sent <= data_in;
                end
                else if(bitcount > 14 && instruction == WRITE)begin
                    MOSI <= data_byte_sent[7];
                    data_byte_sent <= {data_byte_sent[6:0], 1'b0};
                end
                else if(bitcount == 14 && instruction == READ)begin
                    MOSI <= data_byte_sent[7];
                end
                else if(bitcount > 14 && instruction == READ)begin
                //xdata_out <= {xdata_out[6:0], MISO};
                end
            end
            else if(bitcount < 32 && instruction == READ)begin
            //ydata_out <= {ydata_out[6:0], MISO};
            end
            else begin
                SS <= 1;
            end
        
        end
    end
        
    always_ff @(posedge clk) begin
        if(!SS && instruction == READ) begin
            if(bitcount > 14) begin
                if(bitcount < 24) begin
                    xdata <= {xdata[6:0], MISO};
                end 
                else begin
                    ydata <= {ydata[6:0], MISO};
                end
            end
            if(bitcount == 31) begin
                xdata_out <= xdata;
                ydata_out <= {ydata[6:0], MISO};
            end
        end
    end
    //    assign xdata_out = xdata;
    //    assign ydata_out = ydata;
    //    always_ff@(posedge clk)begin
    //        if(bitcount == 24 && instruction == WRITE)begin
    //            SS <= 1;
    //            //finish <= 1;
    //        end
    //        else if(bitcount == 32 && instruction == READ)begin
    //            SS <= 1;
    //            //finish <= 1;
    //        end
    //    end
    
endmodule
