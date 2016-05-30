function [CT, key] = CrossSpectralTimeseries(trials, isInducedOnly)
% -------------------------------------------------------------------
% Compute cross-spectrum timeseries. 
% If isInducedOnly = true, compute induced activity; otherwise - total
% --------------------------------------------------------------------
% FORMAT:
%   [CT, key] = CrossSpectralTimeseries(trials, isInducedOnly) 
% INPUTS:
%   trials        - {nChannels x nTimes x nTrials} matrix
%                   of trials on sensors
%   isInducedOnly  - boolean flag. If true, substract ERP
%                   from each trial before going to 
%                   frequency domain; default = false
% OUTPUTS:
%   CT             - {nChannels ^ 2 x nTimes} matrix of 
%                   cross-spectrum timeseries on sensors
%   key           - 
% ________________________________________________________________________
% Alex Ossadtchii ossadtchi@gmail.com, Dmitrii Altukhov dm.altukhov@ya.ru
  Trials = trials;
  if(nargin == 1)
      isInducedOnly = false;
  end;

  [nCh, nSamp, nTrials] = size(Trials);
  % --- compute and substract evoked response --- %
  if(isInducedOnly)
      ERP = mean(Trials, 3);
      Trials = bsxfun(@minus, Trials, ERP);
  end;
  % ----------------------------------------------%

  % ------------------- hilbert-transform trials ----------------- %
  Xfft = fft(Trials, [], 2);
  h  = zeros(1, nSamp); % nx1 for nonempty. 0x0 for empty.
  if nSamp > 0 && 2 * fix(nSamp / 2) == nSamp
    % even and nonempty
    h([1 nSamp / 2 + 1]) = 1;
    h(2:nSamp / 2) = 2;
  elseif nSamp > 0
    % odd and nonempty
    h(1) = 1;
    h(2:(nSamp + 1) / 2) = 2;
  end
  HF = repmat(h, [nCh, 1, nTrials]);
  XH = ifft(Xfft .* HF, [], 2);
  Xph = XH; %./(abs(XH)+0.0001*mean(abs(XH(:))));
  % -------------------------------------------------------------- %
  clear XH;


  XphConj = conj(Xph);
  k = 1;
  KEY = reshape(1:nCh * nCh, nCh, nCh);
  % we will take the diagonal as well
  data = zeros(nCh ^ 2, nSamp);
  fprintf('Calculating vectorised form of the cross spectral matrix... \n');
  fprintf('Reference sensor (max %d): ', nCh); 

  for i = 1:nCh
      mn = (mean( bsxfun(@times, (Xph(1:nCh,:,:)), XphConj(i,:,:)), 3));
      data(k:k + nCh - 1,:) = mn;
      key(k:k + nCh - 1) = KEY(1:nCh, i);
      k = k + nCh;
      % -------- print counter --------- %
      if i > 1
        for j=0:log10(i - 1)
            fprintf('\b'); 
        end
       end
       fprintf('%d', i);
      % -------------------------------- %
  end;
  CT = data;
  fprintf('\n');