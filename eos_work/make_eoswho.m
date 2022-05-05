#! /usr/bin/octave -q

function [rhomax, pmax] = make_eoswho(eostype,eosparam,tfdparam,file,pmax0,n)
  ## Make the who file for a given EOS (eos) in the pressure 0 to
  ## pmax0 (in GPa) with n points. The created whofile is file. Return
  ## the maximum pressure for interpolation (pmax) in GPa.

  ## identify the EOS and prepare the calculation function
  if (!(exist(eostype) == 2))
    error(sprintf("unknown EOS: %s",eostype));
  endif

  if (strcmp(lower(eostype),"tfd"))
    pmax = pmax0;
    p = linspace(0,pmax,n);
    rho = tfd(p,tfdparam);
    rhomax = rho(end);
  else
    fun = @(rho) feval(eostype,rho,eosparam);

    fac = 1.1;
    rhomax = eosparam(1)*fac;
    pmax = fun(rhomax);
    pold = -Inf;
    while (pmax < pmax0)
      rhomax = rhomax * fac;
      pold = pmax;
      pmax = fun(rhomax);
      if (pmax < pold)
        pmax = pold;
        rhomax = rhomax / fac;
        break
      endif
    endwhile

    rho = linspace(rhomax,eosparam(1),n);
    p = fun(rho);
  endif

  if (!exist(".eos","dir"))
    system("mkdir .eos/");
  endif
  save("-binary",file,"eostype","eosparam","n","pmax","rhomax","rho","p");

endfunction
