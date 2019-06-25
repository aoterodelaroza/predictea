# /usr/bin/octave -q

function [value, isterminal, direction] = funevent(mend,pend,r,y)
  ## Event for the termination of the integration when all mass
  ## has been exhausted. mtotal = total mass in Earth's mass.
  ## y(1) is pressure in GPa. y(2) is mass in Earth's mass.
  ## If value = 0, event is raised. isterminal = 1 means the ODE is
  ## stopped. If direction = -1, locate zeros if the event function is
  ## decreasing

  persistent istriggered = [0 0];

  value = isterminal = direction = zeros(1,2);

  value(1) = mend - y(2);
  isterminal(1) = 1;
  direction(1) = 0;
  
  value(2) = pend - y(1);
  isterminal(2) = 1;
  direction(2) = 0;

  ## side-step matlab-imposed limitation to not trigger terminal
  ## events in the first step
  istri = [value(1) < 0, value(2) > 0];
  if (istri(1))
    if (istriggered(1))
      value(1) = 0;
    endif
  endif
  if (istri(2))
    if (istriggered(2))
      value(2) = 0;
    endif
  endif
  istriggered = istri;

endfunction
