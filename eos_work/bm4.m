#! /usr/bin/octave -q

function p = bm4(rho,param)
  ## Calculates the pressure (in GPa) at density rho (g/cm^3) using a
  ## fourth-order Birch-Murnaghan expression. param is [rho0, B0, B0', B0'']
  ## in [g/cm^3, GPa, ., GPa^-1].

  x = param(1)./rho;
  B0 = param(2);
  B0p = param(3);
  B0pp = param(4);

  p = 3/2 * B0 * (x.^(-7/3) - x.^(-5/3)) .* (1 + 3/4 * (B0p-4) * (x.^(-2/3)-1) + ...
                                             (3/8) .* (x.^(-2/3)-1).^2 .* (B0*B0pp + B0p*(B0p-7) + 143/9));

endfunction
