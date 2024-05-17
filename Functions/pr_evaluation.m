function [P_eff, rb] = pr_evaluation(vector)
    [maxVal, pos] = max(vector);
    if pos < 0.01*length(vector)
        [maxVal, pos] = max(vector(ceil(0.01*length(vector)):end));
    end
    
    refVal = 0.05 * maxVal; % 0.1 * maxVal; %    %qui la parte incriminata

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
