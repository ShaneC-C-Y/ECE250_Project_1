function [pe_symbol, pe_bit, n_total_bit] = System(snr, L, n, k, type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time diversity system                                         %
% create:       11/06/2015                                      %
% last modify:  11/18/2015                                      %
%                                                               %
% you can decide                                                %
%   (1) Hamming (7,4) encoding                                  %
%   (2) Repetition(n,1) encoding                                %
% one of them to run the system                                 % 
%                                                               %
% pe_symbol is computed by comparing bn and bnhat (Num bits)    %
%   (1) it comes out after decoding (make decision)             %
%   (2) under repetition coding n is even, decision may be      %
%       wrong                                                   %
% pe_bit is computed by comparing bn and dnhat (Num*n bits)     %
%   (1) it works only on repetition coding                      %
%                                                               %
% note:                                                         %
%   Real and Imag part on different                             %
%   path, so there will be two channel                          %
%   in this system                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fc = 1.8e+09;
% W = 10e+03;
% Ts = 1/W;
% 
% Tc = 4.2e-03;

% amount of symbol in one Tc
% set a number dividable by 2 and 7, choosing 42
% because QPSK need to deal with even number and hamming74 code
% with divide sequence by 7
N = 42;      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% genertor                          %
% everytime generate one set of bit %
% enough for N*L and should be even %
% because QPSK need even            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error_count_symbol = 0;
error_count_bit = 0;
n_run = 0;
while error_count_symbol <= 300
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % genertor                                          %
    % everytime we need a N*L bit in interleaver, so    %
    % we should generate 2*N*L / (n/k) bits             %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Num = 2*N*L*k/n;
    if mod(Num,1) ~= 0
        warning('Num has problem')
    end
    bn = bit_generator(Num);

    [xR, xI] = Transmitter(bn, L, N, n, type);

    [y_R, h_R] = channel(xR, snr, N);
    [y_I, h_I] = channel(xI, snr, N);

    [bnhat, dnhat] = Receiver(y_R, y_I, h_R, h_I, L, N, n, type);

    error_count_symbol = error_count_symbol + length(find(bnhat ~= bn));
    n_run = n_run + 1;
    
    % detection in bit error
    error_count_bit = error_count_bit + detection(dnhat, n, bn);
end
% who can see both original bit and receiver can tell the probabilty of
% error (symbol error)
n_total_bit = n_run*N*L;
pe_symbol = error_count_symbol / n_total_bit;
pe_bit = error_count_bit / (n_total_bit*n);


%%%%%%%%%%%%%%%
% fix it later
%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % repetition                %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [xR2, xI2] = Transmitter(bn, L, N, n, 'repetition');
% 
% [y_R2, h_R2] = channel(xR2, sigma_w, N);
% [y_I2, h_I2] = channel(xI2, sigma_w, N);
% 
% [bnhat2, dnhat2] = Receiver(y_R2, y_I2, h_R2, h_I2, L, N, n, 'repetition');
% 
% bn_compare2 = bn(1:length(bnhat2));
% pe2 = length(find((bnhat2 - bn_compare2)~=0)) / length(bnhat2);

end
