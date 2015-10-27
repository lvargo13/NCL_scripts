#!/bin/sh

# File to run the diagnostic plot package (DiagnosticPlots.ncl)
# Compares CISM with data

export filestart=170 
export fileend=200
export dataF="Greenland_5km_v1.1_SacksRev_c110629.nc" 
export modelPreName="BG_CISM1_parallel_updating.cism.h."
export modelPostName="-01-01-00000.nc"
ncl DiagnosticPlots.ncl
