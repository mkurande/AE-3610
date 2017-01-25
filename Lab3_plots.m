%Number of points for different number of samples recorded
%wave was at 1000 Hz
%sampling rate was at 10 kHz

%data reduction step 2 & 3
samples = [10 50 5 100 200] %sampling rate
numPoints = [4 20 2 40 80] * 2.5

samples = sort(samples)
numPoints = sort(numPoints)

resFreq = 10000 ./ samples
recordingTime = 1 ./ resFreq
numRecordedSamples = 10000 ./ samples

plot(numRecordedSamples, numPoints);
xlabel('Number of Recorded Samples');
ylabel('Number of Points');

figure()

plot(recordingTime, resFreq);
xlabel('Recording Time (s)');
ylabel('Resolution Frequency');

%data reduction step 4 (normal step 5)

samplingRate = [2500 2000 1700 1500 1200 1000 800 675 665 600 500]
peakFreq = [1000 1000 700 500 200 0 200 325 330 200 0]

figure();

plot(samplingRate, peakFreq, '-bo');
xlabel('Sampling Rate (Hz)');
ylabel('Peak Frequency (Hz)');

%step 7 and 8 of data reduction
[singleRun txt raw] = xlsread('Step8_1_1.xls');
singleRun = singleRun(3:end,1:2)
singleRun_ch0 = singleRun(:,1)
singleRun_ch1 = singleRun(:,2)

[avgRun txt raw] = xlsread('Step8_10avg.xls');
avgRun = avgRun(3:end,1:2)
avgRun_ch0 = avgRun(:,1)
avgRun_ch1 = avgRun(:,2)

time = 0:3000 / 1500:3000
time = time(1:end - 1)

figure();
plot(time, singleRun_ch0,'-k', time, singleRun_ch1,'-b');
legend('Single Run - Unfiltered','Single Run - Filtered')
xlabel('Frequency (Hz)');
ylabel('Power (linear-scale)');

figure();
plot(time, avgRun_ch0,'-k', time, avgRun_ch1,'-b');
legend('Avg Run - Unfiltered','Avg Run - Filtered')
xlabel('Frequency (Hz)');
ylabel('Power (linear-scale)');

figure();
powerratio = avgRun_ch1 ./ avgRun_ch0
plot(time, powerratio)
xlabel('Frequency (Hz)')
ylabel('Power Ratio (Filtered/Unfiltered)')
