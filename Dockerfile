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

USER root

ARG PWB_VERSION="2024.12.0-463.pro4"

RUN curl -LO https://s3.amazonaws.com/rstudio-ide-build/server/jammy/amd64/rstudio-workbench-${PWB_VERSION}-amd64.deb && apt install -y ./rstudio-workbench-${PWB_VERSION}-amd64.deb && rm -f rstudio-workbench-${PWB_VERSION}-amd64.deb 

ARG PCT_VERSION="2024.11.0"

RUN curl -O https://cdn.posit.co/connect/${PCT_VERSION%.*}/rstudio-connect_${PCT_VERSION}~ubuntu24_amd64.deb &&  apt install -y ./rstudio-connect_${PCT_VERSION}~ubuntu24_amd64.deb

COPY config/rstudio-connect.gcfg /etc/rstudio-connect

RUN mkdir -p /apps/wrappers/bin

COPY scripts/R* /apps/wrappers/bin/

RUN chmod +x /apps/wrappers/bin/*

ENTRYPOINT [ "/apps/wrappers/bin/connect.sh" ]

