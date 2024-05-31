`timescale 1ns / 1ps

module CicFilterTb	();

//================================================================================
//	PARAMETERS

	parameter DataWidth = 14;
	parameter MaxWidth = 32;
	parameter ClkHalfPeriod = 10;
	
	parameter N = 4;
	parameter M = 1;
	parameter [2:0] R = 5;
	
	real Fs = 50;
	real DesiresFreq1InMhz = 5;
	real DesiresFreq2InMhz = 1;
	
	
	real DesiredFreq1PhInc = 0;
	real DesiredFreq2PhInc = 0;
	
	always@ (*) begin
		DesiredFreq1PhInc = DesiresFreq1InMhz/Fs;
		DesiredFreq2PhInc = DesiresFreq2InMhz/Fs;
	end
	
//================================================================================
//	REG/WIRE
	reg clk50;
	reg rst;

	reg signed [13:0] data1;
	reg signed [13:0] data2;
	
	wire signed [13:0] dataIn	=	data1+data2;
	
	real pi = 3.14159265358;
	real phaseSignal1;
	real phaseSignal2;
	real phaseIncSignal1;
	real phaseIncSignal2;
	real signal1;
	real signal2;

	reg [31:0] simCnt;

	wire [31:0] startValue = 32'd10;
	wire [31:0] pNum = 500;
	wire [31:0] stopValue = startValue+pNum-1;

	wire dataVal = (simCnt>=startValue & simCnt<=stopValue)? 1'b1:1'b0;

	wire signed [MaxWidth-1:0] dataOut;
	wire dataOutVal;

	integer inSignal,filteredSignal;
	
//==========================================================================================
//	CLOCKS

	always	#ClkHalfPeriod clk50 = ~clk50;

//==========================================================================================
//	CODING

	initial begin
		clk50 = 1'b1;
		rst = 1'b1;
	#(ClkHalfPeriod*20);
		rst	= 1'b0;
	end	

	always	@(posedge	clk50 or posedge rst)	begin
		if	(rst)	begin
			simCnt	<=	32'd0;
			
		end	else	begin
			simCnt	<=	simCnt+32'd1;
		end
	end

	always @ (posedge clk50 or posedge rst)	begin
		if (!rst)	begin
			phaseSignal1 <= phaseSignal1 + DesiredFreq1PhInc;
			phaseSignal2 <= phaseSignal2 + DesiredFreq2PhInc;
			signal1 <= $sin(2*pi*phaseSignal1);
			signal2 <= $cos(2*pi*phaseSignal2);
			data1 <= 2**11 * signal1;
			data2 <= 2**11 * signal2;
		end	else	begin
			phaseSignal1 <= 0;
			phaseSignal2 <= 0;
		end
	end

	CicFilter
	#(
		.N (N),
		.M (M),
		.InDataWidth	(DataWidth),
		.OutDataWidth	(MaxWidth),
		.DecimCntWidth	(7)
	)
	uut
	(
		.Clk_i			(clk50),
		.Rst_i			(rst),
		.DecimFactor_i	(R),
		.Data_i			(dataIn),
		.DataNd_i		(dataVal),
		.Data_o			(dataOut),
		.DataValid_o	(dataOutVal)
	);
	
	always	@(posedge	clk50)	begin
		if	(simCnt==1)	begin
			inSignal = $fopen("inSignal.txt","w");
		end	else	begin
			if	(dataVal)	begin
				$fwrite(inSignal,"%d\n",   dataIn);
			end	
		end	
	end

	always	@(posedge	clk50)	begin
		if	(simCnt==100)	begin
			filteredSignal = $fopen("filteredSignal.txt","w");
		end	else	begin
			if	(dataOutVal)	begin
				$fwrite(filteredSignal,"%d\n",   dataOut);
			end	
		end	
	end

endmodule



















