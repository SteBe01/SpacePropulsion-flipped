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

xlabel('time [ms]');
ylabel('pressure [bar]');


%% error check

figure
hold on
for ii = 38:46
    item = strcat("tracesbar1_data.pbar24", int2str(ii));
    item = eval(item);
    temp = plot(item(:));
    title(ii)
    pause(1)
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
    pause(1)
    delete(temp)
end
close all


%% procedure

clear, clc
close all

tracesbar1_data = load("tracesbar1.mat");

propData.Din = 0.1;
propData.Dout = 0.16;
propData.L = 0.29;
propData.rho = 1762;

At = pi*([28.80; 25.25; 21.81]*1e-3).^2/4; % Throat area [m^2]
At_vec = repmat(At, [9 1]);

P_eff_vect = zeros(27, 1);
rb_vect = zeros(27, 1);
cstar_vec = zeros(27,1);
k = 1;
for ii = 38:46
    item = strcat("tracesbar1_data.pbar24", int2str(ii));
    item = eval(item);
    item = reordering(item);

    [P_eff_vect(k), rb_vect(k)] = pr_evaluation(item(:,1));
    [cstar_vec(k)] = cstar_evaluation(item(:,1), At(1), propData);
    [P_eff_vect(k+1), rb_vect(k+1)] = pr_evaluation(item(:,2));
    [cstar_vec(k+1)] = cstar_evaluation(item(:,2), At(2), propData);
    [P_eff_vect(k+2), rb_vect(k+2)] = pr_evaluation(item(:,3));
    [cstar_vec(k+2)] = cstar_evaluation(item(:,3), At(3), propData);

    k = k + 3;
end
clear ii k item

[a, Inc_a, n, Inc_n, R2] = Uncertainty(P_eff_vect, rb_vect);
cstar = mean(cstar_vec);
cstar_std = std(cstar_vec);

Rel_Inc_a = Inc_a / a;
Rel_Inc_n = Inc_n / n;
Rel_Inc_cstar = cstar_std / cstar;
