#!/bin/bash

# abort on errors
#
set -e

# ga van een up-to-date omgeving uit
#
apt-get update
apt-get upgrade

# we willen dat alleen users in deze group kunnen ssh-en
#
SshGroep="sshers"

if ! grep -q $SshGroep /etc/group ; then
    adduser -group $SshGroep
fi

# de progadmin user die met ssh kan inloggen
#
SshAccount="progadmin"
SshDirectory="/home/$SshAccount/.ssh"
SshKeys="$SshDirectory/authorized_keys"

if ! grep -q $SshAccount /etc/passwd ; then
    adduser --disabled-password --ingroup $SshGroep --gecos "" $SshAccount
    passwd $SshAccount
fi

adduser $SshAccount sudo 

if [ ! -d "$SshDirectory" ]; then
    mkdir $SshDirectory
    chown $SshAccount:$SshGroep $SshDirectory
fi

echo "# Een enkele sleutel voor de initiele gebruiker" | tee $SshKeys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAp0rISNC+CVaW21VRQKQdMUjuuHOxtak2GUS9dlIUki0ixcDLZ/r61EX7r+MjBto/OZyFigiKqomwqYQVf4PmC8P6DK9cmJyj3MFLiwzAKqR0CD6nv9hhI6WCK/Flz2686jgcRuyo9GBDfI3QINdX6L+r2U1ulM6U9rmLynmtNezQS7sk1b9cep37w3KPL4NLWaJZWdItC+ACppL7P1K7xMdZjeB5afSS2KUSrZNAwU5hmKdFhP5ltMVB61R6oK0BH66u238Kj/EHVsrr+iK+jbys8E8gxoZKHvj026jH9241BocuF7Gs4dRjOy5wrxaQ06r7i2ufZPBxv4RQDFDN+uNkJ2DilKCwscWj3zkfgsCjlQyCQ/7lB+idqmeZHEMVNMZjZnZky0hKm/0nKi9qrqrxXUZnUi5yaXKCcwp8BIymgDhDV5wbrkBeVWfggCin4nxWjxai1I4cO9dPhrB/3gWO9WUIoeGj2M2tDZhwvURdRZCDEKuUeiU5xYCyvp00flB+ktq8AtZBR68olZ1SpzAqBeLlT4EOBa1lX+fx7AOL37n2lMgfDyXpoFGjf0hW0sNfvHVl46l3dASPHSF3DrcV2eSvobqb/I7pKbEU9RFqQcBaxeY6i+d4CAFO3ISOd8Nf5YjUonM16sN3FuG5O4QCylZABG5OZfdEKwo5M9k= Initiele SSH key" | tee -a $SshKeys
chown $SshAccount:$SshGroep $SshKeys

# install open-sshserver
#
SshConfigFile="/etc/ssh/sshd_config"

apt-get install openssh-server

sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" $SshConfigFile
sed -i "s/UsePAM yes/UsePAM no/" $SshConfigFile
if ! grep -q AllowGroups $SshConfigFile ; then
    sed -i "/PubkeyAuthentication yes/a AllowGroups $SshGroep" $SshConfigFile
fi

service ssh restart

# reboot voor het gemak ...
reboot now
