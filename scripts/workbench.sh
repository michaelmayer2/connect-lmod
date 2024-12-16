#!/bin/bash

/usr/lib/rstudio-server/bin/license-manager activate $PPWB_LICENSE
rstudio-launcher start
rstudio-server start
