function [ bnhat ] = Receiver( y_R, y_I, h_R, h_I, L, N)
%%%%%%%%%%%%%%
% re
%%%%%%%%%%%%%%%

% yR, yI here is real(with noise)
y_afterfilterR = matched_filter(y_R, h_R, L, N);
y_afterfilterI = matched_filter(y_I, h_I, L, N);

ypR = deinterleaver(y_afterfilterR, L, N);
ypI = deinterleaver(y_afterfilterI, L, N);

yp = mergesignal(ypR, ypI);

dnhat = QPSK_constellation_demapper(yp);
bnhat = Hamming74_decoder(dnhat);

end

