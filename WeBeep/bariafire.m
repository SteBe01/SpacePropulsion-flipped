function [t , p , AA] = bariafire( a , n , cstar, At )
%
% function [t , p] = bariafire( a , n , cstar,  At )
%
% INPUT: 
% a     : pre-exponential factor Vieille (mm/s/bar^n)
% n     : exponent Vieille
% cstar : characteristic velocity, m/s
% At    : throat area, m^2
%
% OUTPUT:
% t: time vector, s
% p: pressure trace, Pa
%

%%%%%%%%%%%%%%%%%%%%
%Motor geometry
Din = 0.10; %m, internal grain diameter
Dout= 0.16; %m, initial internal diameter
L   = 0.29; %m, grain length
rhop= 1762; %kg/m3, prop density
dt  = 0.01; %s, time discretization
%%%%%%%%%%%%%%%%%%%%

web   = (Dout - Din) ./ 2;

%Conversion to SI
SIa = a .* 0.001 ./ (100000.^n);

%Index result vectors
idx = 1;

while web > 0
  % Internal area
  Rint     = Dout ./ 2 - web;
  Abcenter = 2 .* pi .* Rint .* L;

  % Side area
  Abside   = pi .* ( Dout.^2 ./ 4 - Rint .^ 2 );

  % Total area
  AA( idx ) = Abcenter + 2 * Abside;
  Ab = AA( idx );
  
  % Pressure
  p( idx ) = (SIa .* rhop .* Ab ./ At .* cstar ).^(1/(1-n));

  %Advancement time step
  Rb = SIa .* p( idx ) .^ n;
  burned = Rb .* dt;
  web = web - burned;
  L = L - burned * 2;
  t( idx ) = dt .* (idx - 1);
  idx = idx + 1;
end

return

