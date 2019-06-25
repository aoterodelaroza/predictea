#! /usr/bin/octave -q

function p = keane(rho,param)
  ## Calculates the pressure (in GPa) at density rho (g/cm^3) using a
  ## Keane expression. param is [rho0, B0, B0', Binf'] in [g/cm^3,
  ## GPa, ., .].
  
  k0 = param(2);
  k0p = param(3);
  kinfp = param(4);
  x = rho/param(1);
  ## p = k0 * k0p / kinfp^2 * (x.^(-kinfp) - 1) + (k0p / kinfp - 1) * log(x);
  p = k0 * (k0p / kinfp^2 * (x.^(kinfp) - 1) - (k0p / kinfp - 1) * log(x));
  
endfunction
