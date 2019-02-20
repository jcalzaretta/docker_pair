#!/bin/bash

# when no arguments given exit with errcode 1
if [ -z "$@" ]
then
   >&2 echo "ERROR: You need to provide GitHub logins!"
   exit 1
fi

# create pair user
adduser --shell /bin/bash --uid $base_uid pair

# setup homedir
mkdir -p /home/pair/.ssh && touch /home/pair/.ssh/authorized_keys
chown -R pair:pair /home/pair
echo "pair:abc123" | chpasswd

for user in $@
do
  echo "Fetching key for $user..."
  # fetch pubkeys by GitHub user login
  RESPONSE=$(su -c "curl https://api.github.com/users/$user/keys 2>/dev/null")

  # get the keys from JSON and append to authorized_keys
  echo "$RESPONSE" | sed -n 's/"key": "\(.*\)"/\1/p' | sed "s/^ \+/command=\"\/usr\/bin\/tmux new -s $user -t pair || \/usr\/bin\/tmux attach-session -t pair\" /g" >> /home/pair/.ssh/authorized_keys
done

chown -R pair: /home/pair/.ssh

# start tmux session
su -c "tmux new -d -s pair -c /home/pair/workspace" pair

# start ssh daemon
exec /usr/sbin/sshd -Def /etc/ssh/sshd_config
