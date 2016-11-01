function PlotViews(obj, opacity, linewidth, m_radius)
% -------------------------------------------------------
% Plot 3 views of the brain
% -------------------------------------------------------
% FORMAT:
%   format 
% INPUTS:
%   inputs        -
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	if nargin < 2
		opacity = 0.6;
	end

	if nargin < 3
		linewidth = 2;
	end

	if nargin < 4 
		m_radius = 0.002;
	end

	subplot(1,3,1)
	light_handle = obj.Plot(opacity, linewidth, m_radius);
	view(0,0);
	camlight(light_handle, 'left');


	subplot(1,3,2)
	obj.Plot(opacity, linewidth, m_radius);

	subplot(1,3,3)
	light_handle = obj.Plot(opacity, linewidth, m_radius);
	view(180,0)
	camlight(light_handle, 'right');
