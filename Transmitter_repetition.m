function [ xR, xI ] = Transmitter_repetition(bn, L, N)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

dn = repetition_encoder(bn, L);

% xpR, xpI are real
[xpR, xpI] = QPSK_constellation_mapper(dn);

xR = interleaver(xpR, L, N);
xI = interleaver(xpI, L, N);

end

