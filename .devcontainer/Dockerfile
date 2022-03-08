# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.202.5/containers/go/.devcontainer/base.Dockerfile

# [Choice] Go version (use -bullseye variants on local arm64/Apple Silicon): 1, 1.16, 1.17, 1-bullseye, 1.16-bullseye, 1.17-bullseye, 1-buster, 1.16-buster, 1.17-buster
ARG VARIANT="1.17-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/go:0-${VARIANT}

ENV GOPRIVATE="${GOPRIVATE},github.com/kollalabs"


USER vscode
# Add Go based tools
RUN go install github.com/planetscale/cli/cmd/pscale@v0.89.0 && go clean -cache -testcache -modcache
