# cloud-init is running at boot time and blocking access to apt.
# Before doing anything we should wait for it to finish.
# cloud-init creates a file after finishing boot.

echo "Waiting for cloud-init to finish provisioning the instance."
while [ ! -f /var/lib/cloud/instance/boot-finished ]
do
  echo "#"
  sleep 2
done

# Wait some more to be sure
sleep 10