%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      11/04/2015            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

% Ts = 1;
Num = 1000;
% L = 2;        % time diversity, still have bug when L = 1
N = 25;        % Tc/Ts

n_simu = 10;
SNRrange = [1 10];
SNR = linspace(SNRrange(1),SNRrange(2),n_simu);

prob_error = zeros(5,10);
pe_theoretical = zeros(5,10);
l = 3:2:11;
for j = 1:5
    for i = 1:10
        L = l(j);
        snr = SNR(i);
        sigma_w = sqrt(1/snr);  % sigma_w^2 = 1/SNR 

        bn = bit_generator(Num);

        dn = repetition_encoder(bn, L);

        % xpR, xpI are real
        [xpR, xpI] = QPSK_constellation_mapper(dn);

        xR = interleaver(xpR, L, N);
        xI = interleaver(xpI, L, N);

        [y_nonestiR, hP] = channel_new(xR, sigma_w, N);
        [y_nonestiI, hI] = channel_new(xI, sigma_w, N);

        % yR, yI here are real
        yR = channel_estimator_new(y_nonestiR, hP, N);
        yI = channel_estimator_new(y_nonestiI, hI, N);

        % coherent - repition
        ypR = deinterleaver(yR, L, N);
        ypI = deinterleaver(yI, L, N);

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
%         pe1 = detection(dnhat, L, N);
        % pe2 = detection(rn, L, N);

        prob_error(j,i) = pe;
        pe_theoretical(j,i) = 4*power(snr,-L);


    end
end

h1 = plot(SNR,prob_error);
set(h1, 'linewidth', 4);
legend('L=3', 'L=5', 'L=7', 'L=9', 'L=11');
xlabel('SNR');
ylabel('probability of error');
title('Pe under coherent detection, Num = 10000, N = 25');

% figure(2);
% h2 = plot(SNR,pe_theoretical);
% legend('L=3', 'L=5', 'L=7', 'L=9', 'L=11');
% 



