%%

clear, clc
close all

restoredefaultpath
addpath(genpath("WeBeep\"))
addpath(genpath("Functions\"))
% 9 traces for 9 different mixes


%% plot

tracesbar1_data = load("tracesbar1.mat");

figure
hold on, grid on
for ii = 38:46
    item = strcat("tracesbar1_data.pbar24", int2str(ii));
    item = eval(item);
    plot(item)

    [maxVal1, pos1] = max(item(:,1));
    [maxVal2, pos2] = max(item(:,2));
    [maxVal3, pos3] = max(item(:,3));
end


%% error check

figure
hold on
for ii = 38:46
    item = strcat("tracesbar1_data.pbar24", int2str(ii));
    item = eval(item);
    temp = plot(item(:));
    title(ii)
    pause(0.5)
    delete(temp)
end
close all

figure
hold on
for ii = 38:46
    item = strcat("tracesbar1_data.pbar24", int2str(ii));
    item = eval(item);
    item = reordering(item);
    temp = plot(item(:));
    title(ii)
    pause(0.5)
    delete(temp)
end
close all


%% procedure

clear, clc
close all

tracesbar1_data = load("tracesbar1.mat");

P_eff_vect = zeros(9, 3);
rb_vect = zeros(9, 3);
k = 0;
for ii = 38:46
    k = k + 1;

    item = strcat("tracesbar1_data.pbar24", int2str(ii));
    item = eval(item);
    item = reordering(item);

    [P_eff_vect(k,1), rb_vect(k,1)] = pr_evaluation(item(:,1));
    [P_eff_vect(k,2), rb_vect(k,2)] = pr_evaluation(item(:,2));
    [P_eff_vect(k,3), rb_vect(k,3)] = pr_evaluation(item(:,3));
end
clear ii k item

[lowP.a, lowP.Inc_a, lowP.n, lowP.Inc_n, lowP.R2] = Uncertainty(P_eff_vect(:,1), rb_vect(:,1));
[mediumP.a, mediumP.Inc_a, mediumP.n, mediumP.Inc_n, mediumP.R2] = Uncertainty(P_eff_vect(:,2), rb_vect(:,2));
[highP.a, highP.Inc_a, highP.n, highP.Inc_n, highP.R2] = Uncertainty(P_eff_vect(:,3), rb_vect(:,3));
