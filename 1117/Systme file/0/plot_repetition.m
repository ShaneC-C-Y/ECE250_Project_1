%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      11/04/2015            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

% Ts = 1;
Num = 10;
% L = 2;        % time diversity, still have bug when L = 1
N = 10;        % Tc/Ts

n_simu = 10;
SNRrange = [5 10];
SNR = linspace(SNRrange(1),SNRrange(2),n_simu);

prob_error = zeros(5,10);
for L = 3:2:11
    for i = 1:10
        snr = SNR(i);
        sigma_w = sqrt(1/snr);  % sigma_w^2 = 1/SNR 

        bn = bit_generator(Num);

        dn = repetition_encoder(bn, L);

        % xpR, xpI are real
        [xpR, xpI] = QPSK_constellation_mapper(dn);

        xR = interleaver(xpR, L, N);
        xI = interleaver(xpI, L, N);

        [y_nonestiR, hP] = channel(xR, sigma_w);
        [y_nonestiI, hI] = channel(xI, sigma_w);

        % yR, yI here are real
        yR = channel_estimator_new(y_nonestiR, hP);
        yI = channel_estimator_new(y_nonestiI, hI);

        % coherent - repition
        ypR = deinterleaver(yR, L, N);
        ypI = deinterleaver(yI, L, N);

        yp = mergesignal(ypR, ypI);

        dnhat = QPSK_constellation_demapper(yp);

        bnhat = repetition_decoder(dnhat, L);
        
        %bnhat usually longer than bn, so modify
        bnhat = bnhat(1:Num);

        pe= length(find((bnhat - bn)~=0)) / length(bn);
        
        % detection
%         pe1 = detection(dnhat, L, N);
        % pe2 = detection(rn, L, N);

        prob_error(L-1,i) = pe;

    end
end

plot(SNR,prob_error);
legend('L=2', 'L=3', 'L=4', 'L=5', 'L=6');
xlabel('SNR');
ylabel('probability of error');
title('Pe under coherent detection, Num = 1000, N = 5');



