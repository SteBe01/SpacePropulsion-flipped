%%

clear, clc
close all

% restoredefaultpath
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
