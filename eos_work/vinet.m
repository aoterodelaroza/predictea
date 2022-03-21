#! /usr/bin/octave -q

function p = vinet(rho,param)
  ## Calculates the pressure (in GPa) at density rho (g/cm^3) using a
  ## Vinet expression. param is [rho0, B0, B0'] in [g/cm^3, GPa, .].

  x = param(1)./rho;
  p = 3 * param(2) * x.^(-2/3) .* (1 - x.^(1/3)) .* exp(3/2 * (param(3)-1) * (1 - x.^(1/3)));

endfunction
