# ProgressServerInitialization
Repository voor minimalistische VM initialization totdat het netwerk werkt.

NB: Dit script installeert alleen de initiele ssh; voor verdere configuratie de [systeembeheer](https://github.com/progressonderwijs/systeembeheer/tree/master/linux-machines) repo gebruiken.

- Console login op de VM machine (root).
- Configureer het ip-adres in /etc/network/interfaces (xx aanpassen) en zet eth0 aan;
- /etc/init.d/networking restart
- Download het ssh_install script (./wget_script).
- Run het ssh script (./ssh_install.sh).

