#!/bin/bash

# Parameters en helpers
#
SshGroup="sshers"
SshAccount="progadmin"
SshAccountConfigDir="/home/$SshAccount/.ssh"
SshAccountAuthKeys="$SshAccountConfigDir/authorized_keys"
SshConfigFile="/etc/ssh/sshd_config"

EnsureSshSetting () {
    grep -q "^#\{0,1\}$1" $SshConfigFile && sed -i "/^#\{0,1\}$1/c\\$1 $2" $SshConfigFile || sed -i "$ a\\$1 $2" $SshConfigFile
}

# abort on errors
#
set -e

# ga van een up-to-date omgeving uit
#
apt-get -y update
apt-get -y dist-upgrade

# we willen dat alleen users in deze group kunnen ssh-en
#
if ! grep -q $SshGroup /etc/group ; then
    adduser -group $SshGroup
fi

# de progadmin user die met ssh kan inloggen
#
if ! grep -q $SshAccount /etc/passwd ; then
    adduser --disabled-password --ingroup $SshGroup --gecos "" $SshAccount
    passwd $SshAccount
fi

adduser $SshAccount sudo 

if [ ! -d "$SshAccountConfigDir" ]; then
    mkdir $SshAccountConfigDir
    chown $SshAccount:$SshGroup $SshAccountConfigDir
fi

echo "# Een enkele sleutel voor de initiele gebruiker" > $SshAccountAuthKeys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAp0rISNC+CVaW21VRQKQdMUjuuHOxtak2GUS9dlIUki0ixcDLZ/r61EX7r+MjBto/OZyFigiKqomwqYQVf4PmC8P6DK9cmJyj3MFLiwzAKqR0CD6nv9hhI6WCK/Flz2686jgcRuyo9GBDfI3QINdX6L+r2U1ulM6U9rmLynmtNezQS7sk1b9cep37w3KPL4NLWaJZWdItC+ACppL7P1K7xMdZjeB5afSS2KUSrZNAwU5hmKdFhP5ltMVB61R6oK0BH66u238Kj/EHVsrr+iK+jbys8E8gxoZKHvj026jH9241BocuF7Gs4dRjOy5wrxaQ06r7i2ufZPBxv4RQDFDN+uNkJ2DilKCwscWj3zkfgsCjlQyCQ/7lB+idqmeZHEMVNMZjZnZky0hKm/0nKi9qrqrxXUZnUi5yaXKCcwp8BIymgDhDV5wbrkBeVWfggCin4nxWjxai1I4cO9dPhrB/3gWO9WUIoeGj2M2tDZhwvURdRZCDEKuUeiU5xYCyvp00flB+ktq8AtZBR68olZ1SpzAqBeLlT4EOBa1lX+fx7AOL37n2lMgfDyXpoFGjf0hW0sNfvHVl46l3dASPHSF3DrcV2eSvobqb/I7pKbEU9RFqQcBaxeY6i+d4CAFO3ISOd8Nf5YjUonM16sN3FuG5O4QCylZABG5OZfdEKwo5M9k= Initiele SSH key" >> $SshAccountAuthKeys
chown $SshAccount:$SshGroup $SshAccountAuthKeys

# install open-sshserver
# secure setting as taken from http://bookofzeus.com/harden-ubuntu/hardening/ssh/
#
apt-get -y install openssh-server

EnsureSshSetting AllowUsers $SshAccount
EnsureSshSetting AllowGroups $SshGroup
EnsureSshSetting PermitRootLogin no
EnsureSshSetting PermitEmptyPasswords no
EnsureSshSetting PermitUserEnvironment no
EnsureSshSetting PrintLastLog no
EnsureSshSetting PasswordAuthentication no
EnsureSshSetting Protocol 2
EnsureSshSetting ClientAliveInterval 1800
EnsureSshSetting ClientAliveCountMax 0
EnsureSshSetting HostbasedAuthentication no
EnsureSshSetting MaxStartups 2
EnsureSshSetting AllowTcpForwarding no
EnsureSshSetting X11Forwarding no
EnsureSshSetting StrictModes yes
EnsureSshSetting UsePAM no

# reboot voor het gemak ...
#
echo "rebooting ..."
reboot now

