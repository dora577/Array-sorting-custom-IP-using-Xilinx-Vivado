`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Darkhan Baizhan 
// 
// Create Date: 04/15/2020 09:29:02 PM
// Design Name: 
// Module Name: sortCore
// Project Name: Embedded Microcontrollers 
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


module sortCore(
input clk,
input reset,
input start,
input PSportAWrEn,
input PSportARdEn,
input [9:0] PSadress,
input [31:0] PSinputPortA,
output [31:0] sortedOut,
output reg done
);

wire [31:0] inputPortA;
reg [31:0] IntInputA;
assign inputPortA = (start)? IntInputA : PSinputPortA  ;

wire [31:0] portARdData;

wire WrEnportA;
reg IntportAWrEn;
assign WrEnportA = (start)? IntportAWrEn : PSportAWrEn ;

wire [9:0] AddressportA;
reg [9:0] IntAddressA;
assign AddressportA = (start)?  IntAddressA : PSadress;

reg portBWrEn;
reg [31:0] inputPortB;
reg [9:0] AddressB;
wire [31:0] portBRdData;

reg [9:0] temp;
reg [9:0] NoElements;
reg [2:0] state;
reg swapFlag;

reg fifoWrEn;

    
localparam  IDLE  = 'd0,
            FETCH = 'd1,
            COMPARE = 'd2,
            SWAP = 'd3,
            WAIT = 'd4,
            RENEW = 'd5,
            WAIT2 ='d6,
            WRITE ='d7;    
    
always@(posedge clk)
begin
    if(reset)
    begin
        state<=IDLE;
        IntInputA <= 32'h0000;
        inputPortB <= 32'h0000;
        IntAddressA <= 10'b0000000000;
        AddressB <= 10'b0000000001;
        IntportAWrEn <= 1'b0;
        portBWrEn <= 1'b0;
        done <= 1'b0;
        temp <=10'b0000000000;
        NoElements <= 10'b0000000000;
        swapFlag <=1'b0;
        fifoWrEn <= 1'b0;
    end
    else
    begin
        case(state)
            IDLE:begin
                if(start & !PSportAWrEn)
                begin
                state<= FETCH;
                NoElements <= PSadress;
                temp <= PSadress;
                IntAddressA <= 0;
                AddressB <= 1;
                IntportAWrEn <= 1'b0;
                portBWrEn <= 1'b0;  
                swapFlag <=0;
                fifoWrEn <= 1'b0; 
                end
            end
            FETCH:begin
                IntportAWrEn <= 1'b0;
                portBWrEn <= 1'b0;
                if(temp != 10'b0000000000)
                begin
                    state <= COMPARE;
                    IntInputA <= portARdData;
                    inputPortB <= portBRdData;
                end
                else   
                begin
                    state <= RENEW;
                    NoElements <= NoElements - 1;
                end
            end
            COMPARE:begin
                temp <= temp - 1;
                if(IntInputA > inputPortB)
                begin
                    state <= SWAP;
                    IntInputA <= inputPortB;
                    inputPortB <= IntInputA;
                    IntportAWrEn <= 1'b1;
                    portBWrEn <= 1'b1; 
                end
                else
                begin
                    state <= WAIT; 
                    IntAddressA <= IntAddressA +1;
                    AddressB <= AddressB +1;
                end
            end
            SWAP:begin
                state <= WAIT;
                 swapFlag <= 1;
                 IntportAWrEn <= 1'b0;
                 portBWrEn <= 1'b0;
                IntAddressA <= IntAddressA +1;
                AddressB <= AddressB +1; 
            end
            WAIT:begin             
                state <= FETCH; // since one clock read latency 
            end
            RENEW:begin
                if(swapFlag)
                begin
                    state <= WAIT;
                    swapFlag <= 0;
                    temp <= NoElements;
                    IntAddressA <= 0;
                    AddressB <= 1;
                end
                else
                begin
                    state <= WRITE;
                    AddressB <= 0;
                    
                end
            end
            WAIT2:begin            
                AddressB <= AddressB + 1;
                state <= WRITE;                 
            end                
            WRITE:begin 
            if(AddressB == PSadress)
            begin
                state<=WAIT2;
                
            end
            else if(AddressB > PSadress)
            begin
                fifoWrEn <= 0;
                done <= 1'b1;
                if(!start & !PSportAWrEn) // in order not to accidentaly write to BRAM after start == 0
                    begin
                        done <= 1'b0;
                        state <= IDLE;
                    end
            end
            else
            begin
            fifoWrEn <= 1;
            AddressB <= AddressB + 1;
            end
            end    
        endcase
    end
end

bram BRAM (
  .clka(clk),    // input wire clka
  .wea(WrEnportA),      // input wire [0 : 0] wea
  .addra(AddressportA),  // input wire [9 : 0] addra
  .dina(inputPortA),    // input wire [31 : 0] dina
  .douta(portARdData),  // output wire [31 : 0] douta
  .clkb(clk),           // input wire clkb
  .enb(start),          // input wire enb
  .web(portBWrEn),      // input wire [0 : 0] web
  .addrb(AddressB),  // input wire [9 : 0] addrb
  .dinb(inputPortB),    // input wire [31 : 0] dinb
  .doutb(portBRdData)  // output wire [31 : 0] doutb
);

fifo outputFIFO (
  .clk(clk),      // input wire clk
  .srst(reset),    // input wire srst
  .din(portBRdData),      // input wire [31 : 0] din
  .wr_en(fifoWrEn),  // input wire wr_en
  .rd_en(PSportARdEn),  // input wire rd_en
  .dout(sortedOut),    // output wire [31 : 0] dout
  .full(),    // output wire full
  .empty()  // output wire empty
);

endmodule 