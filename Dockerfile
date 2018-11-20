FROM ensemblorg/ensembl-vep

USER root

ENV DEBIAN_FRONTEND noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

# Updates
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get -y upgrade

# conda installation
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  -O ./miniconda.sh && \
    /bin/bash ./miniconda.sh -b -p /opt/conda && \
    rm ./miniconda.sh

# python pip updates
RUN conda install python=3.6
RUN pip install --upgrade pip
RUN python -V
RUN pip -V

COPY . ./mmsplice
WORKDIR ./mmsplice
RUN pip install -e .
WORKDIR ..
RUN mmsplice

RUN mkdir /root/.vep
RUN mkdir /root/.vep/Plugins/
RUN cp VEP_plugin/MMSplice.pm root/.vep/Plugins/MMSplice.pm

# Kipoi installation
# RUN conda install -c conda-forge git-lfs && git lfs install
# RUN pip install kipoi
# RUN kipoi env create MMSplice/deltaLogitPSI
