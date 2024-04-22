%%

clear, clc
close all

restoredefaultpath
addpath(genpath("WeBeep\"))
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

    [P_eff_vect(k), rb_vect(k)] = test(item(:,1));
    [P_eff_vect(k+1), rb_vect(k+1)] = test(item(:,2));
    [P_eff_vect(k+2), rb_vect(k+2)] = test(item(:,3));
    k = k + 3;
end
clear ii k item

[a, Inc_a, n, Inc_n, R2] = Uncertainty(P_eff_vect, rb_vect);





%% functions

function [P_eff, rb] = test(vector)
    [maxVal, pos] = max(vector);
    
    refVal = 0.05 * maxVal;

    % evaluation of position A and G
    pos_A = pos;
    while vector(pos_A) > refVal && pos_A <= length(vector)
        pos_A = pos_A - 1;
    end
    pos_G = pos;
    while vector(pos_G) > refVal && pos_G <= length(vector)
        pos_G = pos_G + 1;
    end

    t_act = (pos_G - pos_A) / 1000; % [s]
    I = sum(vector(pos_A:pos_G))/2000;
    P_ref = I/t_act;

    % evaluation of position B and E
    pos_B = pos;
    while vector(pos_B) > P_ref && pos_B <= length(vector)
        pos_B = pos_B - 1;
    end
    pos_E = pos;
    while vector(pos_E) > P_ref && pos_E <= length(vector)
        pos_E = pos_E + 1;
    end

    t_burn = (pos_E - pos_B) / 1000; % [s]

    w = 0.03; % [m]
    rb = w / t_burn;

    P_eff = sum(vector(pos_B:pos_E))/(pos_E-pos_B);
end
