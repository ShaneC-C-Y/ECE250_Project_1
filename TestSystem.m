%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test for time diversity system                            %
% create:       11/06/2015                                  %
% last modify:  11/18/2015                                  %
%                                                           %
% several tests can be done here                            %
%   (1) Hamming(7,4) encoding                               %
%       (a) verify prpbability of error on different SNR    %
%   (2) Repetition(n,1) encoding                            %
%       (a) verify probability of error on different SNR    %
%           under fixed n and L                             %
%       (b) compare probability of error on different time  %
%           diversity under fixed n                         %
%       (c) compare probability of error on different       %
%           repetition coding n under fixed L               %
%                                                           %
% Note:                                                     %
%   the input variables to System are for the tests above   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Num = 1e+05;

n_simulation = 10;
SNRrange = [10 100];
SNR = linspace(SNRrange(1),SNRrange(2),n_simulation);

pe_symbol = zeros(1,n_simulation);
pe_theoretical_symbol = zeros(1, n_simulation);
pe_bit = zeros(1,n_simulation);
pe_theoretical_bit = zeros(1,n_simulation);

% L should satsify 
%   L >= n, when using length n codeword
% Hamming74:        n = 7
% Repetition(n):    n = n
L = 2;
n = 2;
    for i = 1 : n_simulation
%         type = 'hamming74';
        type = 'repetition';
        [pe_symbol(i), pe_bit(i)] = System(SNR(i), Num, L, n, type);
%         pe_theoretical_symbol(i) = ?
        % for hamming74 at high SNR region
%         pe_theoretical_symbol(i) = (2^4-1)/SNR(i)^3;
        % for repetition n=2
        pe_theoretical_symbol(i) = 4/SNR(i)^L;
    end

h1 = plot(SNR,pe_symbol, 'o', SNR,pe_bit, '*', SNR,pe_theoretical_symbol);
% h1 = plot(SNR,pe_bit,SNR,pe_theoretical_bit);
legend('simulation', 'simulation, bit error', 'theoritical');
% legend('simulation', 'theoritical');

set(h1, 'linewidth', 2);
% legend('L=3', 'L=5', 'L=7', 'L=9', 'L=11');
xlabel('SNR');
ylabel('probability of error');
title(sprintf('Pe using repetition coding n = %d, L = 2, Num = %d', n, Num));

% figure(2);
% h2 = plot(SNR,pe_theoretical);
% legend('L=3', 'L=5', 'L=7', 'L=9', 'L=11');
% 



