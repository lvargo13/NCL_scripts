#!/bin/sh

export filestart=35 
export fileend=65
export FileAname="gradient=0"
export FileBname="gradient=1"
export modelAPreName="/glade/u/home/lvargo/scratch/archive/IG_CISM2_test_041/glc/hist/IG_CISM2_test_041.cism.h."
export modelAPostName="-01-01-00000.nc"
export modelBPreName="/glade/u/home/lvargo/scratch/archive/IG_CISM2_test_113/glc/hist/IG_CISM2_test_113.cism.h."
export modelBPostName="-01-01-00000.nc"
export latlon="lat_lon.nc"
ncl Compare_CISM_plots.ncl
