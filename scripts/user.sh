#!/bin/bash

if [ "${RSTUDIO_PW}" = "" ]; then
    RSTUDIO_PW=`tr -dc A-Za-z0-9 </dev/urandom | head -c 13; echo`
fi

echo 'rstudio:${RSTUDIO_PW}' | chpasswd
