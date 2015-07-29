#!/bin/sh

export filestart=2 
export fileend=2
export modelAPreName="IG_CISM2_test_001.cism.h."
export modelAPostName="-01-01-00000.nc"
export modelBPreName="IG_CISM2_test_409.cism.h."
export modelBPostName="-01-01-00000.nc"
export latlon="lat_lon.nc"
ncl Compare_CISM_plots.ncl
