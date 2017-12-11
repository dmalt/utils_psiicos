function CS = ConnectivitySimilarity(Pairs1, Pairs2, ChLoc, NOrder, MaxDist, meas)
% -------------------------------------------------------
% Compute distance between two sets of connections.
% Intuitively - the degree of overlapping between sets.
% -------------------------------------------------------
% FORMAT:
%   CS = ConnectivitySimilarity(Pairs1, Pairs2, ChLoc, NOrder, MaxDist, meas)
% INPUTS:
%   Pairs1        -
%   Pairs2
%   ChLoc
%   NOrder
%   MaxDist
%   meas
% OUTPUTS:
%   CS
% ________________________________________________________________________
% Alex Ossadtchii ossadtchi@gmail.com, Dmitrii Altukhov, dm.altukhov@ya.ru

    if nargin < 6
        meas = 'J';
    end

    if(nargin < 5)
        MaxDist = 0.05;
    end;
    if(nargin < 4)
        NOrder = 4;
    end

    % ----- Create a list of neighbours for each location ----- %
    for i=1:size(ChLoc,2)
        DeltaVec  = bsxfun(@minus, ChLoc, ChLoc(:,i));
        Delta = sqrt(sum(DeltaVec .^ 2, 1));
        [DeltaSrt, Key_srt] = sort(Delta);
        Neighs = Key_srt(2:(NOrder + 1));
        Neighs(DeltaSrt(2:(NOrder + 1)) > MaxDist) = [];
        ElNeighbs{i} = Neighs;
    end;
    % ------------------ <><><><><><><><><> ------------------ %

    M1 = AugmentConnMatr(Pairs1, ElNeighbs);
    M2 = AugmentConnMatr(Pairs2, ElNeighbs);

    switch meas
        case 'J' % Jaccard coefficient
            CS = sum(sum(M1 .* M2)) / ( sum(M1(:)) + sum(M2(:)) - sum(sum(M1 .* M2)) );
        case 'O' % Ochiai coefficient
            % CS = sum(sum(M1 .* M2)) / sqrt( sum(M1(:)) * sum(M2(:)) );
            CS = sum(sum(M1.*M2))/sqrt( sum(M1(:).*M1(:))*sum(M2(:).*M2(:)));
        case 'A'
            CS = sum(sum(M1 .* M2)) / (0.5 * ( length(Pairs1) + length(Pairs2) ) );
    end
end


function M = AugmentConnMatr(Pairs, ElNeighbs)
    M = zeros(204, 204);
    for i=1:length(Pairs)
        M(Pairs(i,1),Pairs(i,2)) = 1;
        M(Pairs(i,2),Pairs(i,1)) = 1;
        for n1 = 1:length(ElNeighbs{Pairs(i,1)})
            for n2 = 1:length( ElNeighbs{Pairs(i,2)})
                M(ElNeighbs{Pairs(i,1)}(n1), ElNeighbs{Pairs(i,2)}(n2)) = 1;
            end;
        end;
    end;
end
