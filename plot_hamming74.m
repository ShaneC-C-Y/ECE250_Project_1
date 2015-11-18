%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time diversity                        %
% use Hamming (7,4) encoding            %
% Real and Imag part on different path  %
% plot different snr                    %
%      11/06/2015                       %
% modify on 11/17 night                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_simu = 30;        % simulation amount
SNRrange = [1 10];
snr = linspace(SNRrange(1),SNRrange(2),n_simu);

Num = 30000;

prob_error = zeros(1,n_simu);

for i = 1:n_simu
    pe = hamming74_unit_test(snr(i), Num);
    prob_error(i) = pe;
end

plot(snr,prob_error);
legend('L=7');
xlabel('SNR');
ylabel('probability of error');
title('Pe using Hamming code (7,4), Num = 30000, N = 25');



