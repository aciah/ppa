PACKAGE=aciah
VERSION=$(shell cat VERSION)

prefix = /usr/local
deb_files = ppa/$(PACKAGE)_$(VERSION)-1_amd64.deb \
	    ppa/Packages \
	    ppa/Packages.gz \
	    ppa/Release \
	    ppa/Release.gpg \
	    ppa/InRelease

SCRIPTS := $(wildcard src/scripts/*.sh)
TARGETS := $(patsubst src/scripts/%.sh,$(DESTDIR)$(prefix)/bin/aciah_%,$(SCRIPTS))

install: $(TARGETS)
$(DESTDIR)$(prefix)/bin/aciah_%: src/scripts/%.sh
	install -D $< $@

uninstall:
	-rm -f $(TARGETS)

archive: $(PACKAGE)-$(VERSION).tar.gz
$(PACKAGE)-$(VERSION).tar.gz: src/scripts/*.sh VERSION debian/* Makefile
	# Create temporary directory
	mkdir -p /tmp/$(PACKAGE)-$(VERSION)
	cp -r ./* /tmp/$(PACKAGE)-$(VERSION)
	mv /tmp/$(PACKAGE)-$(VERSION) .
	# Create tarball
	tar cfz $(PACKAGE)-$(VERSION).tar.gz $(PACKAGE)-$(VERSION)
	# Remove temporary directory
	rm -r $(PACKAGE)-$(VERSION)

package: $(deb_files)
$(deb_files): $(PACKAGE)-$(VERSION).tar.gz
	# Build docker image
	docker build -t aciah_ppa -f docker/Dockerfile .
	# Package in a container
	mkdir -p ./ppa
	docker run --rm \
	    -v "./$(PACKAGE)-$(VERSION).tar.gz:/orig/$(PACKAGE)-$(VERSION).tar.gz" \
	    -v ./ppa:/ppa \
	    -v ./key.asc:/key.asc \
	    -e PACKAGE="$(PACKAGE)" \
	    -e VERSION="$(VERSION)" \
	    aciah_ppa

clean:
	rm -f $(PACKAGE)-$(VERSION).tar.gz
	rm -f $(deb_files)

decrypt-key: key.asc
key.asc: key.asc.gpg
	gpg --decrypt key.asc.gpg > key.asc


.PHONY: install uninstall archive package clean decrypt-key
