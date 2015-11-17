%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      11/06/2015            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

% Ts = 1;
Num = 110;
L = 2;        % time diversity, still have bug when L = 1
              % detection may have problem on L>2
N = 5;        % Tc/Ts

snr = 3;
sigma_w = sqrt(1/snr);  % sigma_w^2 = 1/SNR `

bn = bit_generator(Num);

dn = repetition_encoder(bn, L);

xp = interleaver(dn, L, N);

[xR, xI] = QPSK_constellation_mapper(xp);

x = gotocomplex(xR, xI);

[y_nonest, h] = channel(x, sigma_w);

y_est = channel_estimator(y_nonest, h);

yreal = backtoreal(y_est);
yreal_nonest = backtoreal(y_nonest);

% coherent - repetition
y = QPSK_constellation_demapper(yreal);
dnhat = deinterleaver(y, L, N);

% % non-coherent
y2 = QPSK_constellation_demapper(yreal_nonest);
dnhat2 = deinterleaver(y2, L, N);

% detection for repetition
pe1 = detection(dnhat, L, N);
pe2 = detection(dnhat2, L, N);

display([pe1, pe2], 'prob. error of coherent and non-coherent detection');