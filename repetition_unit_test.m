function [pe, pe1] = repetition_unit_test(snr, Num)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      11/04/2015            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ts = 1;
% Num = 2000;
L = 3;          % time diversity, still have bug when L = 1
N = 25;          % Tc/Ts

% snr = 4;
sigma_w = sqrt(1/snr);  % sigma_w^2 = 1/SNR 

bn = bit_generator(Num);

dn = repetition_encoder(bn, L);

% xpR, xpI are real
[xpR, xpI] = QPSK_constellation_mapper(dn);

xR = interleaver(xpR, L, N);
xI = interleaver(xpI, L, N);

[y_nonestiR, hR] = channel(xR, sigma_w, N);
[y_nonestiI, hI] = channel(xI, sigma_w, N);

% yR, yI here are real
yR = matched_filter(y_nonestiR, hR, L, N);
yI = matched_filter(y_nonestiI, hI, L, N);

% coherent - repition
ypR = deinterleaver(yR, L, N);
ypI = deinterleaver(yI, L, N);

yp = mergesignal(ypR, ypI);

dnhat = QPSK_constellation_demapper(yp);

bnhat = repetition_decoder(dnhat, L);

% bnhat usually longer than bn, so modify
% so now it may shorter 1108

bn_compare = bn(1:length(bnhat));

pe = length(find((bnhat - bn_compare)~=0)) / length(bnhat);

% detection
pe1 = detection(dnhat, L, bn);
end

