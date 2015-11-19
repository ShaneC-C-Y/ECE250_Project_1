%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      11/04/2015               %
% 11/18/2015                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ts = 1;
Num = 100000;

n_simu = 10;
SNRrange = [6 15];
SNR = linspace(SNRrange(1),SNRrange(2),n_simu);

pe_hamming = zeros(1,10);
pe_repetition = zeros(1,10);
prob_de = zeros(1,10);
pe_theoretical = zeros(1,10);

l = 2;
    for i = 1:10
        snr2 = SNR(i);
        sigma_w = sqrt(1/snr2);  % sigma_w^2 = 1/SNR 
        
%         prob_error(j,i) = pe;
        [pe_hamming, pe_repetition, prob_de(i)] = System(snr2,Num);
        pe_theoretical(i) = 4*power(snr2,-l);
        

    end

h1 = plot(SNR,prob_de,SNR,pe_theoretical);
set(h1, 'linewidth', 4);
% legend('L=3', 'L=5', 'L=7', 'L=9', 'L=11');
legend('test', 'theo');
xlabel('SNR');
ylabel('probability of error');
title('Pe under coherent detection, Num = 10000, N = 25');

% figure(2);
% h2 = plot(SNR,pe_theoretical);
% legend('L=3', 'L=5', 'L=7', 'L=9', 'L=11');
% 



