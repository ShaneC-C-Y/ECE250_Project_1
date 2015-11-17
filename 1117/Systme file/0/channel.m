function [ y,h ] = channel(x1, sigma)

% Input:  row vector, complex
% Output: row vector, complex

% change input to column vector
x = conj(x1');

sigma_w = sigma;

% generate X~CN(0, 1)
% we should generate only /N channel
N = length(x1);
mag = rand(N,1)+0.5;                % magnitude of X, use uniform dist. 0.5~1.5
h = mag.*exp(1j*2*pi*rand(N,1));    % X = |X|e^j*unif(0~2pi)

% generate AWGN(0,sigma_w^2)
w = sigma_w.*exp(1j*2*pi*rand(N,1));% complex

y = h.*x + w;

% because torowvector function transpose twice, no error there
y = torowvector(y);
h = torowvector(h);

end

