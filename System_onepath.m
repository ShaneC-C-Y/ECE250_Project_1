function [pe_symbol, pe_bit, n_total_bit] = System_onepath(snr, L, n, k, type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time diversity system                                         %
% create:       11/20/2015                                      %
% last modify:  11/--/2015                                      %
%                                                               %
% note:                                                         %
%   Real and Imag part on the same path, so there will be only  %
%   one channel in this system                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%
% not yet test!!!!!!!!!!!
%%%%%%%%%%%%%%%

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

%     [xR, xI] = Transmitter(bn, L, N, n, type);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dn = Encoder(bn, n, type);
    
    xp = interleaver(dn, L, N*2);
    [xR, xI] = QPSK_constellation_mapper(xp);
    x = v2_mergetworeal(xR,xI);

    [y, h_R] = channel(x, snr, N);

    % y here is still complex(with noise)
    y_afterfilter = v2_channel_estimator(y, h_R, N);
    
    [y_afterfilterR, y_afterfilterI] = v2_backtoreal(y_afterfilter);
    
    yp = QPSK_constellation_demapper(y_afterfilterR, y_afterfilterI);
    
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
