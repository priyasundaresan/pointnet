ARG cuda_version=9.0
ARG cudnn_version=7
FROM nvidia/cuda:${cuda_version}-cudnn${cudnn_version}-devel

# Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
      bzip2 \
      g++ \
      git \
      graphviz \
      libgl1-mesa-glx \
      libhdf5-dev \
      openmpi-bin \
      wget && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils git curl vim unzip openssh-client wget \
    build-essential cmake \
    libopenblas-dev

RUN apt install -y --allow-downgrades --allow-change-held-packages libcudnn7-dev=7.0.5.15-1+cuda9.1 libcudnn7=7.0.5.15-1+cuda9.1

RUN apt-get install -y --no-install-recommends python3.5 python3.5-dev python3-pip python3-tk && \
    pip3 install --no-cache-dir --upgrade pip setuptools && \
    echo "alias python='python3'" >> /root/.bash_aliases && \
    echo "alias pip='pip3'" >> /root/.bash_aliases

RUN pip install --upgrade pip && \
    pip install --ignore-installed six \
      numpy==1.16.4 \
      tensorflow-gpu==1.6.0 \
      keras==2.1.5 \
      scipy \
      Pillow \
      cython \
      scikit-image \
      opencv-python \
      sklearn_pandas \
      IPython[all] \
      cntk-gpu \
      h5py

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV PYTHONPATH='/src/:$PYTHONPATH'

WORKDIR /data

EXPOSE 8888

CMD jupyter notebook --port=8888 --ip=0.0.0.0

ENV TEMP_MRCNN_DIR /tmp/mrcnn
ENV MRCNN_DIR /mrcnn

# ENV variables for python3 - see http://click.pocoo.org/5/python3/
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Silence Tensorflow warnings - look into compiling for CPU supported instruction sets
ENV TF_CPP_MIN_LOG_LEVEL 2

# NOTE: cloning master (might be an unstable HEAD)
RUN git clone https://github.com/matterport/Mask_RCNN.git $TEMP_MRCNN_DIR
COPY visualize.py $TEMP_MRCNN_DIR/mrcnn

RUN cd $TEMP_MRCNN_DIR && \
 python3 setup.py install

CMD ["/bin/bash"]
