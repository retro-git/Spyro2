docker build --tag spyro2-build:latest . && \
docker run --rm -it -v $(pwd):/spyro2 -w /spyro2 spyro2-build