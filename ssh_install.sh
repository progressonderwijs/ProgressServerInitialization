#!/bin/bash

# abort on errors
#
set -e

# ga van een up-to-date omgeving uit
#
apt-get upgrade

# we willen dat alleen users in deze group kunnen ssh-en
#
GROUP="sshers"

if ! grep -q $GROUP /etc/group ; then
    adduser -group $GROUP
fi

# de progadmin user die met ssh kan inloggen
#
USER="progadmin"
SSH_DIR="/home/$USER/.ssh"
SSH_KEYS="$SSH_DIR/authorized_keys"

if ! grep -q $USER /etc/passwd ; then
    adduser --disabled-password --ingroup $GROUP --gecos "" $USER
    passwd $USER
fi

adduser $USER sudo 

if [ ! -d "$SSH_DIR" ]; then
    mkdir $SSH_DIR
    chown $USER:$GROUP $SSH_DIR
fi

echo "# Een enkele sleutel voor de initiele gebruiker" | tee $SSH_KEYS
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAp0rISNC+CVaW21VRQKQdMUjuuHOxtak2GUS9dlIUki0ixcDLZ/r61EX7r+MjBto/OZyFigiKqomwqYQVf4PmC8P6DK9cmJyj3MFLiwzAKqR0CD6nv9hhI6WCK/Flz2686jgcRuyo9GBDfI3QINdX6L+r2U1ulM6U9rmLynmtNezQS7sk1b9cep37w3KPL4NLWaJZWdItC+ACppL7P1K7xMdZjeB5afSS2KUSrZNAwU5hmKdFhP5ltMVB61R6oK0BH66u238Kj/EHVsrr+iK+jbys8E8gxoZKHvj026jH9241BocuF7Gs4dRjOy5wrxaQ06r7i2ufZPBxv4RQDFDN+uNkJ2DilKCwscWj3zkfgsCjlQyCQ/7lB+idqmeZHEMVNMZjZnZky0hKm/0nKi9qrqrxXUZnUi5yaXKCcwp8BIymgDhDV5wbrkBeVWfggCin4nxWjxai1I4cO9dPhrB/3gWO9WUIoeGj2M2tDZhwvURdRZCDEKuUeiU5xYCyvp00flB+ktq8AtZBR68olZ1SpzAqBeLlT4EOBa1lX+fx7AOL37n2lMgfDyXpoFGjf0hW0sNfvHVl46l3dASPHSF3DrcV2eSvobqb/I7pKbEU9RFqQcBaxeY6i+d4CAFO3ISOd8Nf5YjUonM16sN3FuG5O4QCylZABG5OZfdEKwo5M9k= initiele_ssh" | tee -a $SSH_KEYS
chown $USER:$GROUP $SSH_KEYS

# install open-sshserver
#
CONFIG="/etc/ssh/sshd_config"

apt-get install openssh-server

sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" $CONFIG
sed -i "s/UsePAM yes/UsePAM no/" $CONFIG
if ! grep -q AllowGroups $CONFIG ; then
    sed -i "/PubkeyAuthentication yes/a AllowGroups $GROUP" $CONFIG
fi

service ssh restart

# reboot voor het gemak ...
reboot now
