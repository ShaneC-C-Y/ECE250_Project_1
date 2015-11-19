function [pe, pe1] = repetition_unit_test(snr, Num)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      11/04/2015            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ts = 1;
% Num = 2000;
L = 3;          % time diversity, still have bug when L = 1
N = 25;          % Tc/Ts

% snr = 4;
sigma_w = sqrt(1/snr);  % sigma_w^2 = 1/SNR 

bn = bit_generator(Num);



[y_nonestiR, hR] = channel(xR, sigma_w, N);
[y_nonestiI, hI] = channel(xI, sigma_w, N);



% bnhat usually longer than bn, so modify
% so now it may shorter 1108



% detection
pe1 = detection(dnhat, L, bn);
end

