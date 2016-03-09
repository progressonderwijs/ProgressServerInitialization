# ProgressServerInitialization
Repository voor minimalistische VM initialization totdat het netwerk werkt.

- Console login op de VM machine (root).
- Zet eth0 aan met het juiste ip-adres (/etc/network/interfaces + /etc/init.d/networking restart).
- Download het ssh_install script (./wget_script).
- Run het ssh script (./ssh_install.sh).

