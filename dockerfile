# Use NVIDIA’s CUDA 12.8 runtime on Ubuntu 22.04
FROM nvidia/cuda:12.8.0-cudnn-runtime-ubuntu22.04

# Prevent prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# Install common build tools (add or remove packages as you like)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      cmake \
      git \
      wget

# Ensure CUDA binaries & libraries are on the PATH
ENV PATH=/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

WORKDIR /app

RUN apt-get install -y \
    bzip2 \
    libglib2.0-0 \
    libportaudio2 \
    vim

# conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

    RUN git clone https://github.com/MagicBOTAlex/MLEyeTrack.git && cd /app/MLEyeTrack/ && git fetch
    WORKDIR /app/MLEyeTrack/

COPY models ./models/
COPY environment.yml .

ENV PATH="/opt/conda/bin:${PATH}"
RUN /opt/conda/bin/conda init
RUN conda env create -f environment.yml
SHELL ["conda", "run", "-n", "et", "/bin/bash", "-c"]

# ## CUDA SUPPORT
RUN pip uninstall -y onnxruntime onnxruntime-gpu
RUN pip install onnxruntime-gpu


COPY ./Settings.json .

# CMD ["bash"]
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "et", "python3", "MLEyetrack.py"]