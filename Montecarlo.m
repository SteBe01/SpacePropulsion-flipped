clc; clearvars; close all;

%rng('default');
addpath('WeBeep');

% Input
a = 1.727;
sig_a = 0.018402;
n = 0.3821;
sig_n = 0.00273;
cstar = 1522.5;
sig_cstar = 8.9588;
PT = 27;

Dt = 25.25*1e-3;    % Throat diameter [m] DA VARIARE PER VEDERE I 3 RISULTATI

pop = 50;   % Population size for sampling
outstep = pop^3 /10; % Steps for progress monitoring

%%%%%%

At = pi*Dt^2/4; % Throat area [m]

% Population
a_vec = a + sig_a*trnd(PT, pop, 1); %(a-sqrt(12)/2*sig_a) + sqrt(12)*sig_a*rand(pop,1); %normrnd(a, sig_a, pop, 1);
n_vec = n + sig_n*trnd(PT, pop, 1); %(n-sqrt(12)/2*sig_n) + sqrt(12)*sig_n*rand(pop,1); %normrnd(n, sig_n, pop, 1);
cstar_vec = (cstar-sqrt(12)/2*sig_cstar) + sqrt(12)*sig_cstar*rand(pop,1); %normrnd(cstar, sig_cstar, pop, 1);

% Triplets combination
ntot = pop^3;
comb_cstar_vec = repmat(cstar_vec, [pop^2 1]);
comb_n_vec = repmat(repelem(n_vec, pop), [pop 1]);
comb_a_vec = repelem(a_vec, pop^2);
comb_vec = [comb_a_vec comb_n_vec comb_cstar_vec];

% Random shuffling of combinations
order = randperm(ntot); %1:ntot; %

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

% a_min = a - sig_a;
% a_max = a + sig_a;
% 
% n_min = n - sig_n;
% n_max = n + sig_n;
% 
% cstar_min = cstar - sig_cstar;
% cstar_max = cstar + sig_cstar;
% 
% [t_min, ~] = bariafire(a_max, n_max, cstar_max, At);
% [t_max, ~] = bariafire(a_min, n_min, cstar_min, At);
% [t_med, ~] = bariafire(a    , n    , cstar    , At);
% t_min = t_min(end)
% t_max = t_max(end)
% t_med = t_med(end)

%% Cumulative analysis
tb_mean = zeros(ntot,1);
tb_std = zeros(ntot,1);
tb_std_rel = zeros(ntot,1);

for ii = 1:ntot
    tb_mean(ii) = mean(btimes(1:ii));
    tb_std(ii) = std(btimes(1:ii));
    tb_std_rel(ii) = tb_std(ii) / tb_mean(ii);
end

% convergence statement:

frac = 0.3; % fraction of Mean Value, Uncertainty to be analyzed when verifying convergence of the cumulative series

nstart = floor((1-frac)*ntot); 
std_last_tb_mean = std(tb_mean(nstart:end));
std_last_tb_std = std(tb_std(nstart:end));

rel_std_last_tb_mean = std_last_tb_mean / mean(tb_mean(nstart:end));
rel_std_last_tb_std = std_last_tb_std / mean(tb_std(nstart:end));

if rel_std_last_tb_mean < 0.01 && rel_std_last_tb_std < 0.01

    disp('Convergence is reached!!');

else

    disp('Convergence was not reached :(');

end

figure;
subplot(3,1,1)
plot(tb_mean)
xlabel('N_{iteration}')
ylabel('t_b Mean Value')
title("Cumulative tb mean");
subplot(3,1,2);
plot(tb_std);
xlabel('N_{iteration}');
ylabel('t_b Uncertainty');
title("Cumulative tb sigma");

subplot(3,1,3);
plot(tb_std_rel);
xlabel('N_{iteration}');
ylabel('t_b Relative Uncertainty');
title("Cumulative tb relative sigma");

figure(2);
subplot(2,1,1)
histogram(tb_mean)
title("Cumulative tb mean");
subplot(2,1,2);
histogram(tb_std);
title("Cumulative tb sigma");