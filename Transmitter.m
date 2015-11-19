function [xR, xI] = Transmitter(bn, L, N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% take input sequence bn        %
% and output signal xR xI       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dn = Hamming74_encoder(bn);

% xpR, xpI are real
[xpR, xpI] = QPSK_constellation_mapper(dn);

xR = interleaver(xpR, L, N);
xI = interleaver(xpI, L, N);
end

