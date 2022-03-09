# Container image that runs your code
FROM golang:alpine 

RUN go install github.com/planetscale/cli/cmd/pscale@v0.89.0 && go clean -cache -testcache -modcache

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY ps-authenticate.sh /ps-authenticate.sh
COPY ps-helper-functions.sh /ps-helper-functions.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
WORKDIR "/"
ENTRYPOINT ["/entrypoint.sh"]
