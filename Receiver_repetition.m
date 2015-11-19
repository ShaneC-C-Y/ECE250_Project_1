function [bnhat, dnhat] = Receiver_repetition(y_R, y_I, h_R, h_I, L, N)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% yR, yI here are real
y_afterfilterR = matched_filter(y_R, h_R, L, N);
y_afterfilterI = matched_filter(y_I, h_I, L, N);

% coherent - repition
ypR = deinterleaver(y_afterfilterR, L, N);
ypI = deinterleaver(y_afterfilterI, L, N);

yp = mergesignal(ypR, ypI);

dnhat = QPSK_constellation_demapper(yp);

bnhat = repetition_decoder(dnhat, L);
end

