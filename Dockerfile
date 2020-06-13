# for sshagentca version 0.0.5-beta : 09 June 2020
# https://github.com/rorycl/sshagentca
# RoryCL 13 June 2020

FROM golang:1.14-alpine

# add ssh-keygen
RUN apk add --no-cache --update openssh-keygen
RUN apk add --no-cache --update git

WORKDIR /sshagentca

RUN git clone https://github.com/rorycl/sshagentca.git ./
RUN git checkout -b 0.0.5-beta

# bring the sshagentca repo locally with git to go-sshagentca-git
# COPY ./go-sshagentca-git/ .

# setup the go environment; gcc isn't in alpine
RUN go mod download
RUN go get -d -v ./...
ENV CGO_ENABLED=0
RUN go test ./...
RUN go build

# environment for the sshagentca server
ENV SSHAGENTCA_PVT_KEY eer4Cei8
ENV SSHAGENTCA_CA_KEY aifeF0Oo
ENV SSHAGENTCA_PORT 2222

# settings
# add a key to the settings file in order to test the server
COPY settings.yaml ./

# generate keys for the server
RUN ssh-keygen -t rsa -b 2048 -f id_pvt -N ${SSHAGENTCA_PVT_KEY} > /dev/null 2>&1
RUN ssh-keygen -t rsa -b 2048 -f id_ca -N ${SSHAGENTCA_CA_KEY} > /dev/null 2>&1

# run the server
CMD ./sshagentca -t id_pvt -c id_ca -p ${SSHAGENTCA_PORT} settings.yaml
 
EXPOSE 2222




