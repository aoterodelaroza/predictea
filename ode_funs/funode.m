# /usr/bin/octave -q

function y = funode(r,y0,eosinv)
  ## RHS function for the ODE integrator. r(:) is radius in Earth's
  ## radius.  y(1,:) is pressure in GPa. y(2,:) is mass in Earth's mass.
  ## rho = eosinv(p) returns the density rho (g/cm^3) corresponding to
  ## pressure p (GPa). slope is drho/dp at p = 0, for calculating negative 
  ## pressures.

  G = 6.67384e-11; ## m^3 kg-1 s-2 (NIST)
  y1conv = 9.3772278e+11; ## m^3 * kg^-1 * s^-2 * earthmass * g * cm^-3 / earthradius^2 -> GPa / earthradius
  y2conv = 0.043285467; ## earthradius^2 * g/cm^3 -> earthmass / earthradius

  ## handle negative pressures here
  r2 = r.^2;
  if (y0(1) >= 0)
    rho = eosinv(y0(1),y0(2));
  else
    rho = eosinv(0,y0(2));
  endif

  y = zeros(2,length(r));
  y(1) = - G * y0(2) .* rho ./ r2 * y1conv;
  y(2) = 4 * pi * r2 .* rho * y2conv;

endfunction
