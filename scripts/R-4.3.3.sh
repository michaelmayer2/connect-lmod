#!/bin/bash

source /etc/profile.d/lmod.sh 
ml use /apps/modules/all
ml purge
ml load R-bundle-Bioconductor/3.18-gfbf-2023b-R-4.3.3 

exec R "$@"
