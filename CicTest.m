FormatSpec = '%d';

N = 4;
R = 5;
B = 16;
M = 1;

PointsNum = 500;

%Calculating MaxBitWidth 
Bmax = ceil(log2(((R*M)^N)/R)+B);

%Calculating Gain
K = N*20*log10(M);

%Calclating Bit Growth using calculated gain
BitGrowth = ceil(2^(K/20));
BMax = B+BitGrowth;

%--------------------------------------------------------------------------
% Reading Data

ReadInDataId = fopen('inSignal.txt','r');
InDataSignal = fscanf(ReadInDataId,FormatSpec);
fclose(ReadInDataId);

ReadFilteredDataId = fopen('filteredSignal.txt','r');
FilteredData = fscanf(ReadFilteredDataId,FormatSpec);
fclose(ReadFilteredDataId);

%--------------------------------------------------------------------------
%   Calculating FFT
InDataFft = abs(fft(InDataSignal+randn(size(InDataSignal)))/PointsNum);
InDataFftDb = 10*log10(InDataFft);
InDataFftDb = InDataFftDb-max(InDataFftDb);

FilteredDataFft = abs(fft(FilteredData+randn(size(FilteredData)))/PointsNum);
FilteredDataFftDb = 20*log10(FilteredDataFft);
FilteredDataFftDb = FilteredDataFftDb-max(FilteredDataFftDb);

%--------------------------------------------------------------------------
%   Normalize freqs

FbandOrig = 0:1/PointsNum:1-1/PointsNum;
FbandDecim = 0:1/PointsNum*R:1-1/PointsNum*R;

%--------------------------------------------------------------------------
%   Plot Results 
figure('name','In Data Time/Freq', 'Numbertitle', 'off')
subplot(2,1,1)
plot(InDataSignal)
grid on;
grid minor;
title('In Signal');
xlabel('Time');
ylabel('Amp');

subplot(2,1,2)
plot(FilteredData)
grid on;
grid minor;
title('Filtered Data');
xlabel('Time');
ylabel('Amp');

figure('name','Frequency compare', 'Numbertitle', 'off')
subplot(2,1,1)
plot(FbandOrig,InDataFftDb)
grid on;
grid minor;
title('Amplitude Spectrum of In Signal');
xlabel('f (MHz)');
ylabel('Amp');

subplot(2,1,2)
plot(FbandDecim,FilteredDataFftDb)
grid on;
grid minor;
title('Amplitude Spectrum of Filtered Signal');
xlabel('f (MHz)');
ylabel('Amp');






























