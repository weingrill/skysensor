#
# Makefile for LightMeterLinux
# S. Kimeswenger, Innsbruck
#
# 2013-10-07 deactivate C++ warning (new CFLAGS); GW
#
#CFLAGS = -Wall -Werror -Wstrict-prototypes -O0 -static -g
CFLAGS = -Werror -Wstrict-prototypes -O0 -static -g

all: lightmeter_usb_v5.0.o
	cc $(CFLAGS) lightmeter_usb_v5.0.o -o lightmeter_usb5 -lusb

# for the setup root permissions are required
setup:
	chown root.root lightmeter_usb5
	chmod 7755 lightmeter_usb5
	ln -s `pwd`/lightmeter_usb5 /usr/local/bin/lightmeter_usb5

clean:
	rm -f *.o lightmeter_usb5
