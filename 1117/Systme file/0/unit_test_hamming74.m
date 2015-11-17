%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      11/06/2015            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

% Ts = 1;
Num = 800;

% should n = L?
L = 7;        % time diversity, still have bug when L = 1
              % detection may have problem on L>2
N = 2;        % Tc/Ts

snr = 5;
sigma_w = sqrt(1/snr);  % sigma_w^2 = 1/SNR 

bn = bit_generator(Num);

dn = Hamming74_encoder(bn);

xp = interleaver(dn, L, N);

[xR, xI] = QPSK_constellation_mapper(xp);

x = gotocomplex(xR, xI);

[y_nonesti, h] = channel(x, sigma_w);

y = channel_estimator(y_nonesti, h);

yreal = backtoreal(y);

% coherent - Hamming
yp = QPSK_constellation_demapper(yreal);
dnhat = deinterleaver(yp, L, N);
bnhat = Hamming74_decoder(dnhat);

%bnhat usually longer than bn, so modify
bnhat = bnhat(1:Num);

% % non-coherent
% yp = QPSK_constellation_demapper(y);
% rn = deinterleaver(yp, L, N);

% size have problem!!!
% size(bnhat)
% size(bn)
pe = length(find((bnhat - bn)~=0)) / length(bn);

display(pe,'prbo. error');

