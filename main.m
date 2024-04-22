clc; clearvars; close all;

load("tracesbar1.mat");

%% Pbar 2438 - High pressure

P_curve = pbar2438(:,3);

[P_max, max_idx] = max(P_curve);
P_act = 0.05*P_max;

A_idx = max_idx;
while(P_curve(A_idx) > P_act)
    A_idx = A_idx-1;
end

G_idx = max_idx;
while(P_curve(G_idx) > P_act)
    G_idx = G_idx+1;
end

t_act = (G_idx-A_idx);

P_ref = sum(P_curve(A_idx:G_idx))*1e-3/t_act;

plot(P_curve)
xline(G_idx, 'k--')

%% Utility fuctions

function [val, pos] = raisingEdge(curve, value)
    j = 1; % Number of detected edges
    for ii = 1:length(curve)
        
    end
end