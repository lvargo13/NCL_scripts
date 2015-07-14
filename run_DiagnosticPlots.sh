#!/bin/sh

export filestart=90 
export fileend=130 
export dataF="Greenland_5km_v1.1_SacksRev_c110629.nc" 
export modelPreName="BG_CISM1_parallel_updating.cism.h."
export modelPostName="-01-01-00000.nc"
ncl DiagnosticPlots.ncl
