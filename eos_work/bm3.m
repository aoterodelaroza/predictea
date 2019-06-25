#! /usr/bin/octave -q

function p = bm3(rho,param)
  ## Calculates the pressure (in GPa) at density rho (g/cm^3) using a
  ## third-order Birch-Murnaghan expression. param is [rho0, B0, B0']
  ## in [g/cm^3, GPa, .].
  
  x = param(1)./rho;
  p = 3/2 * param(2) * (x.^(-7/3) - x.^(-5/3)) .* (1 + 3/4 * (param(3)-4) * (x.^(-2/3)-1));

endfunction
