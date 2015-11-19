function [pe_symbol, pe_bit] = System(snr, L, n, type)
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
%                                                               %
% note:                                                         %
%   Real and Imag part on different                             %
%   path, so there will be two channel                          %
%   in this system                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fc = 1.8e+09;
W = 10e+03;
Ts = 1/W;

Tc = 3e-03;

% amount of symbol in one Tc
% set an even number, 30
% because QPSK need to deal with even number
N = Tc/Ts;      

% sigma_w^2 = 1/SNR 
sigma_w = sqrt(1/snr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% genertor                          %
% everytime generate one set of bit %
% enough for N*L and should be even %
% because QPSK need even            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error_count = 0;
while error_count <= 100
    bn = bit_generator(N*L);

    [xR, xI] = Transmitter(bn, L, N, n, type);

    [y_R, h_R] = channel(xR, sigma_w, N);
    [y_I, h_I] = channel(xI, sigma_w, N);

    [bnhat, dnhat] = Receiver(y_R, y_I, h_R, h_I, L, N, n, type);

    % who can see both original bit and receiver can tell the probabilty of
    % error (symbol error)
    %%%%%%%%%%%%
    %should be sum????? not length(find((bnhat - bn)~=0))
    %%%%%%%%%%%%%%
    pe_symbol = sum(find((bnhat - bn)~=0)) / length(bnhat);

    % detection in bit error
    pe_bit = detection(dnhat, L, bn);
end
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
