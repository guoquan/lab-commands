#!/usr/bin/make -f

# Install lab commands

# Source directory
srcdir = $(shell pwd)
mkfdir := $(abspath $(lastword $(MAKEFILE_LIST)))

# Common prefix for installation directories.
# NOTE: This directory must exist when you start the install.
prefix = /usr/local
datarootdir = $(prefix)/share
datadir = $(datarootdir)
exec_prefix = $(prefix)
# Where to put the executable for the command 'gcc'.
bindir = $(exec_prefix)/bin
# Where to put the directories used by the compiler.
libexecdir = $(exec_prefix)/libexec
# Where to put the Info files.
infodir = $(datarootdir)/info

INSTALL = mkdir -p $(DESTDIR)$(bindir)/ && ln -sf
# INSTALL = install -D

subs = new new-large port start restart passwd

.PHONY: install
install: lab $(subs)

lab: $(srcdir)/lab.sh
	$(INSTALL) $< $(DESTDIR)$(bindir)/lab

%: $(srcdir)/lab-%.sh
	$(INSTALL) $< $(DESTDIR)$(bindir)/lab-$@
