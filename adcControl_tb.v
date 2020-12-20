`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2020 07:28:55 PM
// Design Name: 
// Module Name: adcControl_tb
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


module adcControl_tb();    
    reg CLK;
    reg PERFORM;
    reg CLKOUT;
    reg SDO1;
    reg SDO2;
    reg SDO3;
    reg SDO4;
    reg SDO5;
    reg SDO6;
    reg SDO7;
    reg SDO8;
    wire ch1Max;
    wire ch2Max;
    wire ch3Max;
    wire ch4Max;
    wire ch5Max;
    wire ch6Max;
    wire ch7Max;
    wire ch8Max;
    wire SCK;
    wire CNV;
    
    adcControl dut(
     .CLK(CLK),
     .PERFORM(PERFORM),
     .CLKOUT(CLKOUT),
     .SDO1(SDO1),
     .SDO2(SDO2),
     .SDO3(SDO3),
     .SDO4(SDO4),
     .SDO5(SDO5),
     .SDO6(SDO6),
     .SDO7(SDO7),
     .SDO8(SDO8),
     .ch1Max(ch1Max),
     .ch2Max(ch2Max),
     .ch3Max(ch3Max),
     .ch4Max(ch4Max),
     .ch5Max(ch5Max),
     .ch6Max(ch6Max),
     .ch7Max(ch7Max),
     .ch8Max(ch8Max),
     .SCK(SCK),
     .CNV(CNV)
    );
    
    initial 
        begin
            CLK <= 0;
            CLKOUT <= 0;
            SDO1 <= 0;
            SDO2 <= 0;
            SDO3 <= 0;
            SDO4 <= 0;
            SDO5 <= 0;
            SDO6 <= 0;
            SDO7 <= 0;
            SDO8 <= 0;
            PERFORM <= 0;
            # 10
            PERFORM <= 1;
            #20000000
            PERFORM <= 0;
            #20000000
            PERFORM <= 1;
            #20000000
            PERFORM <= 0;  
        end
    
    always 
        #5  CLK = !CLK;
    always 
        CLKOUT <= SCK;
endmodule
