#! /usr/bin/octave -q

function p = murnaghan(rho,param)
  ## Calculates the pressure (in GPa) at density rho (g/cm^3) using a
  ## Murnaghan expression. param is [rho0, B0, B0'] in [g/cm^3,
  ## GPa, .].
  
  p = param(2)/param(3) * ((rho/param(1)).^(param(3)) - 1);

endfunction
