#!/bin/csh
setenv CFLAGS -fPIC 
./configure --enable-apache2=/usr/local/sbin/apxs --prefix=/var/lib/cosign --sbindir=/usr/local/sbin --mandir=/usr/local/share/man --with-filterdb=/var/lib/cosign/filter --with-cosigndb=/var/lib/cosign/daemon --with-cosignconf=/etc/cosign/cosign.conf --with-cosigncadir=/etc/cosign/certs/CA --with-cosigncert=/etc/cosign/certs/cosignd.crt --with-cosignkey=/etc/cosign/certs/cosignd.key
