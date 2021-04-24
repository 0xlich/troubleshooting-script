FROM ubuntu:latest
LABEL maintainer=nelson@pokt.network

# Installing pocket
ENV PATH="/usr/local:/usr/local/go/bin:${PATH}"
USER root
RUN apt-get update && apt-get install -y git libleveldb-dev build-essential wget tar curl iputils-ping iptables \
  && cd $HOME \
  && wget https://golang.org/dl/go1.16.3.linux-amd64.tar.gz \
  && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.3.linux-amd64.tar.gz \
  && git clone https://github.com/pokt-network/pocket-core.git \
  && cd pocket-core && go build -o /usr/local/go/bin/pocket app/cmd/pocket_core/main.go \
  && cd $HOME && mkdir -p .pocket/config && cd .pocket/config \
  && curl -O https://raw.githubusercontent.com/pokt-network/pocket-network-genesis/master/testnet/genesis.json

# After installing let's start it with:
CMD ["pocket","version"]
