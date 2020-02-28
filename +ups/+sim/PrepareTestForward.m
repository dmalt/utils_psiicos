function HM = PrepareTestForward(GainSVDTh)
    if nargin < 1
        GainSVDTh = 0;
    end
    HM_path = which('GLowRes.mat');
    file_struct = load(HM_path);
    ChUsed = ups.PickElectaChannels('grad');
    G2d = ups.ReduceToTangentSpace(file_struct.GLowRes.Gain(ChUsed,:));
    if GainSVDTh
        [HM.gain, HM.UP] = ups.ReduceSensorSpace(G2d, GainSVDTh);
    else
        HM.gain = G2d;
        HM.UP = eye(size(G2d, 1));
    end
    HM.path = HM_path;
    HM.svdThresh = GainSVDTh;
    HM.GridLoc = file_struct.GLowRes.GridLoc;
end
