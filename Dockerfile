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
RUN cd /root/ && curl -O -L "https://downloads.sourceforge.net/project/covfiles/Anaconda/Anaconda3-2020.02-Linux-x86_64.sh"
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
RUN cd /root/ && git clone https://github.com/amalthomas111/covid19.git
RUN conda env create -f /root/covid19/covid19_condaenv.yml

RUN curl -L -O https://www.megasoftware.net/releases/megax-cc_10.1.8-1_amd64.deb
RUN apt install -y gconf-service gconf2-common libdbus-glib-1-2 libgconf-2-4 libgtk2.0-0
RUN sudo dpkg -i megax-cc_10.1.8-1_amd64.deb
RUN rm megax-cc_10.1.8-1_amd64.deb

EXPOSE 22
