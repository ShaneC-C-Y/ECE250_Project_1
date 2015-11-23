function [bnhat, retransmit_case] = Receiver( y, h, L, N, n, type)
%%%%%%%%%%%%%%%%%
% receiver      %
%%%%%%%%%%%%%%%%%

% y_afterfilter are still complex
y_afterfilter = matched_filter(y, h, N);

% from series to parallels, and back to series
yp = QPSK_constellation_demapper(real(y_afterfilter), imag(y_afterfilter));
    
dnhat = deinterleaver(yp, L, N*2);

[bnhat, retransmit_case] = Decoder(dnhat, n, type);
end

