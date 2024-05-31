`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Churbanov S. 
// 
// Create Date:    
// Design Name: 
// Module Name:    IntFilterBlock 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// 
// 
//////////////////////////////////////////////////////////////////////////////////

module IntFilterBlock 
#(	
	parameter OutDataWidth = 18
)
(
	input Clk_i,
	input Rst_i,
	input [OutDataWidth-1:0] Data_i,
	input DataNd_i,
	output [OutDataWidth-1:0] Data_o,
	output DataValid_o
);

//================================================================================
//	REG/WIRE

	reg [OutDataWidth-1:0] outAcc;
	reg outVal;

//================================================================================
//	ASSIGNMENTS
	
	assign Data_o = outAcc;
	assign DataValid_o = outVal;

//================================================================================
//	CODING
	
	always @(posedge Clk_i or posedge Rst_i) begin
		if (Rst_i) begin
			outAcc <= {OutDataWidth{1'b0}};
		end else begin
			if (DataNd_i) begin
				outAcc <= outAcc+Data_i;
				outVal <= 1'b1;
			end else begin
				outAcc <= {OutDataWidth{1'b0}};
				outVal <= 1'b0;
			end 
		end
	end
	
endmodule