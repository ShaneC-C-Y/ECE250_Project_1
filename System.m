function [pe, pe2, pe_detection] = System(snr, Num)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time diversity                        %
% use Hamming (7,4) encoding            %
% Real and Imag part on different path  %
%      11/06/2015                       %
% modify on 11/17 night                 %
% change this to a function(snr, Num)   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Num = 200;     % 100 will error!!!
                % it is better to take a number 
                % dividalbe by 2*4*N
fc = 1.8e+09;
W = 10e+03;
Ts = 1/W;

Tc = 2.5e-03;

% n = L ot n < L
% in (n,k) = (7,4) Hamming code
% we should use L >= 7
L = 7;          % time diversity, still have bug when L = 1
N = Tc/Ts;      % amount of symbol in one Tc

sigma_w = sqrt(1/snr);  % sigma_w^2 = 1/SNR 

bn = bit_generator(Num);

[xR, xI] = Transmitter(bn, L, N);
[xR2, xI2] = Transmitter_repetition(bn, L, N);

[y_R, h_R] = channel(xR, sigma_w, N);
[y_I, h_I] = channel(xI, sigma_w, N);

[y_R2, h_R2] = channel(xR2, sigma_w, N);
[y_I2, h_I2] = channel(xI2, sigma_w, N);

bnhat = Receiver(y_R, y_I, h_R, h_I, L, N);
[bnhat2, dnhat2] = Receiver_repetition(y_R2, y_I2, h_R2, h_I2, L, N);

% detection
pe_detection = detection(dnhat2, L, bn);

% how can see both original bit and receiver can tell the probabilty of
% error
bn_compare = bn(1:length(bnhat));
pe = length(find((bnhat - bn_compare)~=0)) / length(bnhat);

bn_compare2 = bn(1:length(bnhat2));
pe2 = length(find((bnhat2 - bn_compare2)~=0)) / length(bnhat2);

end
