#! /usr/bin/octave -q

function p = ap2(rho,param)
  ## Calculates the pressure (in GPa) at density rho (g/cm^3) using an
  ## AP2 expression. param is [rho0, B0, B0', V0, Ze] in 
  ## [g/cm^3, GPa, ., ang^3, .].
  
  afg = 2336.965; ## GPa * ang^5
  ze = param(5);
  v0 = param(4);
  pfg0 = afg * (ze / v0)^(5/3);
  k0p = param(3);
  k0 = param(2);
  c0 = -log(3 * k0 / pfg0);
  c2 = 3/2 * (k0p - 3) - c0;

  x = (param(1)./rho).^(1/3);
  p = 3 * k0 .* (1-x) ./ x.^5 .* exp(c0 * (1-x)) .* (1 + x * c2 .* (1-x));

endfunction
