#! /usr/bin/octave -q

function [rr, pr, mr, idcomp, idphase, ierr] = planet_integrate(mprofile,verbose=0)
  ## Integrate the mass profile and predict the radius, pressure,
  ## mass, component, and phase profiles. If verbose, show the trace
  ## of the integrations. If p0in, use that pressure (in GPa) as the
  ## guess for finding the initial presure.
  
  __tolx__ = 1e-4;

  ierr = 1;
  rr = pr = mr = idcomp = idphase = [];
  opt = optimset("TolX",__tolx__);
  fun = @(p0) nthargout(2,@p_integrate,mprofile,p0,verbose)(end);

  ## initial bracketing
  for i = 1:10
    pi = 10^i;
    pend = fun(pi);
    if (pend > 0)
      break
    endif
  endfor

  try
    [p0 pfin info output] = fzero(fun,pi,opt);
  catch
    return
  end_try_catch
  if (info != 1)
    return
  endif
  ierr = 0;
  [rr pr mr idcomp idphase] = p_integrate(mprofile,p0);

endfunction
