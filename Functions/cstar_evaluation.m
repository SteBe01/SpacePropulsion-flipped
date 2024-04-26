function cstar = cstar_evaluation(Pcurve, At, propdata)

    Din = propdata.Din;
    Dout = propdata.Dout;
    L = propdata.L;
    rho = propdata.rho;

    Mp = pi*L*rho*(Dout^2-Din^2)/4;    

    [maxVal, pos] = max(Pcurve);
    if pos < 0.01*length(Pcurve)
        [maxVal, pos] = max(Pcurve(ceil(0.01*length(Pcurve)):end));
    end

    refVal = 0.05 * maxVal;
     % evaluation of position A and G
    pos_A = pos;
    while Pcurve(pos_A) > refVal && pos_A <= length(Pcurve)
        pos_A = pos_A - 1;
    end
    pos_G = pos;
    while Pcurve(pos_G) > refVal && pos_G <= length(Pcurve)
        pos_G = pos_G + 1;
    end

    t_act = (pos_G - pos_A) / 1000; % [s]
    I = sum(Pcurve(pos_A:pos_G))*1e5;
    cstar = I*At/(Mp*1e3);
end