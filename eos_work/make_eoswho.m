#! /usr/bin/octave -q

function [rhomax, pmax] = make_eoswho(eostype,eosparam,file,pmax0,n)
  ## Make the who file for a given EOS (eos) in the pressure 0 to
  ## pmax0 (in GPa) with n points. The created whofile is file. Return
  ## the maximum pressure for interpolation (pmax) in GPa.
  
  ## identify the EOS and prepare the calculation function
  if (!(exist(eostype) == 2))
    error(sprintf("unknown EOS: %s",eostype));
  endif
  fun = @(rho) feval(eostype,rho,eosparam);

  fac = 1.1;
  rhomax = eosparam(1)*fac;
  pmax = fun(rhomax);
  while (pmax < pmax0)
    rhomax = rhomax * fac;
    pmax = fun(rhomax);
  endwhile

  rho = linspace(rhomax,eosparam(1),n);
  p = fun(rho);

  if (!exist(".eos","dir"))
    system("mkdir .eos/");
  endif
  save("-binary",file,"eostype","eosparam","n","pmax","rhomax","rho","p");
  
endfunction
