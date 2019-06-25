#! /usr/bin/octave -q

function [rr, pr, mr, idcomp, idphase] = p_integrate(mprofile,p0,verbose=0)
  ## Integrate the dp/dr and dm/dr differential equations from the
  ## center of the planet (r=0) outwards. Uses the mass profile given
  ## by mprofile and initial pressure at the center equal to p0 (in
  ## GPa). On output, returnthe pressure (pr), mass (mr), and density
  ## (rhor) profiles as a function of radius (r). If verbose, write
  ## debug messages to the output.

  global __npts__

  ## constants
  __reltol__ = 1e-8;

  ## tracking variable initialization
  rcur = 0.00001; ## current radius (initial = 63.7 meters)
  mcur = 0; ## current mass (for current material)
  pcur = p0; ## current pressure

  ## prepare output arrays
  rr = pr = mr = idcomp = idphase = [];

  ## some index initialization
  updatem = 1;
  ie = mfinal = 0;
  idxm = 0;
  nstep = 0;

  if (verbose)
    printf("Start p_integrate with p0 = %.4f\n",p0);
  endif

  ## main loop; terminate when the mass condition is triggered in the ODE
  ## and we run out of mass
  while (!(ie == 1 && mfinal))
    nstep++;

    ## update the material and pressure variables
    if (updatem) 
      idxm++;
      mspent = 0;
      if (idxm < mprofile.ncomp)
        mtotal = mprofile.xcomp(idxm) * mprofile.mtotal;
      else
        mtotal = (1-sum(mprofile.xcomp)) * mprofile.mtotal;
        mfinal = 1;
      endif
      idxp = max(find(mprofile.eoscomp{idxm}.prange < pcur));
      pchange = mprofile.eoscomp{idxm}.prange(idxp);
    elseif (updatep)
      if (idxp == 1)
        error("want to decrease idxp but idxp is already equal to 1")
      endif
      idxp--;
      pchange = mprofile.eoscomp{idxm}.prange(idxp);
    endif

    ## extend the pressure range of this EOS, if necessary
    if (pcur > mprofile.eoscomp{idxm}.pmax(idxp))
      ## make a new EOS file
      make_eoswho(mprofile.eoscomp{idxm}.eostype{idxp},mprofile.eoscomp{idxm}.param(idxp,:),...
                  mprofile.eoscomp{idxm}.whofile{idxp},10*pcur,__npts__);
      ## Read the EOS file and populate the EOS arrays
      [eostype eosparam n pmax rhomax rho_ p_] = read_eoswho(mprofile.eoscomp{idxm}.whofile{idxp},0);
      mprofile.eoscomp{idxm}.rho(1:__npts__,idxp) = rho_';
      mprofile.eoscomp{idxm}.p(1:__npts__,idxp) = p_';
      mprofile.eoscomp{idxm}.rhomax(idxp) = rhomax;
      mprofile.eoscomp{idxm}.pmax(idxp) = pmax;
    endif

    ## calculate the mass and pressure at which we need to stop the integration
    mtarget = mcur + (mtotal - mspent);
    ptarget = pchange;

    ## prepare the integration functions and set the events to m = mtarget or p = ptarget
    einv = @(p,m) interp1(mprofile.eoscomp{idxm}.p(:,idxp),mprofile.eoscomp{idxm}.rho(:,idxp),p,"extrap");
    fun = @(r,y0) funode(r,y0,einv);
    fevn = @(r,y0) funevent(mtarget,ptarget,r,y0);

    ## zero out the persistent variable inside
    funevent(Inf,-Inf,0,[0 0]);

    ## run the ODE integration
    if (verbose)
      printf("- Integrating, step %d\n",nstep);
      printf("  material (%d) = %s | phase (%d) = %s\n",idxm,mprofile.eoscomp{idxm}.name,idxp,mprofile.eoscomp{idxm}.rangename{idxp});
      printf("  rcur = %.6f Erad | pcur = %.6f GPa | mcur = %.6f Emass\n",rcur,pcur,mcur);
      printf("  ptarget = %.6f GPa | mtarget = %.6f Emass\n",ptarget,mtarget);
    endif
    warning ("off", "integrate_adaptive:unexpected_termination", "local");
    opt = odeset("Events",fevn,"RelTol",__reltol__);
    [r,y,re,ye,ie] = ode45(fun, [rcur,Inf], [pcur mcur], opt);

    ## Handle the case when there have been more than one event. This
    ## happens because the ode_event_handler skips termination
    ## requests in the first step to maintain matlab
    ## compatibility. Luckily, octave still performs
    ## interpolation. This rolls the state back to the first event.
    ## See the persistent variable inside the funevent.
    if (length(ie) > 1)
      ie = ie(1);
      idx = lookup(r,re(1)) + 1;
      r = resize(r,idx,1);
      y = resize(y,idx,2);
      r(idx) = re(1);
      y(idx,:) = ye(1,:);
    endif

    ## Handle the case when both events go off at the same time;
    ## perform the interpolation by hand. This may be applied even
    ## if only one event went off, but it gives the same result anyway.
    if (y(end,1) < ptarget && rows(y) > 1)
      rnew = r(end-1) + (ptarget - y(end-1,1)) * (r(end) - r(end-1)) / (y(end,1) - y(end-1,1));
      ynew = y(end-1,:) + (ptarget - y(end-1,1)) .* (y(end,:) - y(end-1,:)) ./ (y(end,1) - y(end-1,1));
      r(end) = rnew;
      y(end,:) = ynew;
    endif
    if (y(end,2) > mtarget && rows(y) > 1)
      rnew = r(end-1) + (mtarget - y(end-1,2)) * (r(end) - r(end-1)) / (y(end,2) - y(end-1,2));
      ynew = y(end-1,:) + (mtarget - y(end-1,2)) .* (y(end,:) - y(end-1,:)) ./ (y(end,2) - y(end-1,2));
      r(end) = rnew;
      y(end,:) = ynew;
    endif

    ## add to the output variables
    ## rr = [rr(1:end-1); r];
    ## pr = [pr(1:end-1); y(:,1)];
    ## mr = [mr(1:end-1); y(:,2)];
    ## idcomp = [idcomp(1:end-1); zeros(length(r),1) + idxm];
    ## idphase = [idphase(1:end-1); zeros(length(r),1) + idxp];
    rr = [rr; r];
    pr = [pr; y(:,1)];
    mr = [mr; y(:,2)];
    idcomp = [idcomp; zeros(length(r),1) + idxm];
    idphase = [idphase; zeros(length(r),1) + idxp];

    ## output message 
    if (verbose)
      printf("  rfin = %.6f Erad | pfin = %.6f GPa | mfin = %.6f Emass\n",r(end),y(end,1),y(end,2));
    endif

    ## update the current and target variables
    updatem = updatep = 0;
    if (ie == 2)
      ## phase change reached; update pressure range next pass and
      ## update the amount of spent mass for the current component
      updatep = 1;
      mspent = mspent + (y(end,2) - mcur);
    elseif (ie == 1)
      ## material change; update both the material and the pressure
      ## range next pass. If all the mass has been spent, exit.
      updatem = 1;
    else
      error("no target mass or pressure reached")
    endif
    rcur = r(end);
    mcur = y(end,2);
    pcur = y(end,1);
  endwhile 
  if (verbose)
    printf("\n");
  endif

endfunction
