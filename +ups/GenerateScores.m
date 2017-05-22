function [SPC, TPR, PPV] = GenerateScores(Q, Dmax, GridLoc, IND, n_levels, XYZGen, NPI)
% ------------------------------------------------------------------------
% Generate specificity, true positive rate and positive predictive value
% for connectivity estimation algorithm by gradually lowering threshold.
% Usually used for calculation of ROC or Precision-Recall curves
% ------------------------------------------------------------------------
% FORMAT:
%   [SPC, TPR, PPV] = GenerateScores(Q, Dmax, GridLoc, IND, n_levels, XYZGen, NPI)
% INPUTS:
%   Q        - vectorized upper triangle of connectivity matrix on sources
%   Dmax     - float; max distance in m from true location for connection
%              to be considered true detection
%   GridLoc  - {n_sources x 3} matrix of source-space coordinates
%   IND      - {(n_sources ^ 2 - n_sources) / 2 x 2} index mapping array
%              between vectorized upper triangle of matrix and full matrix
%   n_levels - int; number of steps in scores generation
%   XYZGen   - {n_gen x 3} matrix of coordinates of activity generating
%              nodes
%   NPI      - {n_networks x 2}
% OUTPUTS:
%   SPC       - {1 x n_levels}  vector of specificities;
%               SPC(i) = tp / (tp + fn)
%   TPR       - {1 x n_levels}  vector of true positive rates;
%               TPR(i) = tn / (fp + tn)
%   PPV       - {1 x n_levels}  vector of positive predictive values;
%               PPV(i) = tp / (tp + fp);
% ________________________________________________________________________
% Alex Ossadtchii ossadtchi@gmail.com, Dmitrii Altukhov, dm.altukhov@ya.ru

%Dmax = 0.015;
% create binary array indicators for each network from NPI
R1 = GridLoc(IND(:,1),:);
R2 = GridLoc(IND(:,2),:);
k = 1;
for nw = NPI
    i1 = nw * 2 - 1;
    i2 = nw * 2;
    d11 = bsxfun(@minus, R1, XYZGen(i1,:));
    d12 = bsxfun(@minus, R1, XYZGen(i2,:));
    d21 = bsxfun(@minus, R2, XYZGen(i1,:));
    d22 = bsxfun(@minus, R2, XYZGen(i2,:));

    D11 = sqrt(sum(d11 .^ 2, 2));
    D12 = sqrt(sum(d12 .^ 2, 2));
    D21 = sqrt(sum(d21 .^ 2, 2));
    D22 = sqrt(sum(d22 .^ 2, 2));

    Nw(:,k) = ((D11 < Dmax) & (D22 < Dmax)) | ((D12 < Dmax) & (D21 < Dmax));
    k = k + 1;
end;
AllNw = (sum(Nw, 2) > 0);

Qmax = max(Q);
Qmin = min(Q);
dQ = (Qmax - Qmin) / n_levels;
TP = zeros(1, n_levels);
TN = TP;
FP = TP;
FN = TP;
fprintf('Calculating scores ... \n');
fprintf('Threshold level index (Max %d) : ', n_levels);

for i=1:n_levels
    q = Qmax - dQ * i;
    ind = (Q >= q)';
    % ind_c = setdiff(1:length(Q), ind);
    % size(ind)
    TP(i) = double(AllNw)' * double(ind);
    FP(i) = double(~AllNw)' * double(ind);
    TN(i) = double(~AllNw)' * double(~ind);

    FN(i) = AllNw' * double(~ind);
    if i > 1
       for j=0:log10(i - 1)
           fprintf('\b'); % delete previous counter display
       end
    end
    fprintf('%d', i);
end;
fprintf('\nDone\n');
TPR = TP ./ (TP + FN);
SPC = TN ./ (FP + TN);
PPV = TP ./ (TP + FP);

