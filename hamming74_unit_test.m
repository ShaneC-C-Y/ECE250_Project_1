function pe = hamming74_unit_test(snr, Num)

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

dn = Hamming74_encoder(bn);

% xpR, xpI are real
[xpR, xpI] = QPSK_constellation_mapper(dn);

xR = interleaver(xpR, L, N);
xI = interleaver(xpI, L, N);

[y_nonestiR, hP] = channel(xR, sigma_w, N);
[y_nonestiI, hI] = channel(xI, sigma_w, N);

% yR, yI here is real(with noise)
yR = channel_estimator(y_nonestiR, hP, N);
yI = channel_estimator(y_nonestiI, hI, N);

ypR = deinterleaver(yR, L, N);
ypI = deinterleaver(yI, L, N);

yp = mergesignal(ypR, ypI);

dnhat = QPSK_constellation_demapper(yp);
bnhat = Hamming74_decoder(dnhat);

% bnhat usually longer than bn, so modify
% so now it may shorter (modify on 1108)
bn_compare = bn(1:length(bnhat));

pe = length(find((bnhat - bn_compare)~=0)) / length(bnhat);
end
