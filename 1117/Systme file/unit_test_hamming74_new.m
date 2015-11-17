%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      11/06/2015            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

% Ts = 1;
Num = 800;

% should n = L?
L = 3;        % time diversity, still have bug when L = 1
              % detection may have problem on L>2
N = 25;        % Tc/Ts

snr = 5;
sigma_w = sqrt(1/snr);  % sigma_w^2 = 1/SNR 

bn = bit_generator(Num);

dn = Hamming74_encoder(bn);

% xpR, xpI are real
[xpR, xpI] = QPSK_constellation_mapper(dn);

xR = interleaver(xpR, L, N);
xI = interleaver(xpI, L, N);

% x = gotocomplex(xR, xI);

[y_nonestiR, hP] = channel_new(xR, sigma_w, N);
[y_nonestiI, hI] = channel_new(xI, sigma_w, N);

% yR, yI here are real
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

