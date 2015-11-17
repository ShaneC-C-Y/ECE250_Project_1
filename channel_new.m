 function [ y,h ] = channel_new(x1, sigma, N)

% Input:  row vector, complex
% Output: row vector, complex

% change input to column vector
% N bit in one column
% N by Ns
x = reshape(x1, N, []);

sigma_w = sigma;

% generate X~CN(0, 1)
% we should generate only /N channel
Ns = length(x1)/N;
% mag = rand(Ns,1)+0.5;                % magnitude of X, use uniform dist. 0.5~1.5
mag = randn(Ns,1);
h = mag.*exp(1j*2*pi*rand(Ns,1));    % X = |X|e^j*unif(0~2pi)
h_matrix = diag(h);

% generate AWGN(0,sigma_w^2)
w = sigma_w.*exp(1j*2*pi*rand(N,Ns));% complex

% there is Ns block, each block has N bit
% y = h.*x + w;
% y = zeros(N,Ns);

y = x*h_matrix + w;


y = y(:).';
h = torowvector(h);

end

