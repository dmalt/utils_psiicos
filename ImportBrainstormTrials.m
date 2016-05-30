function [CT] = ...
    ImportBrainstormTrials(subjID, condition, freqBand,...
                           timeRange, protocolPath, isInducedOnly)
 % -------------------------------------------------------------------------
 % PrepRealData: Calculate band-pass filtered cross-spectrum  and reduced
 % forward model matrices for subject subjID
 % -------------------------------------------------------------------------
 % FORMAT:
 %   [conData, G2dLRU] = PrepRealData(subjID) 
 % INPUTS:
 %   subjID         - string; subject name (should be in Brainstorm protocol)  
 %   freqBand       - {2 x 1} 
 %   isInducedOnly  - boolean; if true calc induced activity
 %   timeRange      - 
 %   protocolName   - string;
 %   protocolPath   - string; 
 % OUTPUTS:
 %   conData        - structure
 % ________________________________________________________________________
 % Alex Ossadtchii ossadtchi@gmail.com, Dmitrii Altukhov, dm.altukhov@ya.ru
if exist('A', 'file')
    disp('Hi');
else
    
    trials = LoadTrials(subjID, condition, freqBand, timeRange, protocolPath);
    % -------- reject bad trials ------------ %
    P = sum(sum(abs(trials.data), 1), 2);
    Pm = median(squeeze(P));
    ind = find(P > 2 * Pm | P < 0.5 * Pm);
    trials.data(:,:, ind) = [];
    % --------------------------------------- %
    fprintf('Computing cross-spectral matrix ....' ); 
    % -------- compute CT ------------ %
    CT = CrossSpectralTimeseries(trials.data, isInducedOnly);
    CT.condition = condition;
    CT.freqBand = freqBand;
    CT.timeRange = timeRange;
    CT.subjID = subjID;
        
    % conData.CrossSpec = reshape(mean(conData.CrossSpecTime,2),nCh,nCh);
    fprintf('-> Done\n' ); 
    % ------------------------------------------- % 
end