function [G_reduced, UP] = ReduceSensorSpace(G, GainSVDTh)
% -------------------------------------------------------
% Perform dimensionality reduction on a leadfield G	 
% -------------------------------------------------------
% FORMAT:
%   [G, UP] = ReduceSensorSpace(G, GainSVDTh) 
% INPUTS:
%   G          - {n_sensors x n_sources * 2} matrix;
%                forward operator
%   GainSVDTh  - scalar; threshold for raw eigenvalues 
% OUTPUTS:
%   G_reduced  - {n_sensors_reduced x n_sources *2} 
%                matrix of reduced forward operator 
%   UP         - {n_sensors_reduced x n_sensors}
%                matrix of transformation between
%                reduced and complete sensors
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    [ug,~,~] = ups.ext.spm_svd(G * G', GainSVDTh);
    UP = ug';
    G_reduced = UP * G;
end
