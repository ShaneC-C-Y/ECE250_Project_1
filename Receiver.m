function [bnhat, dnhat] = Receiver( y_R, y_I, h_R, h_I, L, N, n, type)
%%%%%%%%%%%%%%%%%
% receiver      %
%%%%%%%%%%%%%%%%%

% y_afterfilter are still complex
y_afterfilterR = matched_filter(y_R, h_R, N);
y_afterfilterI = matched_filter(y_I, h_I, N);

% sufficient statistic is Re{y}
% here also P/S, merge two series together
yp = QPSK_constellation_demapper(real(y_afterfilterR), real(y_afterfilterI));

dnhat = deinterleaver(yp, L, N*2);

bnhat = Decoder(dnhat, n, type);
end

