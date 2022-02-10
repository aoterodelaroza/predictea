#! /usr/bin/octave -q

function rho = tfd(p,param)
  ## Calculates the density (g/cm^3) as a function of pressure (GPa)
  ## using the Thomas-Fermi-Dirac EOS. param{1} is the array of A
  ## and param{2} is the array of Z, param{3} are the atomic abundances.

  A = param{1};
  Z = param{2};
  n = param{3};
  if (length(A) != length(Z) || length(A) != length(n))
    error("incompatible array lengths in tfd")
  endif

  num = 0;
  den = 0;
  for i = 1:length(param{1})
    num += n(i) * A(i);

    zeta = (p * 1e10 / 9.524e13).^(1/5) * Z(i)^(-2/3);
    ee = (3/(32*pi^2*Z(i)^2))^(1/3);
    x00 = 1/(8.884e-3 + 0.4988 * sqrt(ee) + 0.52604 * ee);
    alpha = 1/(1.941e-2 - 6.277e-2 * sqrt(ee) + 1.076 * ee);
    phi = 3^(1/3) / 20 + ee / (4 * 3^(1/3));

    b0 = x00 * phi - 1;
    b1 = b0 * alpha + (1 + b0) / phi;

    gam = [1.512e-2 8.955e-2 1.090e-1 5.089 -5.980];
    b2 = 1/(gam(1) + gam(2) * sqrt(ee) + gam(3) * ee + gam(4) * ee^(3/2) + gam(5) * ee^2)^2;

    gam = [2.181e-3 -4.015e-1 1.698 -9.566 9.873];
    b3 = 1/(gam(1) + gam(2) * sqrt(ee) + gam(3) * ee + gam(4) * ee^(3/2) + gam(5) * ee^2)^3;

    gam = [-3.328e-4 5.167e-1 -2.369 1.349e1 -1.427e1];
    b4 = 1/(gam(1) + gam(2) * sqrt(ee) + gam(3) * ee + gam(4) * ee^(3/2) + gam(5) * ee^2)^4;

    gam = [-1.384e-2 -6.520e-1 3.529 -2.095e1 2.264e1];
    b5 = 1/(gam(1) + gam(2) * sqrt(ee) + gam(3) * ee + gam(4) * ee^(3/2) + gam(5) * ee^2)^5;

    x0 = (1 + exp(-alpha*zeta) .* (b0 + b1*zeta + b2*zeta.^2 + b3*zeta.^3 + b4*zeta.^4 + b5*zeta.^5)) ./ (zeta + phi);
    den += n(i) * x0.^3 / Z(i);
  endfor
  rho = num ./ den * 3.886;

endfunction

