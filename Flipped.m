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

P_eff_vect = zeros(1, 27);
rb_vect = zeros(1, 27);
k = 1;
for ii = 38:46
    item = strcat("tracesbar1_data.pbar24", int2str(ii));
    item = eval(item);
    item = reordering(item);

    [P_eff_vect(k), rb_vect(k)] = pr_evaluation(item(:,1));
    [P_eff_vect(k+1), rb_vect(k+1)] = pr_evaluation(item(:,2));
    [P_eff_vect(k+2), rb_vect(k+2)] = pr_evaluation(item(:,3));
    k = k + 3;
end
clear ii k item

[a, Inc_a, n, Inc_n, R2] = Uncertainty(P_eff_vect, rb_vect);
