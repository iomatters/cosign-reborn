srcdir=		.

CC=	gcc
ALL=	common libsnet libcgi cgi html daemon 
FILTERS=  filters/apache2 
SERVER_TARGETS= cgi html daemon
TARGETS= ${SERVER_TARGETS} ${FILTERS}
OPTOPTS= -Wall -Wmissing-prototypes 
CFLAGS=	${OPTOPTS} -fPIC
LDFLAGS=  -L/usr/local/lib

filters:	${FILTERS}
all:		filters
server:		${ALL}
everything:	${ALL} filters

cgi daemon:	version.o common libsnet
cgi:	libcgi

${ALL}:	version.o

${ALL} filters/apache filters/apache2 filters/lighttpd:	FRC
	cd $@; ${MAKE} ${MFLAGS} all

FRC:

clean:
	rm -f version.o
	for i in ${ALL} ${FILTERS} ; \
	    do (cd $$i; ${MAKE} ${MFLAGS} clean); \
	done

VERSION=3.2.0
DISTDIR=../cosign-${VERSION}

test : everything
	(cd tests && sh ./tests.sh)

dist   : distclean
	mkdir ${DISTDIR}
	tar -c -f - -X EXCLUDE . | tar xpf - -C ${DISTDIR}
	echo ${VERSION} > ${DISTDIR}/VERSION
	sed -e "s@INTERNAL@${VERSION}@" \
		< configure.ac > ${DISTDIR}/configure.ac
	cd "${DISTDIR}"; autoconf; rm -rf autom4te.cache

distclean: clean
	( cd libsnet ; make distclean )
	( cd libcgi ; make distclean )
	rm -f config.log config.status config.cache Makefile \
	  libcgi/Makefile cgi/Makefile html/Makefile daemon/Makefile \
	  filters/apache/Makefile filters/apache2/Makefile \
	  common/Makefile version.c filters/common/cosignpaths.h
	rm -rf autom4te.cache
	( cd tests && rm -rf *.testlog CA certs cosign openssl.cnf tmp )

install:  filters/apache2
	for i in ${FILTERS}; \
	    do (cd $$i; ${MAKE} ${MFLAGS} install); \
	done

install-server : server
	for i in ${SERVER_TARGETS}; \
	    do (cd $$i; ${MAKE} ${MFLAGS} install); \
	done

install-all : everything
	for i in ${TARGETS}; \
	    do (cd $$i; ${MAKE} ${MFLAGS} install); \
	done