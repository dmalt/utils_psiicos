function [SPC, TPR, PPV] = GenerateROC(Q, Dmax, R, IND, N, XYZGen, NPI)
% ------------------------------------------------------------------------
% Generate specificity, true positive rate and positive predictive value
% for connectivity estimation algorithm by gradually lowering threshold.
% Usually used for calculation of ROC or Precision-Recall curves
% ------------------------------------------------------------------------
% FORMAT:
%   [SPC, TPR, PPV] = GenerateScores(Q, Dmax, R, IND, N, XYZGen, NPI) 
% INPUTS:
%   Q        - vectorized upper triangle of connectivity matrix on sources
%   Dmax     - float; max distance in m from true location for connection
%              to be considered true detection
%   R        - {n_sources x 3} matrix of source-space coordinates
%   IND      - {(n_sources ^ 2 - n_sources) / 2 x 2} index mapping array
%              between vectorized upper triangle of matrix and full matrix 
%   N        - int; number of steps in scores generation
%   XYZGen
%   NPI
% OUTPUTS:
%   SPC       - {1 x N}  vector of specificities;
%               SPC(i) = tp / (tp + fn)
%   TPR       - {1 x N}  vector of true positive rates;
%               TPR(i) = tn / (fp + tn)

%   PPV       - {1 x N}  vector of positive predictive values;
%               PPV(i) = tp / (tp + fp);

% ________________________________________________________________________
% Alex Ossadtchii ossadtchi@gmail.com, Dmitrii Altukhov, dm.altukhov@ya.ru

%Dmax = 0.015;
% create binary array indicators for each network from NPI 
R1 = R(IND(:,1),:);
R2 = R(IND(:,2),:);
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
% size(AllNw)

Qmax = max(Q);
Qmin = min(Q);
dQ = (Qmax - Qmin) / N;
TP = zeros(1, N);
TN = TP;
FP = TP;
FN = TP;
fprintf('Calculating ROC curve ... \n');
fprintf('Threshold level index (Max %d) : ', N); 

for i=1:N
    q = Qmax - dQ * i;
    ind = find(Q >= q);
    ind_c = setdiff(1:length(Q), ind);
    % size(ind)
    TP(i) = sum(AllNw(ind));
    FP(i) = sum(~AllNw(ind));
    TN(i) = sum(~AllNw(ind_c));
    FN(i) = sum(AllNw(ind_c));
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

