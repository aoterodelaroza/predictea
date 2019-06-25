#! /usr/bin/octave -q

## Define some parameters for the run. Constants are signaled
## as __x__.
global __npts__
__npts__ = 10001; ## the number of points in an EOS range

## Add the relevant directories to the path
addpath("./eos_work");
addpath("./ode_funs");

## load the EOS library
eos = eos_library();

