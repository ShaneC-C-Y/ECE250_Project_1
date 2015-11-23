%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test for time diversity system                            %
% create:       11/06/2015                                  %
% last modify:  11/23/2015                                  %
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SNR simulation point                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_simulation = 50;
SNRrange = [50 100];
SNR = linspace(SNRrange(1),SNRrange(2),n_simulation);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L should satsify                      %
%   L >= n, when using length n codeword%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hamming74:        n = 7
% L = 7;
% n = 7;
% k = 4;

% Repetition(n):    n = n
L = 2;
n = 2;
k = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pe_bit = zeros(1,n_simulation);
pe_bit2 = zeros(1,n_simulation);
pe_theoretical = zeros(1,n_simulation);
n_total_bit = 0;

for i = 1 : n_simulation
%         type = 'hamming74';
    display(SNR(i));
    type = 'repetition';

    [pe_bit(i), ~] = System_onechannel(SNR(i), L, n, k, type);
    [pe_bit2(i), n_total_bit] = System_twochannel(SNR(i), L, n, k, type);

    % for hamming74 at high SNR region
%         pe_theoretical_symbol(i) = (2^4-1)/SNR(i)^3;

    % for repetition n=2 at high SNR region
    pe_theoretical(i) = 4/SNR(i)^L;
end
    
h1 = plot(SNR, pe_bit,SNR, pe_bit2, SNR, pe_theoretical);
legend('one channel', 'two channel', 'theoretical value');

set(h1, 'linewidth', 2);
xlabel('SNR');
ylabel('probability of error');

title(sprintf('Pe using repetition coding n = %d, L = 2, totalNum = %d',...
    n, n_total_bit));



