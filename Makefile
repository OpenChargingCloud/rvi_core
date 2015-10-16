#
# Copyright (C) 2014, Jaguar Land Rover
#
# This program is licensed under the terms and conditions of the
# Mozilla Public License, version 2.0.  The full text of the 
# Mozilla Public License is at https://www.mozilla.org/MPL/2.0/
#

#
# Makefile for the RVI node.
# 

.PHONY:	all deps compile clean rpm rpmclean test xref ci

CORE_UPSTREAM := rvi-core_0.4.0.orig.tar.gz
CLIENT_UPSTREAM := rvi-client_0.4.0.orig.tar.gz
SERVER_UPSTREAM := rvi-server_0.4.0.orig.tar.gz

SCRIPTS=scripts/setup_gen \
	scripts/author

VERSION=0.4.0

all: deps compile escript

deps:
	./rebar get-deps

compile:
	./rebar  compile

escript: compile ${SCRIPTS}

recomp:
	./rebar  compile skip_deps=true

scripts/setup_gen: deps/setup/setup_gen
	cp deps/setup/setup_gen scripts/

scripts/author: components/authorize/author
	cp components/authorize/author scripts/

components/authorize/author:
	(cd components/authorize && make escript)

clean:   rpmclean
	./rebar clean

rpmclean:
	rm -rf ./rpm/BUILD/* \
		./rpm/BUILDROOT/* \
		./rpm/RPMS/* \
		./rpm/SOURCES/* \
		./rpm/SRPMS/*

xref: compile
	ERL_LIBS=$(PWD):$(PWD)/components:$(PWD)/deps rebar xref skip_deps=true

ci: xref test

test: compile
	rebar ct

# Create a SOURCES tarball for RPM
rpm_tarball: rpmclean clean
	tar czf /tmp/rvi_core-$(VERSION).tgz BUILD.md CONFIGURE.md doc \
		LICENSE Makefile README.md rebar rebar.config rel \
		RELEASE.md rpm scripts/setup_gen scripts/rvi \
		scripts/rvi.service scripts/rvi_node.sh  components \
		rvi_sample.config scripts/setup_rvi_node.sh src \
		tizen.config TODO 
	mv /tmp/rvi-$(VERSION).tgz ./rpm/SOURCES/


rpm:	rpm_tarball
	rpmbuild --define "_topdir $$PWD/rpm" -ba rpm/SPECS/rvi-$(VERSION).spec

deb_core: deps compile escript
	tar czf pkg-core/$(CORE_UPSTREAM) components deps ebin priv rel scripts
	cd pkg-core/rvi-core_0.4.0 && tar xzf ../$(CORE_UPSTREAM) && debuild

deb_client:
	tar czf pkg-client/$(CLIENT_UPSTREAM) rvi_client.config sota_certs_client sota_keys rvi_client.service rvi_client
	cd pkg-client/rvi-client_0.4.0 && tar xzf ../$(CLIENT_UPSTREAM) && debuild

deb_server:
	tar czf pkg-server/$(SERVER_UPSTREAM) rvi_server.config sota_certs_server sota_keys rvi_server.service
	cd pkg-server/rvi-server_0.4.0 && tar xzf ../$(SERVER_UPSTREAM) && debuild

deb_clean:
	rm -fr pkg-*/*.tar.gz
	rm -fr pkg-*/*.tar.xz
	rm -fr pkg-*/*.dsc
	rm -fr pkg-*/*.build
	rm -fr pkg-*/*.changes
	rm -fr pkg-*/*.deb
	rm -fr pkg-*/*_0.4.0/debian/*.substvars
	rm -fr pkg-*/*_0.4.0/debian/*.log
	rm -fr pkg-core/rvi-core_0.4.0/debian/rvi-core
	rm -fr pkg-core/rvi-core_0.4.0/{components,deps,ebin,priv,rel,scripts}
	rm -fr pkg-client/rvi-client_0.4.0/debian/rvi-client
	rm -fr pkg-client/rvi-client_0.4.0/{rvi_client.config,rvi_client.service,sota_certs_client,sota_keys,rvi_client}
	rm -fr pkg-server/rvi-server_0.4.0/debian/rvi-server
	rm -fr pkg-server/rvi-server_0.4.0/{rvi_server.config,rvi_server.service,sota_certs_server,sota_keys}
