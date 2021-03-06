function [pe_bit, n_total_bit] = System_twochannel(snr, L, n, k, type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time diversity system (seperate channel)                      %
% create:       11/06/2015                                      %
% last modify:  11/23/2015                                      %
%                                                               %
% you can decide                                                %
%   (1) Hamming (7,4) encoding                                  %
%   (2) Repetition(n,1) encoding                                %
% one of them to run the system                                 %
%                                                               %
% note:                                                         %
%   Real and Imag part on different                             %
%   path, so there will be two channel                          %
%   in this system                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% amount of symbol in one Tc
% set a number dividable by 2 and 7, choosing 42
% because QPSK need to deal with even number and hamming74 code
% with divide sequence by 7
N = 42;      

error_count_bit = 0;
amount_retransmit_bit = 0;
n_run = 0;

% put here because the error rate caculator outside while loop need
Num = 2*N*L*k/n;
assert(mod(Num,1)==0, 'Generated number not a integer');

while error_count_bit <= 500
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % genertor                                          %
    % everytime we need a 2*N*L bit in interleaver due  %
    % to QPSK will take 2 bit once                      %
    % we should generate N*L/(n/k)*2 bits               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bn = bit_generator(Num);

    [xR, xI] = Transmitter(bn, L, N, n, type);

    [y_R, h_R] = channel(xR, snr, N);
    [y_I, h_I] = channel(xI, snr, N);

    [bnhat, retransmit_case] = Receiver_twochannel(y_R, y_I, h_R, h_I, L, N, n, type);

    % here we don't need to compare tie_case, they will retransmit
    if ~isempty(retransmit_case)
        bn(retransmit_case) = [];
        bnhat(retransmit_case) = [];
        amount_retransmit_bit = amount_retransmit_bit +...
            length(retransmit_case);
    end
    error_count_bit = error_count_bit + length(find(bnhat ~= bn));
    n_run = n_run + 1;
end
% who can see both original bit and receiver can tell the probabilty of
% error (symbol error)
n_total_bit = n_run*Num - amount_retransmit_bit;
pe_bit = error_count_bit / (n_total_bit);

end
