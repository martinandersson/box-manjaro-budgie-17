# Prepares a newly created Manjaro 17 VM instance to be exported as a Vagrant
# box.
# 
# This script needs superman powers. Run like so:
# 
#   sudo sh prepare_box.sh
# 
# I have no idea how but.. somehow the latest and greatest Guest Additions gets
# installed automagically in the first command executed by this script. I.e., no
# need to bother with the Guest Additions explicitly.
# 
# Last edit: 2017-12-03



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

# Clean packman's cache
pacman -Scc --noconfirm

# Delete orphaned packages
# If you see this in your output: "error: no targets specified (use -h for
# help)".. then that's okay. It simply means that there are no orphaned packages
# to remove.
pacman -Rsn $(pacman -Qdtq) --noconfirm

# Delete stuff
shopt -s dotglob
rm -rf /var/log/*
rm -rf /home/vagrant/.cache/*
rm -rf /root/.cache/*
rm -rf /var/cache/*
rm -rf /var/tmp/*
rm -rf /tmp/*

# Clear recent bash history
cat /dev/null > /home/vagrant/.bash_history
cat /dev/null > /root/.bash_history

# Fill empty space with zeroes
dd if=/dev/zero of=zerofile bs=1M
rm -f zerofile
sync

echo 'All done. Shutdown and package the box!'
history -c    # <-- clear this sessions's bash history