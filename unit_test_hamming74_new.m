%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      11/06/2015            %
% modify on 11/17 night      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

Num = 200;      % 100 will error!!!

fc = 1.8e+09;
W = 10e+03;
Ts = 1/W;

Tc = 2.5e-03;

% n = L ot n < L
% in (n,k) = (7,4) Hamming code
% we should use L >= 7
L = 7;          % time diversity, still have bug when L = 1
N = Tc/Ts;      % amount of symbol in one Tc

snr = 5;
sigma_w = sqrt(1/snr);  % sigma_w^2 = 1/SNR 

bn = bit_generator(Num);

dn = Hamming74_encoder(bn);

% xpR, xpI are real
[xpR, xpI] = QPSK_constellation_mapper(dn);

xR = interleaver(xpR, L, N);
xI = interleaver(xpI, L, N);

% x = gotocomplex(xR, xI);

[y_nonestiR, hP] = channel(xR, sigma_w, N);
[y_nonestiI, hI] = channel(xI, sigma_w, N);

% yR, yI here is real(with noise)
yR = channel_estimator_new(y_nonestiR, hP, N);
yI = channel_estimator_new(y_nonestiI, hI, N);


% coherent - Hamming
ypR = deinterleaver(yR, L, N);
ypI = deinterleaver(yI, L, N);

yp = mergesignal(ypR, ypI);

dnhat = QPSK_constellation_demapper(yp);
bnhat = Hamming74_decoder(dnhat);

%bnhat usually longer than bn, so modify
% so now it may shorter 1108
bn_compare = bn(1:length(bnhat));

% % non-coherent
% yp = QPSK_constellation_demapper(y);
% rn = deinterleaver(yp, L, N);

pe = length(find((bnhat - bn_compare)~=0)) / length(bnhat);

display(pe,'prbo. error');

