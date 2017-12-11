function [u,v,f] = FindOr(C, g1, g2)
% ---------------------------------------------------------------
% Given cross-spectrum matrix C and two pairs of 
% tangential dipoles (free orientation is presumed) for two 
% different locations on sources find real fixed orientations
% of dipoles in these locations maximizing coherence between
% these two locations. 
% -------------------------------------------------------------
% FORMAT:
%   [u,v,f] = FindOr(C, g1, g2) 
% INPUTS:
%   C        - {N_sensors x N_sensors} cross-spectrum matrix
%   g1       - {N_sensors x 2} two tangential topography vectors  
%              for the first location on cortex 
%   g2       - {N_sensors x 2} two tangential topography vectors
%              for the second location on cortex
% OUTPUTS:
%   u        - {2 x 1} orientation vector for the first location
%   v        - {2 x 1} orientation vector for the second location
%   f        - scalar; coherence between two sites on cortex 
%              delevered by the optiamal oirentations
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    A = g1' * C * g2;
    OPTIONS.TolX = 1e-4;
    OPTIONS.TolFun = 1e-4;
    [phi_max,f] = fminsearch(@(phi) OrientFunctional(phi, A), [0,0]); %, OPTIONS);
    u = [cos(phi_max(1)); sin(phi_max(1))];
    v = [cos(phi_max(2)); sin(phi_max(2))];
end


function f = OrientFunctional(phi, A)
% -------------------------------------------------------
% Compute coherence between two sources
% for a given orientation of topography vectors.
% Orientations are given by u = [cos(phi(1)); sin(phi(1))],
% v = [cos(phi(2)); sin(phi(2))]
% -------------------------------------------------------
% FORMAT:
%   f = OrientFunctional(phi, A)
% INPUTS:
%   phi        - {2 x 1} array with angles of orientation
%                for two dipoles at two different sources
%   A          - {2 x 2} matrix of coherence between two
%                sources for a loose orientation of
%                dipoles
% OUTPUTS:
%   f          - minus coherence on given orientations
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    u = [cos(phi(1)); sin(phi(1))];
    v = [cos(phi(2)); sin(phi(2))];
    f = -(u' * real(A) * v) ^ 2 - (u' * imag(A) * v) ^ 2;
end
