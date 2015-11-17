%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      11/04/2015            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

% Ts = 1;
Num = 20;
L = 2;         % time diversity, still have bug when L = 1
N = 2;        % Tc/Ts

snr = 4;
sigma_w = sqrt(1/snr);  % sigma_w^2 = 1/SNR 

bn = bit_generator(Num);

dn = repetition_encoder(bn, L);

% xpR, xpI are real
[xpR, xpI] = QPSK_constellation_mapper(dn);

xR = interleaver(xpR, L, N);
xI = interleaver(xpI, L, N);

[y_nonestiR, hR] = channel_new(xR, sigma_w, N);
[y_nonestiI, hI] = channel_new(xI, sigma_w, N);

% yR, yI here are real
yR = channel_estimator_new(y_nonestiR, hR, N);
yI = channel_estimator_new(y_nonestiI, hI, N);

% coherent - repition
ypR = deinterleaver(yR, L, N);
ypI = deinterleaver(yI, L, N);
% ypR = deinterleaver(y_nonestiR, L, N);
% ypI = deinterleaver(y_nonestiI, L, N);

yp = mergesignal(ypR, ypI);

dnhat = QPSK_constellation_demapper(yp);

bnhat = repetition_decoder(dnhat, L);

%bnhat usually longer than bn, so modify
% so now it may shorter 1108

bn_compare = bn(1:length(bnhat));

% % non-coherent
% yp = QPSK_constellation_demapper(y);
% rn = deinterleaver(yp, L, N);

pe = length(find((bnhat - bn_compare)~=0)) / length(bnhat);

% detection
pe1 = detection(dnhat, L, N);
% pe2 = detection(rn, L, N);
display(pe, 'pe');
display(pe1, 'pe_detection');

