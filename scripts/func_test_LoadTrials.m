protocolName = 'PSIICOS';
condition = '2';
subjID = '0003_pran';
freqBand = [19,23];
timeRange = [0.4, 0.7];
protocolPath = '~/PSIICOS_osadtchii';
protocolName = 'PSIICOS';

tic
trials = LoadTrials(subjID, condition, freqBand, timeRange, protocolPath);
toc
tic
[CT, key] = CrossSpectralTimeseries(trials.data, true);
toc

tic
G = LoadHeadModel(subjID, condition);
toc