function [pe_symbol, pe_bit, n_total_bit] = System_onechannel(snr, L, n, k, type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time diversity system (one channel)                           %
% create:       11/20/2015                                      %
% last modify:  11/22/2015                                      %
%                                                               %
% note:                                                         %
%   a copy from System_twochannel and do some modify            %
%   Real and Imag part on the same path, so there will be only  %
%   one channel in this system                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% put here because the error rate caculator outside while loop need
Num = N*L/(n/k)*2;
assert(mod(Num,1)==0, 'Generated number not a integer');

while error_count_symbol <= 300
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % genertor                                          %
    % everytime we need a 2*N*L bit in interleaver due  %
    % to QPSK will take 2 bit once                      %
    % we should generate N*L/(n/k)*2 bits               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bn = bit_generator(Num);

    [xR, xI] = Transmitter(bn, L, N, n, type);

    [y, h_R] = channel(xR + 1i*xI, snr, N);

    % y_afterfilter here is still complex
    y_afterfilter = matched_filter(y, h_R, N);
    
    % from series to parallels, and back to series
    yp = QPSK_constellation_demapper(real(y_afterfilter), imag(y_afterfilter));
    
    dnhat = deinterleaver(yp, L, N*2);

    bnhat = Decoder(dnhat, n, type);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    assert(length(bn) == length(bnhat),...
        'length bn: %d, is different with length bnhat: %d',...
        length(bn), length(bnhat));
    error_count_symbol = error_count_symbol + length(find(bnhat ~= bn));
    n_run = n_run + 1;
    
    % detection in bit error
    error_count_bit = error_count_bit + detection(dnhat, n, bn);
end
% who can see both original bit and receiver can tell the probabilty of
% error (symbol error)
n_total_bit = n_run*Num;
pe_symbol = error_count_symbol / n_total_bit;
pe_bit = error_count_bit / (n_total_bit*n);

end
