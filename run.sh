#!/bin/ash

# start sshd
/usr/sbin/sshd -E /sshagentca/ssh.log
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start sshd: $status"
  exit $status
else
  echo "sshd server started"
fi

echo "--------------------"

# Start sshagentca
./sshagentca -t id_pvt -c id_ca -p ${SSHAGENTCA_PORT} settings.yaml
