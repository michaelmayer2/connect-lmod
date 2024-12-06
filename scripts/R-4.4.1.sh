#!/bin/bash

source /etc/profile.d/lmod.sh 
ml use /apps/modules/all
ml load R/4.4.1-gfbf-2023b

R $@