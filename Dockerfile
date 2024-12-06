FROM ubuntu:noble

ARG PYTHON_VERSION="3.11.9"

RUN apt-get update && apt-get install -y curl 
# gdebi-core 

RUN curl -O https://cdn.rstudio.com/python/ubuntu-2404/pkgs/python-${PYTHON_VERSION}_1_amd64.deb && \
    apt install -y ./python-${PYTHON_VERSION}_1_amd64.deb && rm -f python*.deb

RUN /opt/python/${PYTHON_VERSION}/bin/pip install --upgrade \
    pip setuptools wheel && rm -rf /root/.cache


RUN echo "export PATH=/opt/python/${PYTHON_VERSION}/bin:\$PATH" > /etc/profile.d/path.sh

RUN apt-get install -y lmod gcc g++ make file bzip2 xz-utils patch libfindbin-libs-perl 

RUN useradd -s /bin/bash -m eb 

RUN mkdir /apps 

RUN chown eb /apps

USER eb

RUN bash -l -c "pip install easybuild==4.9.4"

RUN bash -l -c "eb --prefix /apps -r /home/eb/.local/easybuild/easyconfigs/ -f /home/eb/.local/easybuild/easyconfigs/r/R/R-4.4.1-gfbf-2023b.eb"

RUN bash -l -c "eb --prefix /apps -r /home/eb/.local/easybuild/easyconfigs/ -f /home/eb/.local/easybuild/easyconfigs/r/R/R-4.3.3-gfbf-2023b.eb"

COPY eb/*.eb /home/eb/

RUN bash -l -c "cd /home/eb && eb -f R-bundle-Bioconductor-3.19-gfbf-2023b-R-4.4.1.eb -r .:.local/easybuild/easyconfigs/ --prefix /apps/"
RUN bash -l -c "cd /home/eb && eb -f R-bundle-Bioconductor-3.18-gfbf-2023b-R-4.3.3.eb -r .:.local/easybuild/easyconfigs/ --prefix /apps/"

USER root

ARG PWB_VERSION="2024.12.0-463.pro4"

RUN curl -LO https://s3.amazonaws.com/rstudio-ide-build/server/jammy/amd64/rstudio-workbench-${PWB_VERSION}-amd64.deb && apt install -y ./rstudio-workbench-${PWB_VERSION}-amd64.deb && rm -f rstudio-workbench-${PWB_VERSION}-amd64.deb 

RUN echo "modules-bin-path=/etc/profile.d/lmod.sh" >> /etc/rstudio/rserver.conf
RUN echo "r-versions-scan=0" >> /etc/rstudio/rserver.conf

RUN echo -e "Module: R-bundle-Bioconductor/3.18-gfbf-2023b-R-4.3.3\nLabel: R 4.3.3 with Bioconductor 3.18" > /etc/rstudio/r-versions
RUN echo -e "\n\n" >> /etc/rstudio/r-versions
RUN echo -e "Module: R-bundle-Bioconductor/3.19-gfbf-2023b-R-4.4.1\nLabel: R 4.4.1 with Bioconductor 3.19" >> /etc/rstudio/r-versions

ARG PCT_VERSION="2024.11.0"

RUN curl -O https://cdn.posit.co/connect/${PCT_VERSION%.*}/rstudio-connect_${PCT_VERSION}~ubuntu24_amd64.deb &&  apt install -y ./rstudio-connect_${PCT_VERSION}~ubuntu24_amd64.deb && rm -f ./rstudio-connect_${PCT_VERSION}~ubuntu24_amd64.deb

#COPY config/rstudio-connect.gcfg /etc/rstudio-connect

RUN mkdir -p /apps/wrappers/bin

#COPY scripts/* /apps/wrappers/bin/

#RUN chmod +x /apps/wrappers/bin/*

RUN useradd -s /bin/bash -m rstudio && echo 'rstudio:rstudio' | chpasswd

ENTRYPOINT [ "/apps/wrappers/bin/connect.sh" ]

