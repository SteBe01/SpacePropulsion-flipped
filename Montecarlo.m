clc; clearvars; close all;

rng('default');

% Input
a = 1.727;
sig_a = 0.018;
n = 0.382;
sig_n = 0.00273;
cstar = 1532.9;
sig_cstar = 9.02;

Dt = 25.25*1e-3;    % Throat diameter [m]

pop = 10;   % Population size for sampling
outstep = 100; % Steps for progress monitoring

%%%%%%

At = pi*Dt^2/4; % Throat area [m]

% Population
a_vec = normrnd(a, sig_a, pop, 1);
n_vec = normrnd(n, sig_n, pop, 1);
cstar_vec = normrnd(cstar, sig_cstar, pop, 1);

% Triplets combination
ntot = pop^3;
comb_cstar_vec = repmat(cstar_vec, [pop^2 1]);
comb_n_vec = repmat(repelem(n_vec, pop), [pop 1]);
comb_a_vec = repelem(a_vec, pop^2);
comb_vec = [comb_a_vec comb_n_vec comb_cstar_vec];

% Random shuffling of combinations
order = randperm(ntot);

% Burn times pre-allocation
btimes = zeros(ntot, 1);

for ii = 1:ntot
    idx = order(ii);
    [t, ~] = bariafire(comb_vec(idx,1), comb_vec(idx,2), comb_vec(idx,3), At);
    btimes(ii) = max(t);

    if mod(ii, outstep) == 0
        fprintf("Simulation %d of %d\n", ii, ntot);
    end
end

%% Cumulative analysis
tb_mean = zeros(ntot,1);
tb_std = zeros(ntot,1);

for ii = 1:ntot
    tb_mean(ii) = mean(btimes(1:ii));
    tb_std(ii) = std(btimes(1:ii));
end

figure;
subplot(2,1,1)
plot(tb_mean)
title("Cumulative tb mean");
subplot(2,1,2);
plot(tb_std);
title("Cumulative tb sigma");

% figure;
% subplot(2,1,1)
% histogram(tb_mean)
% title("Cumulative tb mean");
% subplot(2,1,2);
% histogram(tb_std);
% title("Cumulative tb sigma");