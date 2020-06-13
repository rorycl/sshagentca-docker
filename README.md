# sshagentca-docker

Dockerfile to run an example sshagentca server

This Dockerfile builds an example docker image for the
[`sshagentca`](https://github.com/rorycl/sshagentca) server forwarding
ssh agent certificate authority server. The resulting image has sshd
configured to run on port 22 and sshagentca on port 2222.

The examples below show how to build and run the Docker image, how to
connect to the sshagentca server to receive a user certificate, and then
how to connect as the root user to the the sshd daemon running in the
container.

## Build 

First edit the settings file to add an existing or new ssh public key to
a new user entry in `settings.yaml`. You will need to add the private
key counterpart to your ssh-agent when connecting to sshagentca. This
user *must* have a principal of root for this exemplar. For example

	user_principals:
		-
			name: jane
			sshpublickey: "ssh-rsa AAAAB3NzaC1yc2EAAAADA.....6NYmTGxxqyAtiw== test1"
			principals:
				- root

Now build the image:

	docker build --tag sshagentca:0.0.5-beta ./

This will build a fairly minimal alpine image and make sshagentca after
running the project tests.

## Run

Run the docker image

    docker run -ti -p 2222:2222 -p 48084:22 sshagentca:v3-alpine

# Connect

Now add the private key of the ssh public key you added above to your
ssh agent. For example:

	eval $(ssh-agent)
	ssh-add <private_part_of_public_key_in_settings>

Now run `ssh` with `-A` to forward the agent as follows:

    ssh -p 2222 127.0.0.1 -A

which should provide output along the following lines:

    > acmecorp ssh user certificate service
    > 
    > welcome, jane
    > certificate generation complete
    > run 'ssh-add -l' to view
    > goodbye

Now you can test connecting to the ssh server on the Docker image by
running:

	ssh -p 48084 root@127.0.0.1

This should work to allow certificate-based access as the sshd server
uses the CA public key counterpart to the CA private key in this
directive:

    TrustedUserCAKeys /etc/ssh/ca.pub

## License

This project is licensed under the [MIT Licence](LICENCE).

Rory Campbell-Lange 13 June 2020
