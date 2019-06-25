#! /usr/bin/octave -q

function p = vinet_rydberg(rho,param)
  ## Calculates the pressure (in GPa) at density rho (g/cm^3) using a
  ## Vinet-Rydberg expression. param is [rho0, B0, B0'] in [g/cm^3,
  ## GPa, .].
  
  x = (param(1)./rho).^(1/3);
  eta = 1.5 * (param(3)-1);

  p = 3 * param(2) ./ x.^2 .* (1-x) .* exp(eta*(1-x));

endfunction
