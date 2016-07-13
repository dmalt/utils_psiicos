subj_ID = '0019_shev';
condition = '2';
freqBand = [16,25];
tRange = [-0.5, 1];
GainSVDTh = 0.01;
sensors_file = '~/ups/channel_vectorview306.mat';
ChUsed = PickChannels('grad');
ChLoc = ReadChannelLocations(sensors_file, ChUsed);
HM = LoadHeadModel(subj_ID, condition);

left_motor_xyz = [0.02, 0.12, 0.14];
left_motor_ind = FindXYZonGrid(left_motor_xyz, ChLoc');

right_motor_xyz = [0.02, -0.12, 0.14];
right_motor_ind = FindXYZonGrid(right_motor_xyz, ChLoc');
figure;
DrawConnectionsOnSensors([left_motor_ind, right_motor_ind]);

trials_reduced = LoadTrials(subj_ID, condition, freqBand, tRange, GainSVDTh);
trials = RestoreTrDim(trials_reduced.data, HM.UP);

tr_left = squeeze(trials(left_motor_ind,:,:));
tr_right = squeeze(trials(right_motor_ind,:,:));

tr_hilb_left = hilbert(tr_left)';
tr_hilb_right = hilbert(tr_right)';
figure; plot(tr_left(:,1));

conn = mean(tr_hilb_left .* conj(tr_hilb_right), 1);
figure; plot(abs(conn))