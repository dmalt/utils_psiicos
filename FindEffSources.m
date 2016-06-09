function [ans_idx, nw1, nw2, nw3] = FindEffSources(Dmax, R, XYZGen, NPI)
%Dmax = 0.015;
% create binary arrays indicators for each network from NPI 
Nsites = size(R, 1);
IND(Nsites * (Nsites - 1) / 2, 2) = 0; % Memory allocation; faster then zeroes(...) 
s = 1;
for k = 1:Nsites
    for l = k:Nsites
        IND(s,1) = k;
        IND(s,2) = l;
        s = s + 1;
    end
end
R1 = R(IND(:,1),:);
R2 = R(IND(:,2),:);
k = 1;
for nw = NPI
    i1 = nw * 2 - 1;
    i2 = nw * 2;
    d11 = bsxfun(@minus,R1,XYZGen(i1,:));
    d12 = bsxfun(@minus,R1,XYZGen(i2,:));
    d21 = bsxfun(@minus,R2,XYZGen(i1,:));
    d22 = bsxfun(@minus,R2,XYZGen(i2,:));

    D11 = sqrt(sum(d11.^2,2));
    D12 = sqrt(sum(d12.^2,2));
    D21 = sqrt(sum(d21.^2,2));
    D22 = sqrt(sum(d22.^2,2));

    Nw(:,k) = ( (D11 < Dmax) & (D22 < Dmax) ) | ( (D12 < Dmax) & (D21 < Dmax) );
    k = k + 1;
end;
AllNw = (sum(Nw, 2) > 0);
ans_idx_lin = find(AllNw); % We`ve obtained indices that lay near generator coordinates.
ans_idx = IND(ans_idx_lin,:); 
nw1 = IND(find(Nw(:,1)),:);
nw2 = IND(find(Nw(:,2)),:);
nw3 = IND(find(Nw(:,3)),:);

