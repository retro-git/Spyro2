FROM ubuntu:22.04 as build

ENV DEBIAN_FRONTEND=noninteractive

COPY . /spyro2
WORKDIR /spyro2

RUN  apt-get update \
     && apt-get install -y -o APT::Immediate-Configure=false $(cat packages.txt) \
     && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install -r tools/splat/requirements.txt --use-deprecated=legacy-resolver

RUN  cd tools/mkpsxiso \
     && cmake -S . -B ./build -DCMAKE_BUILD_TYPE=Release \
     && cmake --build ./build \
     && cmake --install ./build

COPY .bash_aliases /root/.bash_aliases