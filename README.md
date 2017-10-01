
Install telegraf on your raspberry pi
======================================

    wget https://dl.influxdata.com/telegraf/releases/telegraf-1.4.1_linux_armhf.tar.gz
    tar xf telegraf-1.4.1_linux_armhf.tar.gz
    cp -av telegraf/* /

Systemd script
--------------

Place this in /etc/systemd/system/telegraf.service

    [Unit]
    Description=Telegraf service
    
    [Service]
    ExecStart=/usr/bin/telegraf -config /etc/telegraf/telegraf.conf
    NotifyAccess=main
    #WatchdogSec=10
    Restart=on-failure

then when you're done configuring it in `/etc/telegraf/telegraf.conf` run:

    systemctl enable telegraf
    systemctl start telegraf

To see logs, run

    journalctl -u telegraf -f

Note that you can add more than one `[[inputs.exec]]` stanza.

Temperature monitoring
----------------------

The raspberry pi has a built-in temperature sensor; you can collect data from it by adding
an `inputs.exec` entry, like so:

    [[inputs.exec]]
      command="/root/rpiTemp.sh"
      interval="5s"
      name_suffix="_temperature"
      data_format="json"

This will collect the current temperature in C every 5 seconds.

Asterisk node status monitoring
-------------------------------

To get the node status, add an entry like this:

    [[inputs.exec]]
      command="/root/asterisk_status.sh 44068"
      interval="3s"
      name_suffix="_status_44068"
      data_format="json"

Change `44068` to the appropriate node number, of course!

If you have more than one node you'll want to add an entry for each one.

Astersik node statistics monitoring
-----------------------------------

Not all statistics are useful, but I've tried to extract the ones that are.  Add something like this:

    [[inputs.exec]]
      command="/root/asterisk_stats.sh 46516"
      interval="45s"
      name_suffix="_stats_46516"
      data_format="json"

Change `46516` to your node number.

If you have more than one node you'll want to add an entry for each one

Rigrunner 4005i monitoring
--------------------------

If you randomly happen to have a rigrunner 4005i you can gather stats from that by modifying
`getRigRunnerStats.py` with the correct URL, username, and password, then add a stanza like this one:

    [[inputs.exec]]
      command="/usr/bin/python2.7 /root/getRigRunnerStats.py"
      interval="3s"
      name_suffix="_rigrunner"
      data_format="json"

Note that you'll need to `easy_install requests` and `easy_install xmltodict` for the script to work. Test
it by running it directly first.
