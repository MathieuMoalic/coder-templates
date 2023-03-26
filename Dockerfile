ARG CUDA_VER=11.7.1
ARG UBUNTU_VER=22.04
FROM nvidia/cuda:${CUDA_VER}-cudnn8-runtime-ubuntu${UBUNTU_VER}

ARG DEBIAN_FRONTEND="noninteractive"
ARG PYTHON_VER=3.10
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    bash-completion \
    ca-certificates \
    curl \
    git \
    htop \
    nano \
    openssh-client \
    python${PYTHON_VER} python${PYTHON_VER}-dev python3-pip python-is-python3 \
    sudo \
    tmux \
    unzip \
    vim \
    wget \ 
    golang \
    fonts-firacode \ 
    zip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH="${PATH}:/share"
ENV PATH="${PATH}:/home/coder/.local/bin"

ARG USER=coder
RUN useradd ${USER} \
    --create-home \
    --shell=/bin/bash && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}
USER ${USER}

RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version 4.9.1 && \
    code-server --install-extension ms-python.python && \
    code-server --install-extension PKief.material-icon-theme && \
    code-server --install-extension formulahendry.code-runner && \
    code-server --install-extension dracula-theme.theme-dracula

RUN pip install --upgrade --no-cache-dir pip setuptools wheel && \
    pip install --upgrade --no-cache-dir \
    git+https://github.com/mathieumoalic/pyzfn \
    ipywidgets \
    matplotlib \
    matplotx \
    numpy \
    peakutils \
    tqdm 

RUN mkdir -p /home/${USER}/workdir
WORKDIR /home/${USER}/workdir