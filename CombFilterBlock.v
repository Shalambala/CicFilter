`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Churbanov S. 
// 
// Create Date:    
// Design Name: 
// Module Name:    CombFilterBlock 
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

module CombFilterBlock 
#(
	parameter	M=4,
	parameter	OutDataWidth	=	18
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
	
	reg signed	[OutDataWidth-1:0] sumResult;
	reg	dataValid;
	
	reg	signed	[OutDataWidth-1:0] delData [M-1:0];
	
//================================================================================
//	ASSIGNMENTS

	assign Data_o = sumResult;
	assign DataValid_o = dataValid;

//================================================================================
//	CODING	

	genvar i;
	generate 
		for (i=0; i<M; i=i+1) begin: DelayGen
			always @(posedge Clk_i) begin
				if (i==0) begin
					delData [i] <= Data_i;
				end	else	begin
					delData [i] <= delData[i-1];
				end
			end
		end
	endgenerate 

	always @(posedge Clk_i or posedge Rst_i) begin
		if (Rst_i) begin
			sumResult <= {OutDataWidth{1'b0}};
			dataValid <= 1'b0;
		end else begin
			if (DataNd_i) begin
				sumResult <= Data_i-delData[M-1];
				dataValid <= 1'b1;
			end else begin
				dataValid <= 1'b0;
			end
		end
	end

endmodule