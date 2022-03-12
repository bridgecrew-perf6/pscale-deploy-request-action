# Container image that runs your code
FROM debian:bullseye

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*


RUN wget https://github.com/planetscale/cli/releases/download/v0.89.0/pscale_0.89.0_linux_amd64.deb
RUN dpkg -i pscale_0.89.0_linux_amd64.deb

run apt-get update
run apt-get install -y jq

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY ps-authenticate.sh /ps-authenticate.sh
COPY ps-helper-functions.sh /ps-helper-functions.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
WORKDIR /
ENTRYPOINT ["/entrypoint.sh"]


# docker run -e PLANETSCALE_SERVICE_TOKEN=pscale_tkn_rq_XRfVAybbXsUBorWoKGl2fEpsexMOXSOwkAxKfNXQ -e PLANETSCALE_SERVICE_TOKEN_ID=ptrwoh5kj14g -it --entrypoint=bash kolla/pscale-deploy:v1