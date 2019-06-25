#! /usr/bin/octave -q

function write_table(mprofile,rr,pr,mr,idcomp,idphase,file="")
  ## Output a nicely formatted table with the results of an
  ## integration to file or to stdout if no file is given. mprofile is
  ## the mass profile (used to calculate the density). rr = radii in
  ## R+.  pr = pressure in GPa. mr = mass in M+. idcomp = component
  ## id.  idphase = phase id. file = output file. If not file is
  ## given, use stdout.

  if (isempty(file))
    fid = stdout();
  else
    fid = fopen(file,"w");
  endif
  fprintf(fid,"# R(R+)      M(M+)     p(GPa)   rho(g/cm^3)  phase\n");
  for i = 1:length(rr)
    rho = interp1(mprofile.eoscomp{idcomp(i)}.p(:,idphase(i)),mprofile.eoscomp{idcomp(i)}.rho(:,idphase(i)),pr(i),"extrap");
    fprintf(fid,"%7.4f %11.7f %10.4f %11.7f %s,%s\n",...
            rr(i),mr(i),pr(i),rho,mprofile.eoscomp{idcomp(i)}.name,...
            mprofile.eoscomp{idcomp(i)}.rangename{idphase(i)});
  endfor
  if (!isempty(file))
    fclose(fid);
  endif

endfunction
