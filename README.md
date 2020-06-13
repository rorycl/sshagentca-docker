# sshagentca-docker

Dockerfile to run an example sshagentca server

This Dockerfile builds an example docker image for the `sshagentca` ssh
server forwarding agent certificate authority at
https://github.com/rorycl/sshagentca.

# Build 

First edit the settings file to add an existing or new ssh public key to
a new user entry in `settings.yaml`

	docker build --tag sshagentca:0.0.5-beta ./

This will build a fairly minimal alpine image and build sshagentca after
running the project tests.

# Run

Run the docker image

	docker run -ti -p 2222:2222 <imageid>

Now add the private key of the ssh public key you added above to your
ssh agent. Invoking `ssh` with `-A` to forward the agent as follows:

    ssh -p 2222 127.0.0.1 -A

should provide output along the following lines:

    > acmecorp ssh user certificate service
    > 
    > welcome, bob
    > certificate generation complete
    > run 'ssh-add -l' to view
    > goodbye

# Remote servers

To test this on a server, add the CA public key in the Docker container
to `sshd_config`, eg:

    TrustedUserCAKeys /etc/ssh/ca.pub

## License

This project is licensed under the [MIT Licence](LICENCE).

Rory Campbell-Lange 13 June 2020
