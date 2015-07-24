
# LIGHTMETER USB READOUT version 4.1 (21.5.2009)

 free software under GPL (based on fsusb_demo for HIDs attached
 to the Microchip PICDEM FS USB Demo board)

This software is distributed in the hope that it will be useful, but
**WITHOUT ANY WARRANTY**; without even the implied warranty of
**MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**.  See the GNU
General Public License for more details.

 requires libusb
 tested under Fedora 10 (64 bit on an AMD X2)
              Ubuntu 8.04 (64 bit on an IntelCore2 Duo)
              Ubuntu 9.04 (64 bit on an IntelCore2 Duo)
 under operation @ Innsbruck observatory under Ubuntu 9.04
              (32 bit on an AMD Athlon 1.3GHz)
 but it us rather strictly ANSI C and thus should work
 with alls distributions providing libusb.

*S. Kimeswenger, University Innsbruck, Austria
 Institute of Astro- and Particle Physics*

 version 4.1
 changes: 
    - as the USB devices are running offline from time to time
      a recovery was implemented dealing even with a complete internal reset
      (occurs only when trying to read the temperature)
    - all "non data" lines start with the character # 
      (for easier filtering with plot programs)
    - USB errors / resets are indicated in the output file
    



--------------------------------------------------------------------
## INSTALL

1)
Installation of additional library: libusb
Fedora:
```
yum install libusb
```
Ubuntu & Debian:
```
apt-get install libusb
```

2)
change to destination directory e.g.:
```
cd /usr/local
```
unpack source and compile it
```
unzip LinuxLight.zip
cd LightmeterLinux
make
```

3)
change to user root or do setup with sudo:
    Fedora:
```
su root
make setup
```
    Ubuntu & Debian:
```
sudo make setup
```
--------------------------------------------------------------------
## RUNNING:

```
lightmeter_usb [sampling]
```
*the (optional) parameter sets the intervals between readouts in seconds (default = 1 second)*

The program writes to the terminal/screen stdout
With e.g.
```
lightmeter_usb 5 > Light_`date +%Y_%m_%d_%H_%M`.dat &
```
it will write every 5 seconds to a file with the starting date in the
name: Light_YYYY_MM_DD_hh_mm.dat

----------------------------------------------------------------------

## AUTOMATIC RUNNING:

I have a cron jobs setup to rotate the logfiles every 24 hours
(@ noon) and send those files to my web server. For the automated copy
to the web server the accounts have to be connected with an ssh key
(see "man ssh-keygen" for details)

A)
I am using script "start_lightmeter" to start it after reboot and the
command line /home/stefan/start_lightmeter in the file /etc/rc.local
(Ubuntu and Debian) or /etc/rc5.d/S99local (Fedora)

```
#!/bin/csh
cd /home/stefan
if (-e /home/stefan/data.txt) gzip /home/stefan/data.txt
if (-e /home/stefan/data.txt.gz) \
   scp -q data.txt.gz \
   stefan@ast7.uibk.ac.at:public_html/LIGHT/light_ibk_60cm_`date +%Y_%m_%d_%H_%M`dat.gz
rm -f data.txt.gz
nohup /home/stefan/lightmeter_usb > /home/stefan/data.txt &
```
B)
The crontab file has an entry:
```
# exchange the measurement always at noon
# m h dom mon dow user	command
00 12 * * *	/home/stefan/rotate_log
```

and a script "rotate_log" for rotation of the logfiles (here Ubuntu /
Debian version - fedora user have to run / add it to the system-wide
crontab and may remove the section: echo 'MY_USER_PASSWORD' | sudo -S kill

```
#!/bin/csh
cd /home/stefan
# stop the current measurement
(echo 'MY_USER_PASSWORD' | sudo -S kill -HUP `pgrep  lightmeter_usb` >& /dev/null) > /dev/null
sleep 1
if (-e /home/stefan/data.txt) gzip /home/stefan/data.txt
if (-e /home/stefan/data.txt.gz) \
   scp -q data.txt.gz \
   stefan@ast7.uibk.ac.at:public_html/LIGHT/light_ibk_60cm_`date +%Y_%m_%d_%H_%M`dat.gz
rm -f data.txt.gz
# start a new one
nohup /home/stefan/lightmeter_usb > /home/stefan/data.txt &
```
