%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      11/04/2015            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

% Ts = 1;
Num = 1000;
L = 2;        % time diversity, still have bug when L = 1
N = 10;        % Tc/Ts

n_simu = 10;
SNRrange = [0.1 5];
SNR = linspace(SNRrange(1),SNRrange(2),n_simu);

prob_error = zeros(5,10);
for L = 2:6
    for i = 1:10
        snr = SNR(i);
        sigma_w = sqrt(1/snr);  % sigma_w^2 = 1/SNR 


bn = bit_generator(Num);

dn = repetition_encoder(bn, L);

xp = interleaver(dn, L, N);

[xR, xI] = QPSK_constellation_mapper(xp);

x = gotocomplex(xR, xI);

[y_nonest, h] = channel(x, sigma_w);

% coherent - repetition
y_est = channel_estimator(y_nonest, h);
yreal = backtoreal(y_est);
y = QPSK_constellation_demapper(yreal);
dnhat = deinterleaver(y, L, N);

% % % non-coherent
% yreal_nonest = backtoreal(y_nonest);
% y2 = QPSK_constellation_demapper(yreal_nonest);
% dnhat2 = deinterleaver(y2, L, N);

% detection
pe1 = detection(dnhat, L, N);
% pe2 = detection(rn, L, N);

prob_error(L-1,i) = pe1;
    
    end
end

plot(SNR,prob_error);
legend('L=2', 'L=3', 'L=4', 'L=5', 'L=6');
xlabel('SNR');
ylabel('probability of error');
title('Pe under coherent detection, Num = 1000, N = 5');



