#! /usr/bin/octave -q

function eoslib = eos_library()
  ## Create and populate the EOS library object.
  
  eoslib = struct();

  ##xx## EOS for hydrogen, experimental 300 K isotherm, up to ~130 GPa.
  ## Loubeyre, P. et al. Nature, 383 (1996), 702. 
  ## X-ray diffraction and equation of state of hydrogen at megabar pressures. 
  eoslib.h = struct();
  eoslib.h.name = "Hydrogen";
  eoslib.h.nrange = 1;
  eoslib.h.rangename = {"H"};
  eoslib.h.prange = [-Inf Inf];
  eoslib.h.eostype = {
                      "vinet",...
  };
  eoslib.h.param = [
                    0.0792624 0.162 6.813
  ];

  ##xx## EOS for helium
  ## P. Loubeyre et al., Phys. Rev. Lett. 71 (1993) 2272
  ## Equation of state and phase diagram of solid 4He from single-crystal x-ray diffraction over a large P-T domain
  eoslib.he = struct();
  eoslib.he.name = "Helium";
  eoslib.he.nrange = 1;
  eoslib.he.rangename = {"He"};
  eoslib.he.prange = [-Inf Inf];
  eoslib.he.eostype = {
                       "vinet",...
  };
  eoslib.he.param = [
                    0.2917348 0.225 7.35
  ];

  ##xx## EOS for ice VII
  ## Frank et al. Geochim. Cosmo. Acta 68 (2004) 2781.
  ## Constraining the equation of state of fluid H2O to 80 GPa using the melting curve,bulk modulus, and thermal expansivity of Ice VI
  eoslib.h2o = struct();
  eoslib.h2o.name = "Water"; ## name of the material
  eoslib.h2o.nrange = 1; ## number of pressure ranges
  eoslib.h2o.rangename = {"VII"}; ## name of the ranges
  eoslib.h2o.prange = [-Inf Inf]; ## pressure ranges in GPa
  eoslib.h2o.eostype = { ## types of EOSs
                        "bm3",... ## ice VII
  };
  eoslib.h2o.param = [ ## EOS parameters
                       1.45284516 21.1 4.4 0.0
  ]; 

  ##xx## EOS for SiC
  ## Hysteresis and bonding reconstruction in the pressure-induced B3–B1 phase transition of 3C-SiC
  eoslib.sic = struct();
  eoslib.sic.name = "SiC"; ## name of the material
  eoslib.sic.nrange = 1; ## number of pressure ranges
  eoslib.sic.rangename = {"B3"}; ## name of the ranges
  eoslib.sic.prange = [-Inf Inf]; ## pressure ranges in GPa
  eoslib.sic.eostype = { ## types of EOSs
                        "vinet",... ## SiC
  };
  eoslib.sic.param = [ ## EOS parameters
                       3.214934847198981 227 5.57
  ]; 

  ##xx## EOS for iron
  ## Dorogokupets et al., Sci. Rep. 7 (2017) 41863
  ## Thermodynamics and Equations of State of Iron to 350 GPa and 6000 K
  eoslib.fe = struct();
  eoslib.fe.name = "Iron"; ## name of the material
  eoslib.fe.nrange = 2; ## number of pressure ranges
  eoslib.fe.rangename = {"bcc-Fe (alpha)","hcp-Fe (epsilon)"}; ## name of the ranges
  eoslib.fe.prange = [-Inf 16 Inf]; ## pressure ranges in GPa
  eoslib.fe.eostype = { ## types of EOSs
                        "vinet_rydberg",... ## bcc-Fe (alpha)
                        "vinet_rydberg",... ## hcp-Fe (epsilon)
  };
  eoslib.fe.param = [ ## EOS parameters
                      7.874365 164.0 5.50 ## bcc-Fe (alpha), Vinet-Rydberg EOS, (rho0, B0, B0') in (g/cm^3, GPa, .)
                      8.191419 148.0 5.86 ## hcp-Fe (epsilon), Vinet-Rydberg EOS, (rho0, B0, B0') in (g/cm^3, GPa, .)
  ]; 

  ##xx## EOS for iron, with a 0.9 coefficient
  ## Dorogokupets et al., Sci. Rep. 7 (2017) 41863
  ## Thermodynamics and Equations of State of Iron to 350 GPa and 6000 K
  eoslib.fe9 = struct();
  eoslib.fe9.name = "Iron-0.9"; ## name of the material
  eoslib.fe9.nrange = 2; ## number of pressure ranges
  eoslib.fe9.rangename = {"bcc-Fe (alpha) 90%","hcp-Fe (epsilon) 90%"}; ## name of the ranges
  eoslib.fe9.prange = [-Inf 16 Inf]; ## pressure ranges in GPa
  eoslib.fe9.eostype = { ## types of EOSs
                        "vinet_rydberg",... ## bcc-Fe (alpha)
                        "vinet_rydberg",... ## hcp-Fe (epsilon)
  };
  eoslib.fe9.param = [ ## EOS parameters
                      7.874365 164.0 5.50 ## bcc-Fe (alpha), Vinet-Rydberg EOS, (rho0, B0, B0') in (g/cm^3, GPa, .)
                      8.191419 148.0 5.86 ## hcp-Fe (epsilon), Vinet-Rydberg EOS, (rho0, B0, B0') in (g/cm^3, GPa, .)
  ]; 
  eoslib.fe9.alpha = 0.9; ## prefactor for the density(p) curve. Scales the density.

  ##xx## EOS for iron

  ##xx## EOS for MgSiO3, perovskite and post-perovskite
  ## Perovskite:
  ## Tange et al., J. Geophys. Res. 117 (2012) B06201
  ## P-V-T equation of state of MgSiO3 perovskite based on the MgO pressure scale: A comprehensive reference for mineralogy of the lower mantle
  ## Post-perovskite (incl. transition at ~119 GPa):
  ## Sakai et al., Sci. Rep. 6 (2016) 22652.
  ## Experimental and theoretical thermal equations of state of MgSiO3 post-perovskite at multi-megabar pressures
  eoslib.mgsio3 = struct();
  eoslib.mgsio3.name = "MgSiO3"; ## name of the material
  eoslib.mgsio3.nrange = 2; ## number of pressure ranges
  eoslib.mgsio3.rangename = {"Pv","PPv"}; ## name of the ranges
  eoslib.mgsio3.prange = [-Inf 119 Inf]; ## pressure ranges in GPa
  eoslib.mgsio3.eostype = { ## types of EOSs
                        "bm3",... ## perovskite (Pv)
                        "keane",... ## post-perovskite (PPv)
  };
  eoslib.mgsio3.param = [ ## EOS parameters
                          4.1065779 256.7 4.09 0.0 ## perovskite
                          4.0594020 203.0 5.35 2.19 ## post-perovskite
  ]; 

  ##########

  ##xx## EOS for iron (Paco, ref?)
  eoslib.fe_paco = struct();
  eoslib.fe_paco.name = "Iron"; ## name of the material
  eoslib.fe_paco.nrange = 2; ## number of pressure ranges
  eoslib.fe_paco.rangename = {"liq","eps"}; ## name of the ranges
  eoslib.fe_paco.prange = [-Inf 310 Inf]; ## pressure ranges in GPa (must be -Inf -> Inf)
  eoslib.fe_paco.eostype = { ## types of EOSs
                             "murnaghan",... ## bcc-Fe (alpha)
                             "murnaghan",... ## hcp-Fe (epsilon)
  };
  eoslib.fe_paco.param = [ ## EOS parameters
                           7.012 83.7 5.97 ## liquid
                           8.30 156.2 6.08 ## epsilon
  ]; 

  ## EOS for core (Stacey et al., Phys. Earth Planet. Inter. 142 (2004) 137-184)
  eoslib.fe_core = struct();
  eoslib.fe_core.name = "Iron"; ## name of the material
  eoslib.fe_core.nrange = 1; ## number of pressure ranges
  eoslib.fe_core.rangename = {"core"}; ## name of the ranges
  eoslib.fe_core.prange = [-Inf Inf]; ## pressure ranges in GPa
  eoslib.fe_core.eostype = { ## types of EOSs
                             "bm3",... ## core
  };
  eoslib.fe_core.param = [ ## EOS parameters
                           6.563 125 4.96
  ]; 

  ##xx## EOS for mantle (Paco, ref?)
  eoslib.mgsio4_paco = struct();
  eoslib.mgsio4_paco.name = "Mg2SiO4";
  eoslib.mgsio4_paco.nrange = 2; ## number of pressure ranges
  eoslib.mgsio4_paco.rangename = {"mg2sio4","mgo+mgsio3"}; ## name of the ranges
  eoslib.mgsio4_paco.prange = [-Inf 23 Inf]; ## pressure range in GPa
  eoslib.mgsio4_paco.eostype = { ## types of EOSs
                                 "murnaghan",...
                                 "murnaghan",...
  };
  eoslib.mgsio4_paco.param = [ ## EOS parameters
                               3.55 182.0 4.2 ## mg2sio4
                               3.94 220.89 4.15 ## mgsio3 + mgo
  ];

  ## EOS for mantle (Stacey et al., Phys. Earth Planet. Inter. 142 (2004) 137-184)
  eoslib.mgsio4_mantle = struct();
  eoslib.mgsio4_mantle.name = "mantle";
  eoslib.mgsio4_mantle.nrange = 1; ## number of pressure ranges
  eoslib.mgsio4_mantle.rangename = {"mantle"}; ## name of the ranges
  eoslib.mgsio4_mantle.prange = [-Inf Inf]; ## pressure range in GPa
  eoslib.mgsio4_mantle.eostype = { ## types of EOSs
                         "bm3",...
  };
  eoslib.mgsio4_mantle.param = [ ## EOS parameters
                       3.977 206 4.20 ## pure Mgsio4 at 300K, BM3 EOS, (rho0, B0, B0') in (g/cm^3, GPa, .)
  ];

  ## fill some empty fields for later
  fs = fieldnames(eoslib);
  for i = 1:length(fs)
    eoslib.(fs{i}).whofile = {};
    eoslib.(fs{i}).rho = [];
    eoslib.(fs{i}).p = [];
    eoslib.(fs{i}).rhomax = [];
    eoslib.(fs{i}).pmax = [];
  endfor

endfunction
