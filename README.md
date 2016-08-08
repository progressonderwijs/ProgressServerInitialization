# Minimalistische VM initialization totdat het netwerk werkt.
- Login op 'Ebbo' machine (alleen Herman en Patrick kunnen hierbij)
- Open VPN-verbinding naar CIT-beheer-LAN (alleen Herman en Patrick kunnen hierbij)
- Login op VCenter (VMWare manager) (alleen Herman en Patrick kunnen hierbij)
- Start virtuele machine progress-[omgeving]-fw (firewall/vpn machine).
- Open console en login op de VM machine (account: root; wachtwoord: staat in de keepass database in het lokale netwerk Deployment.kdbx)
- Gebruik de nano-editor om ``/etc/network/interfaces`` te muteren
  - Pas in het ip-adres 'xx' zodat de server het juiste ip-adres volgens het document [IP-adressen](https://docs.google.com/spreadsheets/d/1HuwTlIPyJGBvm1ekwYYNoRU1OrUuSvMnAWAWMAYAPAQ/edit?usp=sharing) krijgt
  - Zet eth0 aan door het '#' te verwijderen
- Herstart netwerk met ``/etc/init.d/networking restart``
- Download het ssh-installatiescript met ``./wget_script.sh``
- Run het ssh-installatiescript ``./ssh_install.sh`` (dit duurt ca 3 minuten)
- Het script vraag om het wachtwoord voor user progadmin. Dit staat in de keepass database in het lokale netwerk Deployment.kdbx.
- Na ca 1 minuut is het script klaar (inclusief een reboot). De console staat nu op de inlogprompt.

NB: Dit script installeert alleen de initiele ssh; voor verdere configuratie de [systeembeheer](https://github.com/progressonderwijs/systeembeheer/tree/master/linux-machines) repo gebruiken.
