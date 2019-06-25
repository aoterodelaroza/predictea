#! /usr/bin/octave -q

function [eostype, eosparam, n, pmax, rhomax, rho, p] = read_eoswho(file,onlypmax)
  ## Read the EOS from a who file. Return the four variables read.
  ## If onlypmax is true, read and return only the pmax.

  pmax = rhomax = 0;
  rho = p = [];

  if (exist(file,"file"))
    if (onlypmax)
      load("-binary",file,"eostype","eosparam","n","pmax","rhomax");
    else
      load("-binary",file,"eostype","eosparam","n","pmax","rhomax","rho","p");
    endif
  endif

endfunction
