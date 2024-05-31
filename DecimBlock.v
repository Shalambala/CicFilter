`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Churbanov S. 
// 
// Create Date:    
// Design Name: 
// Module Name:    DecimBlock 
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

module DecimBlock
#(	
	parameter OutDataWidth = 18,
	parameter DecimCntWidth = 7
)
(
	input Clk_i,
	input Rst_i,
	input [2:0]	DecimFactor_i,
	input [OutDataWidth-1:0] Data_i,
	input DataVal_i,
	output [OutDataWidth-1:0] Data_o,
	output DataVal_o
);

//================================================================================
//	REG/WIRE

	reg [DecimCntWidth-1:0] decimCnt;

	reg [2:0] decimFactor;

//================================================================================
//	ASSIGNMENTS

	assign Data_o = Data_i;
	assign DataVal_o = DataVal_i? (decimCnt == 0):1'b0;
	
//================================================================================
//	CODING

	always	@(posedge Clk_i or posedge Rst_i)	begin
		if	(Rst_i) begin
			decimFactor <= 3'd1;
		end else begin
			if (DecimFactor_i <= 3'd1)	begin
				decimFactor <= 3'd1;
			end else begin
				decimFactor <= DecimFactor_i;
			end
		end
	end

	always @(posedge Clk_i or posedge Rst_i) begin
		if (Rst_i) begin
			decimCnt <= {DecimCntWidth{1'b0}};
		end else begin
			if (DataVal_i) begin
				if (decimCnt == decimFactor-1) begin
					decimCnt <= {DecimCntWidth{1'b0}};
				end else begin
					decimCnt <= decimCnt+7'd1;
				end
			end else begin
				decimCnt <= {DecimCntWidth{1'b0}};
			end
		end
	end

endmodule
