FROM alpine:3.22

RUN apk add git bash curl aws-cli
ENV LANG=en_US.utf8
WORKDIR /tmp/binaries

# SOPS
ENV SOPS_VERSION=v3.11.0
RUN wget -q https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64 -O /usr/bin/sops &&\
    chmod +x /usr/bin/sops

# HELM
ENV HELM_VERSION=v3.19.0
RUN wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O helm.tar.gz &&\
    tar -zxvf helm.tar.gz &&\
    chmod +x linux-amd64/helm &&\
    mv linux-amd64/helm /usr/bin/helm

# HELMFILE
ENV HELMFILE_VERSION=1.1.7
RUN wget -q https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz -O helmfile.tar.gz &&\
    tar -zxvf helmfile.tar.gz &&\
    chmod +x helmfile &&\
    mv helmfile /usr/bin/helmfile

# kubectl
ENV KUBECTL_VERSION=v1.27.3
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -O /usr/bin/kubectl; \
    chmod +x /usr/bin/kubectl

RUN rm -rf /tmp/binaries

# CREATE NEW USER
ENV USER=helm-user
RUN addgroup -S $USER && adduser -S -G $USER $USER
USER ${USER}
ENV HELM_DATA_HOME=/home/${USER}/.local/share/helm
ENV HELM_CACHE_HOME=/home/${USER}
ENV HELM_CONFIG_HOME=/home/${USER}

# HELM PLUGINS
ENV HELM_GIT_VERSION=v1.4.1
ENV HELM_DIFF_VERSION=v3.12.5
ENV HELM_SECRETS_VERSION=v4.6.10

RUN helm plugin install https://github.com/aslafy-z/helm-git --version ${HELM_GIT_VERSION} && \
    helm plugin install https://github.com/databus23/helm-diff --version ${HELM_DIFF_VERSION} && \
    helm plugin install https://github.com/jkroepke/helm-secrets --version ${HELM_SECRETS_VERSION}

WORKDIR /home/${USER}/