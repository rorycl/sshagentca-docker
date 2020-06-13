# for sshagentca version 0.0.5-beta : 09 June 2020
# https://github.com/rorycl/sshagentca
# RoryCL 13 June 2020

FROM golang:1.14-alpine

# add ssh-keygen
RUN apk add --no-cache --update openssh-keygen
RUN apk add --no-cache --update openssh-server
RUN apk add --no-cache --update git

WORKDIR /sshagentca

# retrieve latest sshagentca release
RUN git clone https://github.com/rorycl/sshagentca.git ./
RUN git checkout -b 0.0.5-beta

# setup the go environment; note gcc isn't in alpine
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
# remember add a user with an ssh key to the settings file in order to
# test the server
COPY settings.yaml ./

# generate keys for the server
RUN ssh-keygen -t ecdsa -b 521 -f id_pvt -N ${SSHAGENTCA_PVT_KEY} > /dev/null 2>&1
RUN ssh-keygen -t ecdsa -b 521 -f id_ca -N ${SSHAGENTCA_CA_KEY} > /dev/null 2>&1

# setup the ssh server keys, trusteduserca keys configuration
RUN ssh-keygen -A
RUN echo "TrustedUserCAKeys /sshagentca/id_ca.pub" >> /etc/ssh/sshd_config

# enable root user for login
RUN sed -i s/root:!/"root:*"/g /etc/shadow

EXPOSE 2222 22

# run the sshagentca server and ssh server
# CMD ./sshagentca -t id_pvt -c id_ca -p ${SSHAGENTCA_PORT} settings.yaml
# ENTRYPOINT service ssh restart
# CMD ["/usr/sbin/sshd", "-D"]

# run sshd and sshagentca
COPY run.sh run.sh
RUN ls -lt /sshagentca/run.sh
CMD /sshagentca/run.sh
