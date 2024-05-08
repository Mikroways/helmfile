FROM alpine:3.18

RUN apk add git bash curl
ENV LANG en_US.utf8
WORKDIR /tmp/binaries

# SOPS
ENV SOPS_VERSION v3.8.1
RUN wget -q https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64 -O /usr/bin/sops &&\
    chmod +x /usr/bin/sops

# HELM
ENV HELM_VERSION v3.14.4
RUN wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O helm.tar.gz &&\
    tar -zxvf helm.tar.gz &&\
    chmod +x linux-amd64/helm &&\
    mv linux-amd64/helm /usr/bin/helm

# HELMFILE
ENV HELMFILE_VERSION 0.164.0
RUN wget -q https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz -O helmfile.tar.gz &&\
    tar -zxvf helmfile.tar.gz &&\
    chmod +x helmfile &&\
    mv helmfile /usr/bin/helmfile

# HELM PLUGINS
RUN helm plugin install https://github.com/aslafy-z/helm-git
RUN helm plugin install https://github.com/databus23/helm-diff
RUN helm plugin install https://github.com/jkroepke/helm-secrets

# kubectl
ENV KUBECTL_VERSION v1.27.3
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -O /usr/bin/kubectl; \
    chmod +x /usr/bin/kubectl

RUN apk add aws-cli

RUN rm -rf /tmp/binaries
WORKDIR /
