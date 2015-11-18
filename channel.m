 function [ y,h ] = channel(x1, sigma_w, N)

% Input(x1):        row vector, 1 by N*Ns, complex
% Input(sigma, N):  parameter
% Output(y):        row vector, 1 bu N*Ns, complex
% OUtput(h):        row vector, 1 by Ns

% change x1 to N by Ns matrix
% N bit in one column, in one Tc
% [ x[1] x[1+N] ...
%   x[2] x[2+N] ...
%   x[3] x[3+N] ...
%     .     .    .
%     .     .    .
%   x[N] x[N+N] ...]
%
x = reshape(x1, N, []);
Ns = length(x1)/N;

% generate H~CN(0,1)
% total Ns columns, so there are Ns channel response h in H
% each column will get the same h
mag = raylrnd(1/sqrt(2),Ns,1);      % the function in matlab is
                                    % different from the note 
                                    % with a scale sqrt(2)
h = mag.*exp(1j*2*pi*rand(Ns,1));   % H = |H|e^j*unif(0~2pi)

% generate AWGN(0,sigma_w^2)
w = sigma_w.*exp(1j*2*pi*rand(N,Ns));% complex

% use diagonal matrix to multiple
% so each column just multiple a scale 
h_matrix = diag(h);
y = x*h_matrix + w;

% sufficient statistic is Re{y}
y = real(y);

% make y and h to a row vector to be output
y = y(:)';
h = torowvector(h);

end

