# ProgressServerInitialization
Repository voor minimalistische VM initialization totdat het netwerk werkt.

- Console login op de VM machine (root).
- Configureer de ip-adressen in /etc/network/interfaces;
  - Voor de firewall: Zet eth0 aan met het juiste externe ip-adres (xx aanpassen)
  - Voor de VPN: verander eth0 => eth1, ipadres uit de tabel en als gateway het interne adres van de firewall
- /etc/init.d/networking restart
- Download het ssh_install script (./wget_script).
- Run het ssh script (./ssh_install.sh).

