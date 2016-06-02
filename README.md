# ProgressServerInitialization
Repository voor minimalistische VM initialization totdat het netwerk werkt.

NB: Dit script installeert alleen de initiele ssh; voor verdere configuratie de [systeembeheer](https://github.com/progressonderwijs/systeembeheer/tree/master/linux-machines) repo gebruiken.

- Login op 'Ebbo' machine.
- Open VPN-verbinding naar CIT-beheer-LAN.
- Login op VCenter (VMWare manager).
- Start virtuele machine progress-[omgeving]-fw (firewall/vpn machine).
- Open console en login op de VM machine (root).
- Configureer het ip-adres in ``/etc/network/interfaces`` (xx aanpassen) en zet eth0 aan (gebruik b.v. nano als editor);
- Herstart netwerk met ``/etc/init.d/networking restart``
- Download het ssh-installatiescript met ``./wget_script.sh``.
- Run het ssh-installatiescript ``./ssh_install.sh``.
- Voer het wachtwoord in voor user progadmin.

