function [ y_est ] = channel_estimator_new(y, h, N)
% matching filter
% Input(y):         row vector, 1 by N*Ns, complex
% Input(N):         parameter
% Input(h):         row vector, 1 bu Ns, complex
% OUtput(y_est):    row vector, 1 by N*Ns, complex

% y = [y[1] y[1+N] ...   h_invmatrix = [h_1  0  0 ...
%      y[2] y[2+N] ...                   0  h_2 0 ...
%       .      .    .                    .   .  .  .
%      y[N] y[N+N] ...]                  0   0  0 h_Ns]

y = reshape(y, N, []);

% y -> (h*/|h|)y
h_hat = conj(h)./abs(h);
h_invmatrix = diag(h_hat);
y_est = y*h_invmatrix;

% make a row vector to be output
y_est = y_est(:).';
end

