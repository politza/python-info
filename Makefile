# Build python info documentation.  Creates python-$version.info.gz files
# in the current directory. Example:
#
# make python-3.3.0.info.gz

# Where to look for and put python distributions.
PYDISTSDIR ?= .
# The sphinx-build program.
SPHINX ?= $(shell which sphinx-build)
# Root url for downloading python distributions.
PYURL ?= http://www.python.org/ftp/python
SPHINXFLAGS ?= -q

DEFAULT := python-$(shell python --version 2>&1 | cut -d ' ' -f2).info.gz

TEXI=$(PYDISTSDIR)/Python-%/Doc/build/texinfo/python.texi
DIST=$(PYDISTSDIR)/Python-%

.PRECIOUS: $(TEXI) $(DIST)
.PHONY: all install-sphinx

all: $(DEFAULT)

python-%.info.gz: python-%.info
	gzip python-$*.info

python-%.info: $(TEXI) 
	+$(MAKE) -C "$(PYDISTSDIR)/Python-$*/Doc/build/texinfo"
	cp -v "$(PYDISTSDIR)/Python-$*/Doc/build/texinfo/python.info" \
		"python-$*.info"

$(TEXI): $(DIST)
	@if ! which $(SPHINX) >/dev/null 2>&1; then \
		echo "You need to install sphinx first"; \
		false; \
	fi
	cd "$(PYDISTSDIR)/Python-$*/Doc" && \
		$(SPHINX) $(SPHINXFLAGS) -b texinfo \
			-d build/doctrees . build/texinfo

$(DIST): $(DIST).tgz
	tar xzf "$@.tgz" 

$(DIST).tgz: 
	wget "$(PYURL)/$*/Python-$*.tgz" -O "$@"

