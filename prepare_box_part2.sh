# This script needs superman powers. Run like so:
# 
#   sudo sh prepare_box_part2.sh
# 
# Last edit: 2017-12-24



# Exit immediately on failure
set -e

# Print the commands as they are executed
set -x

# Clean packman's cache
pacman -Scc --noconfirm

# Delete orphaned packages
# If you see this in your output: "error: no targets specified (use -h for
# help)".. then that's okay. It simply means that there are no orphaned packages
# to remove.
set +e
pacman -Rsn $(pacman -Qdtq) --noconfirm
set -e

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
set +e
# This is supposed to crash with an error message:
#   "dd: error writing 'zerofile': No space left on device"
dd if=/dev/zero of=zerofile bs=1M
set -e

rm -f zerofile
sync

set +x
echo 'All done. Shutdown and package the box!'
history -c    # <-- clear this sessions's bash history