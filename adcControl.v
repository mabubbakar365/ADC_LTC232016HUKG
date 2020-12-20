`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2020 06:45:47 PM
// Design Name: 
// Module Name: adcControl
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


module adcControl(
    input CLK,
    input PERFORM,
    input CLKOUT,
    input SDO1,
    input SDO2,
    input SDO3,
    input SDO4,
    input SDO5,
    input SDO6,
    input SDO7,
    input SDO8,
    output ch1Max,
    output ch2Max,
    output ch3Max,
    output ch4Max,
    output ch5Max,
    output ch6Max,
    output ch7Max,
    output ch8Max,
    output SCK,
    output reg CNV
    );
    
    parameter START = 3'b000;
    parameter ACQ = 3'b001;
    parameter DATA = 3'b010;
    parameter CLEANUP = 3'b011;
    
    parameter VALUE = 2000000;
    
    reg[2:0] state;
    reg[20:0] validTimer;
    reg[16:0] counter;
    reg[3:0] bitIndex;
    reg[15:0] data1;
    reg[15:0] data2;
    reg[15:0] data3;
    reg[15:0] data4;
    reg[15:0] data5;
    reg[15:0] data6;
    reg[15:0] data7;
    reg[15:0] data8;
    reg[15:0] ch1;
    reg[15:0] ch2;
    reg[15:0] ch3;
    reg[15:0] ch4;
    reg[15:0] ch5;
    reg[15:0] ch6;
    reg[15:0] ch7;
    reg[15:0] ch8;
    reg[15:0] ch1Max;
    reg[15:0] ch2Max;
    reg[15:0] ch3Max;
    reg[15:0] ch4Max;
    reg[15:0] ch5Max;
    reg[15:0] ch6Max;
    reg[15:0] ch7Max;
    reg[15:0] ch8Max;
    reg flag;
    reg checkBit;
    reg dataValid;
    
    initial 
        begin
            state <= 0;
            flag <= 0;
            validTimer <= 0;
            checkBit <= 0;
            counter <= 0;
            dataValid <= 0;
            bitIndex <= 15;
            data1 <= 0;
            data2 <= 0;
            data3 <= 0;
            data4 <= 0;
            data5 <= 0;
            data6 <= 0;
            data7 <= 0;
            data8 <= 0;
            ch1 <= 0;
            ch2 <= 0;
            ch3 <= 0;
            ch4 <= 0;
            ch5 <= 0;
            ch6 <= 0;
            ch7 <= 0;
            ch8 <= 0;
            ch1Max <= 0;
            ch2Max <= 0;
            ch3Max <= 0;
            ch4Max <= 0;
            ch5Max <= 0;
            ch6Max <= 0;
            ch7Max <= 0;
            ch8Max <= 0;
        end
        
    assign SCK = CLK && flag;
    
    always @(posedge CLK)
         begin
            if((validTimer < VALUE) && (PERFORM == 1))
                begin
                    checkBit <= 1;
                    validTimer <= validTimer + 1;
                end
            else
                begin
                    checkBit <= 0;
                    validTimer <= 0;
                    ch1Max <= ch1;
                    ch2Max <= ch2;
                    ch3Max <= ch3;
                    ch4Max <= ch4;
                    ch5Max <= ch5;
                    ch6Max <= ch6;
                    ch7Max <= ch7;
                    ch8Max <= ch8;
                end
         end
         
    always @(posedge CLK)
        begin
            if(checkBit == 1) 
                begin
                    case(state)
                        START:
                            begin
                                if(counter < 10)
                                    begin
                                        flag <= 0;
                                        CNV <= 1;
                                        counter <= counter + 1;
                                        state <= START;
                                    end
                                else
                                    begin   
                                        flag <= 0;
                                        counter <= 0;
                                        CNV <= 0;
                                        state <= ACQ;
                                    end
                            end
                        ACQ:
                            begin
                                if(counter < 15)
                                    begin
                                        flag <= 0;
                                        CNV <= 0;
                                        counter <= counter + 1;
                                        state <= ACQ;
                                    end
                                else
                                    begin
                                        flag <= 0;
                                        counter <= 0;
                                        CNV <= 0;
                                        state <= DATA;
                                    end
                            end
                        DATA:
                           begin
                            if(counter < 16)
                                begin
                                    flag <= 1;
                                    counter <= counter + 1;
                                    state <= DATA;
                                end
                            else
                                begin
                                    flag <= 0;
                                    counter <= 0;
                                    state <= CLEANUP;
                                end
                           end
                       CLEANUP:
                        begin
                            if(counter < 1)
                                begin
                                    flag <= 0;
                                    counter <= counter + 1;
                                    dataValid <= 1;
                                    state <= CLEANUP;
                                end
                            else
                                begin
                                    counter <= 0;
                                    dataValid <= 0;
                                    state <= START;
                                end
                        end
                    CLEANUP:
                        begin
                            flag <= 0;
                            counter <= 0;
                            state <= START;
                        end
                    endcase
                end
            else
                begin
                    flag <= 0;
                    dataValid <= 1;
                    counter <= 0;
                    CNV <= 0;
                end
        end
    always @(posedge CLKOUT)    
        begin
            if(bitIndex > 0) 
                begin
                    data1[bitIndex] <= SDO1;
                    data2[bitIndex] <= SDO2;
                    data3[bitIndex] <= SDO3;
                    data4[bitIndex] <= SDO4;
                    data5[bitIndex] <= SDO5;
                    data6[bitIndex] <= SDO6;
                    data7[bitIndex] <= SDO7;
                    data8[bitIndex] <= SDO8;
                    bitIndex <= bitIndex - 1;
                end
            else
                begin
                    bitIndex <= 15;
                end
        end
    always @(posedge dataValid)
        begin
            if(ch1 < data1) ch1 <= data1;
            if(ch2 < data2) ch2 <= data2;
            if(ch3 < data3) ch3 <= data3;
            if(ch4 < data4) ch4 <= data4;
            if(ch5 < data5) ch5 <= data5;
            if(ch6 < data6) ch6 <= data6;
            if(ch7 < data7) ch7 <= data7;
            if(ch8 < data8) ch8 <= data8;
        end
endmodule

