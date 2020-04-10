FROM debian:9.7
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH
RUN apt-get -y upgrade
RUN apt-get update && apt-get install -y apt-utils openssh-server 
RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion 
RUN apt-get install -y htop screen nano curl git-core git-gui git-doc git
RUN apt-get install -y build-essential module-assistant dkms
COPY Anaconda3-2020.02-Linux-x86_64.sh /root/
RUN /bin/bash /root/Anaconda3-2020.02-Linux-x86_64.sh -b -p /opt/conda && rm /root/Anaconda3-2020.02-Linux-x86_64.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

RUN conda update -n base -c defaults -y conda
RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge

RUN conda install python=3.6

RUN conda install -c bioconda -y fastqc
RUN conda install -c bioconda -y trimmomatic
RUN conda install -c bioconda -y samtools
RUN conda install -c bioconda -y hisat2
RUN conda install -c bioconda -y bedtools
RUN conda install -c bioconda -y bcftools
RUN conda install -c bioconda -y seqtk
RUN conda install -c bioconda -y varscan
RUN conda install -c bioconda -y kraken2
RUN conda install -c bioconda -y krona
RUN conda install -c bioconda -y megahit
RUN conda install -c bioconda -y SPAdes
RUN conda install -c bioconda -y spades
RUN conda install -c bioconda -y mafft
RUN conda install -c bioconda -y quast

EXPOSE 22
