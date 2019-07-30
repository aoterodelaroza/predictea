#! /usr/bin/octave -q

function mprofile = fill_eos_mprofile(mprofile0,pmax0)
  ## Fill the EOS fields in the mass profile up to a pressure pmax0
  ## (GPa). Returns the mass profile with all EOS prepared for
  ## interpolation.
  
  global __npts__

  mprofile = mprofile0;
  for icomp = 1:mprofile.ncomp
    mprofile.eoscomp{icomp}.rho = zeros(__npts__,mprofile.eoscomp{icomp}.nrange);
    mprofile.eoscomp{icomp}.p   = zeros(__npts__,mprofile.eoscomp{icomp}.nrange);
    mprofile.eoscomp{icomp}.rhomax = zeros(1,mprofile.eoscomp{icomp}.nrange);
    mprofile.eoscomp{icomp}.pmax   = zeros(1,mprofile.eoscomp{icomp}.nrange);

    for iprange = 1:mprofile.eoscomp{icomp}.nrange
      file = sprintf(".eos/%s-%2.2d-%2.2d.who",mprofile.prefix,icomp,iprange);
      mprofile.eoscomp{icomp}.whofile{iprange} = file;

      ## Remake the EOS file if it does not exist or if the pmax is lower than pmax0
      makeeos = 0;
      if (!exist(file,"file"))
        makeeos = 1;
      else
        [eostype eosparam n pmax rhomax] = read_eoswho(file,1);
        if (pmax < pmax0 || n != __npts__ || !(strcmp(mprofile.eoscomp{icomp}.eostype{iprange},eostype)) ||...
            any(mprofile.eoscomp{icomp}.param(iprange,:) != eosparam))
          makeeos = 1;
        endif
      endif
      if (makeeos)
        make_eoswho(mprofile.eoscomp{icomp}.eostype{iprange},mprofile.eoscomp{icomp}.param(iprange,:),...
                    file,pmax0,__npts__);
      endif

      ## Read the EOS file and populate the EOS arrays
      [eostype eosparam n pmax rhomax rho p] = read_eoswho(file,0);
      mprofile.eoscomp{icomp}.rho(1:__npts__,iprange) = rho';
      mprofile.eoscomp{icomp}.p(1:__npts__,iprange) = p';
      mprofile.eoscomp{icomp}.rhomax(iprange) = rhomax;
      mprofile.eoscomp{icomp}.pmax(iprange) = pmax;
    endfor  

    if (isfield(mprofile.eoscomp{icomp},"alpha"))
      mprofile.eoscomp{icomp}.rho(1:__npts__,1:mprofile.eoscomp{icomp}.nrange) *= mprofile.eoscomp{icomp}.alpha;
    endif
  endfor

endfunction
