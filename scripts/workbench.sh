#!/bin/bash

rm -f /etc/launcher.{pub,pem}

cat << EOF > /etc/rstudio/r-versions
Module: R-bundle-CRAN/2024.06-gfbf-2023b-R-4.4.1
Label: R 4.4.1 with CRAN only

Module: R/4.4.1-gfbf-2023b
Label: R 4.4.1 with base/rec only

Module: R/4.3.3-gfbf-2023b
Label: R 4.3.3 with base/rec only
EOF
/usr/lib/rstudio-server/bin/license-manager activate $PWB_LICENSE
rstudio-launcher start
rstudio-server start
