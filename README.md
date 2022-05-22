# sshagentca-docker

Dockerfile to run an example sshagentca server.

This Dockerfile builds an example docker image for the
[`sshagentca`](https://github.com/rorycl/sshagentca) server forwarding
ssh agent certificate authority server. The resulting image has sshd
configured to run on port 48084 and sshagentca on port 2222.

The examples below show how to build and run the Docker image, how to
connect to the sshagentca server to receive a user certificate, and then
how to connect as the root user to the the sshd daemon running in the
container.

## Build 

You can use the `briony` example user, with the provided public and
private ed25519 keys, or edit the example settings file.

First edit the settings file to add an existing or new ssh public key to
a new user entry in `settings.yaml`. You will need to add the private
key counterpart to your ssh-agent when connecting to sshagentca. This
user *must* have a principal of root for this exemplar. For example

    user_principals:
      -
        name: jane
        sshpublickey: "ssh-rsa AAAAB3NzaC1y.....mTGxxqyAtiw== test1"
        principals:
          - root

Now build the image:

  docker build --tag sshagentca:0.0.7-beta ./

This will use a multi-stage build to first download the project source,
run the tests, build the go `sshagentca` binary and then copy the binary
into a minimal alpine image.

## Run

Run the docker image

    docker run -ti -p 2222:2222 -p 48084:48084 sshagentca:0.0.5-beta

# Example

    $ eval $(ssh-agent)
      Agent pid 2253284

    $ ssh-add briony
      Identity added: briony (briony@test.com)

    $ ssh -A -p 2222 root@127.0.0.1
      acmeinc ssh user certificate service

      welcome, briony
      certificate generation complete
      run 'ssh-add -l' to view
      goodbye

    $ ssh -p 48084 root@127.0.0.1
      Welcome to Alpine!
      ...
      707c6ed4c4b0:~# exit

## License

This project is licensed under the [MIT Licence](LICENCE).

Rory Campbell-Lange 21 May 2022
