%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      11/06/2015            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

% Ts = 1;
Num = 10000;

L = 7;        % time diversity
              % hamming min dis. is 3
N = 25;        % Tc/Ts


n_simu = 10;
SNRrange = [1 10];
snr = linspace(SNRrange(1),SNRrange(2),n_simu);

sigma_w = sqrt(1./snr);  % sigma_w^2 = 1/SNR 

prob_error = zeros(1,n_simu);

for i = 1:n_simu
    bn = bit_generator(Num);

    dn = Hamming74_encoder(bn);

    % xpR, xpI are real
    [xpR, xpI] = QPSK_constellation_mapper(dn);

    xR = interleaver(xpR, L, N);
    xI = interleaver(xpI, L, N);

    [y_nonestiR, hP] = channel_new(xR, sigma_w(i),N);
    [y_nonestiI, hI] = channel_new(xI, sigma_w(i),N);

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
    bn_compare = bn(1:length(bnhat));

    % % non-coherent
    % yp = QPSK_constellation_demapper(y);
    % rn = deinterleaver(yp, L, N);

    pe = length(find((bnhat - bn_compare)~=0)) / length(bnhat);

    prob_error(i) = pe;

end

plot(snr,prob_error);
legend('L=7');
xlabel('SNR');
ylabel('probability of error');
title('Pe using Hamming code (7,4), Num = 10000, N = 25');



