#! /usr/bin/octave -q

## initialize
source("./init.m");

## ## build the mass profile
## mprofile = struct();
## mprofile.prefix = "planet"; ## prefix for the generated files
## mprofile.mtotal = 21.54434690031882; ## in Earth's mass.
## mprofile.ncomp = 1; ## Number of components (in order, from r=0, outwards)
## mprofile.xcomp = []; ## % in mass of each component (1...ncomp-1). Last one is implied.
## mprofile.eoscomp = {eos.h};

## test

## mprofile = struct();
## mprofile.prefix = "planet"; ## prefix for the generated files
## mprofile.mtotal = 3980; ## in Earth's mass.
## mprofile.ncomp = 1; ## Number of components (in order, from r=0, outwards)
## mprofile.xcomp = []; ## % in mass of each component (1...ncomp-1). Last one is implied.
## mprofile.eoscomp = {eos.h};
## mprofile = fill_eos_mprofile(mprofile,1000);
## ## [rr, pr, mr, idcomp, idphase, ierr] = planet_integrate(mprofile,1);
## tic
## [rr, pr, mr, idcomp, idphase, ierr] = planet_integrate(mprofile,1);
## ## [rr pr mr idcomp idphase] = p_integrate(mprofile,100,1);
## write_table(mprofile,rr,pr,mr,idcomp,idphase);
## toc
## exit

## ## Seager plot
## listeos = {eos.h, eos.he, eos.mgsio3, eos.fe};
## listeos = {eos.h};
## 
## for i = 1:length(listeos)
##   mlist = logspace(-1,4,11);
##   printf("## Material: %s\n",listeos{i}.name);
##   printf("## R(R+)    M(M+)        p(0)\n");
##   for im = 1:length(mlist)
## 
##     ## build the mass profile
##     mprofile = struct();
##     mprofile.prefix = "planet"; ## prefix for the generated files
##     mprofile.mtotal = mlist(im); ## in Earth's mass.
##     mprofile.ncomp = 1; ## Number of components (in order, from r=0, outwards)
##     mprofile.xcomp = []; ## % in mass of each component (1...ncomp-1). Last one is implied.
##     mprofile.eoscomp = {listeos{i}};
## 
##     ## populate the EOS arrays in the mass profile
##     mprofile = fill_eos_mprofile(mprofile,1000);
##       
##     ## integrate this planet and find the profile info
##     [rr, pr, mr, idcomp, idphase, ierr] = planet_integrate(mprofile,0);
##     if (ierr > 0)
##       printf("%7s %11.7f %10s\n","n/a",mprofile.mtotal,"n/a");
##       break
##     else
##       printf("%7.4f %11.7f %10.4f\n",rr(end),mr(end),pr(1));
##     endif
##   endfor
##   printf("\n\n");
## endfor

## ## results for Earth
## mprofile = struct();
## mprofile.prefix = "earth"; ## prefix for the generated files
## mprofile.mtotal = 1; ## in Earth's mass.
## mprofile.ncomp = 2; ## Number of components (in order, from r=0, outwards)
## mprofile.xcomp = [0.33]; ## % in mass of each component (1...ncomp-1). Last one is implied.
## mprofile.eoscomp = {eos.fe, eos.mgsio3}; ## component EOS
## mprofile = fill_eos_mprofile(mprofile,1000);
## 
## [rr, pr, mr, idcomp, idphase, ierr] = planet_integrate(mprofile,0);
## write_table(mprofile,rr,pr,mr,idcomp,idphase);

## ## results for Jupiter
## mprofile = struct();
## mprofile.prefix = "jupiter"; ## prefix for the generated files
## mprofile.mtotal = 317; ## in Earth's mass.
## mprofile.ncomp = 2; ## Number of components (in order, from r=0, outwards)
## mprofile.xcomp = [0.10]; ## % in mass of each component (1...ncomp-1). Last one is implied.
## mprofile.eoscomp = {eos.he, eos.h}; ## component EOS
## mprofile = fill_eos_mprofile(mprofile,1000);
## 
## [rr, pr, mr, idcomp, idphase, ierr] = planet_integrate(mprofile,1);
## write_table(mprofile,rr,pr,mr,idcomp,idphase);

## ## results for mystery planet
## mprofile = struct();
## mprofile.prefix = "???"; ## prefix for the generated files
## mprofile.mtotal = 1.25; ## in Earth's mass.
## mprofile.ncomp = 2; ## Number of components (in order, from r=0, outwards)
## mprofile.xcomp = [0.33]; ## % in mass of each component (1...ncomp-1). Last one is implied.
## mprofile.eoscomp = {eos.fe, eos.mgsio3}; ## component EOS
## mprofile = fill_eos_mprofile(mprofile,1000);
## [rr, pr, mr, idcomp, idphase, ierr] = planet_integrate(mprofile,1);
## write_table(mprofile,rr,pr,mr,idcomp,idphase);

## results for ICTEA
for ix = 0:10
  xh2o = ix / 10;
  xfe = 0.33 * (1-xh2o);
  xsi = 1 - xfe - xh2o;

  mprofile = struct();
  mprofile.prefix = "ictea"; ## prefix for the generated files
  mprofile.mtotal = 6.8; ## in Earth's mass.
  mprofile.ncomp = 3; ## Number of components (in order, from r=0, outwards)
  mprofile.xcomp = [xfe, xsi]; ## % in mass of each component (1...ncomp-1). Last one is implied.
  mprofile.eoscomp = {eos.fe9, eos.sic, eos.h2o}; ## component EOS
  mprofile = fill_eos_mprofile(mprofile,1000);

  [rr, pr, mr, idcomp, idphase, ierr] = planet_integrate(mprofile,0);
  write_table(mprofile,rr,pr,mr,idcomp,idphase);
endfor
