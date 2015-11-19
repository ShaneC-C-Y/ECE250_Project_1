function [ y_afterfilter ] = matched_filter(y, h, L, N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% implement matched filter %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define Ns as total number of Tc interval
% Ns = Num/N

% Input(y):         row vector, 1 by N*Ns, complex
% Input(N):         parameter
% Input(h):         row vector, 1 bu Ns, complex
% OUtput:           row vector, 1 by N*Ns, real


% y = [y[1] y[1+N] ...        h_star = [h_1*  0   0 ...
%      y[2] y[2+N] ...                   0   h_2* 0 ...
%       .      .    .                    .    .   .  .
%      y[N] y[N+N] ...]                  0    0   0 h_Ns*]
y = reshape(y, N, []);
h_star = diag(conj(h));

% define h_norm^2(1) as |h_1|^2   + ... + |h_L|^2
%        h_norm^2(2) as |h_L+1|^2 + ... + |h_2L|^2
%           ...
%        h_norm^2(Ns/L) |h_...|^2 + ... + |h_Ns|^2
% and also be placed in diagonal
% h_norm = diag([ h_norm(1) ...  h_norm(1) ... ...    h_norm(Ns/L)]
%                   \_       L    _/             \_  L _/
h_LbyNs = reshape(h, L, []);
h_LbyNs_norm = abs(h_LbyNs);
h_norm_prev = repmat(sqrt(sum(h_LbyNs_norm)), L,1);
h_norm = diag(h_norm_prev(:));

% y -> (h*/|h|)y
y_afterfilter = y*h_star*h_norm;

% sufficient statistic is Re{y}
y_afterfilter = real(y_afterfilter);

% make a row vector to be output
y_afterfilter = y_afterfilter(:)';
end

