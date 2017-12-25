# Prepares a newly created Manjaro 17 VM instance to be exported as a Vagrant
# box.
# 
# This script needs superman powers. Run like so:
# 
#   sudo sh prepare_box_part1.sh
# 
# I have no idea how but.. somehow the latest and greatest Guest Additions gets
# installed automagically when pacman updates the system. I.e., no need to
# bother with the Guest Additions explicitly.
# 
# Last edit: 2017-12-24



# Exit immediately on failure
set -e

# Print the commands as they are executed
set -x

# Synchronize/update package databases and upgrade packages
pacman -Syu --noconfirm

# Authorize Vagrant's insecure public SSH key
mkdir /home/vagrant/.ssh/
chmod 700 /home/vagrant/.ssh/
wget https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Set root password to "vagrant"
echo root:vagrant | chpasswd

# Passwordless sudo
echo $'\nvagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Enable the SSH server service
systemctl enable sshd

# ..and the VirtualBox Guest Addition's service
systemctl enable vboxservice

set +x
echo 'All done. Update the Linux kernel!'