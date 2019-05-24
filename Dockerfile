FROM nvidia/cuda:9.0-cudnn7-devel
ENV NB_USER masskt
ENV NB_UID 1000
RUN set -x && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
    locales \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    vim \
    libgtk2.0-dev \
    sudo && \
    locale-gen en_US.UTF-8 && \
    : "useradd" && \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir /home/$NB_USER/.jupyter && \
    chown -R $NB_USER:users /home/$NB_USER/.jupyter && \
    echo "$NB_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$NB_USER && \
    : "python install" && \
    pip3 install --upgrade setuptools pip && \
    mkdir -p /usr/src/app && \
    chown $NB_USER:users -R /usr/src/app
WORKDIR /usr/src/app
COPY requirements.txt ./
COPY fonts/*.ttf ./
RUN set -x && \
    pip3 install --no-cache-dir -r requirements.txt && \
    : "Japanese fonts installation for matplotlib" && \
    python3 -c "import matplotlib;print(matplotlib.matplotlib_fname())" >> /tmp/matplot1.txt && \
    python3 -c "import os;import matplotlib;print(os.path.dirname(matplotlib.matplotlib_fname())+'/fonts/ttf/')" >> /tmp/matplot2.txt && \
    echo 'font.family : IPAexGothic' >> $(cat /tmp/matplot1.txt) && \
    mv *.ttf  $(cat /tmp/matplot2.txt) && \
    rm /tmp/matplot1.txt /tmp/matplot2.txt
USER $NB_USER
RUN set -x && \
    jupyter notebook --generate-config && \
    sed -i "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/g" /home/$NB_USER/.jupyter/jupyter_notebook_config.py && \
    sed -i "s/#c.NotebookApp.token = '<generated>'/c.NotebookApp.token = 't0ken'/g" /home/$NB_USER/.jupyter/jupyter_notebook_config.py    
ENV LANG en_US.UTF-8 
EXPOSE 8888
ENTRYPOINT ["/usr/local/bin/jupyter"]
CMD ["notebook"]
