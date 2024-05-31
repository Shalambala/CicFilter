module CicFilter
#(
	parameter N = 2,	//filter order
	parameter M = 1,	//comb delay
	parameter InDataWidth	=	14,
	parameter OutDataWidth	=	28,
	parameter DecimCntWidth	=	7
)
(
	input Clk_i,
	input Rst_i,
	input [2:0]	DecimFactor_i,
	input [InDataWidth-1:0] Data_i,
	input DataNd_i,
	output [OutDataWidth-1:0] Data_o,
	output DataValid_o
);

//================================================================================
//	PARAMETERS
	localparam	ExtendBitNum	=	OutDataWidth-InDataWidth;
//================================================================================
//	REG/WIRE

	wire	[OutDataWidth-1:0]	adcExtData	=	{{ExtendBitNum{Data_i[InDataWidth-1]}},Data_i};
	
	wire	[OutDataWidth-1:0]	inData	[N-1:0];

	wire	[OutDataWidth-1:0]	intFilteredData	[N-1:0];
	wire	intFilteredDataValid	[N-1:0];
	wire	intDataVal	[N-1:0];

	wire	[OutDataWidth-1:0]	decimIntData;
	wire	decimIntDataValid;

	wire	[OutDataWidth-1:0]	combFilteredData	[N-1:0];
	wire	[OutDataWidth-1:0]	combInData	[N-1:0];
	wire	combDataVal	[N-1:0];
	wire	combFilteredDataVal	[N-1:0];

//================================================================================
//	ASSIGNMENTS

	assign	Data_o	=	combFilteredData[N-1];
	assign	DataValid_o	=	combFilteredDataVal[N-1];

//================================================================================
//	CODING

genvar i,j;
generate 
	for (i=0; i<N; i=i+1)	begin: IntFilterGen
	
		assign	inData	[i]		=	(i==0)?adcExtData:intFilteredData[i-1];
		assign	intDataVal[i]	=	(i==0)?DataNd_i:intFilteredDataValid[i-1];
		
		IntFilterBlock 
		#(	
			.OutDataWidth	(OutDataWidth)
		)
		IntFilterBlock
		(
			.Clk_i			(Clk_i),
			.Rst_i			(Rst_i),
			.Data_i			(inData[i]),
			.DataNd_i		(intDataVal[i]),
			.Data_o			(intFilteredData[i]),
			.DataValid_o	(intFilteredDataValid[i])
		);
	end	
	
	DecimBlock
	#(	
		.OutDataWidth	(OutDataWidth),
		.DecimCntWidth	(DecimCntWidth)
	)
	DecimBlock
	(
		.Clk_i			(Clk_i),
		.Rst_i			(Rst_i),
		.DecimFactor_i	(DecimFactor_i),
		.Data_i			(intFilteredData[N-1]),
		.DataVal_i		(intFilteredDataValid[N-1]),
		.Data_o			(decimIntData),
		.DataVal_o		(decimIntDataValid)
	);
	
	for (j=0; j<N; j=j+1)	begin: CombFilterGen
	
		assign	combInData	[j]	=	(j==0)?decimIntData:combFilteredData[j-1];
		assign	combDataVal	[j]	=	(j==0)?decimIntDataValid:combFilteredDataVal[j-1];
		
		CombFilterBlock 
		#(	
			.M(M),
			.OutDataWidth	(OutDataWidth)
		)
		CombFilterBlock
		(
			.Clk_i			(Clk_i),
			.Rst_i			(Rst_i),
			.Data_i			(combInData[j]),
			.DataNd_i		(combDataVal[j]),
			.Data_o			(combFilteredData[j]),
			.DataValid_o	(combFilteredDataVal[j])
		);
	end
	
endgenerate

endmodule