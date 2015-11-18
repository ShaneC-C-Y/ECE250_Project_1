function pe = v2_hamming74_unit_test(snr, Num)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time diversity                        %
% use Hamming (7,4) encoding            %
% Real and Imag part on different path  %
% try to use only one path
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

dn = Hamming74_encoder(bn);

% xp is complex
[xpR, xpI] = QPSK_constellation_mapper(dn);
xp = v2_mergetworeal(xpR,xpI);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% here is problem
% codeword length 7 after QPSK left only 3 and a half
% is not good
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = interleaver(xp, L, N);

[y_nonesti, h] = channel(x, sigma_w, N);

% y here is still complex(with noise)
y = v2_channel_estimator(y_nonesti, h, N);

yp_temp = deinterleaver(y, L, N);

% because QPSK_demapper could only read real sequence
% so we need to seperate complex into two real for it
yp = v2_backtoreal(yp_temp);

dnhat = QPSK_constellation_demapper(yp);
bnhat = Hamming74_decoder(dnhat);

%bnhat usually longer than bn, so modify
% so now it may shorter (modify on 1108)
bn_compare = bn(1:length(bnhat));

pe = length(find((bnhat - bn_compare)~=0)) / length(bnhat);
end
