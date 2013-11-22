#### Build python info documentation.

### Settable Variables
# The sphinx-build program.
SPHINX ?= sphinx-build
# Root url for downloading python distributions.
PYURL ?= http://www.python.org/ftp/python
# Flags for sphinx-build
SPHINXFLAGS ?= -q
# GZip the info file (.gz or empty)
GZIPEXT=.gz
# Where to install the info files.
INFODIR ?= $(HOME)/.emacs.d/info
# Create info files for this python executable.
PYTHON ?= python
# Create info files for this python version.
PYVERSION ?= $(shell $(PYTHON) --version 2>&1 | cut -d ' ' -f2)

###
CONF_COOKIE=\#BEGIN texinfo
DIST=build/Python-$(PYVERSION).tgz
DOC_DIR=build/Python-$(PYVERSION)/Doc
BUILD_DIR=$(DOC_DIR)/build/texinfo
CONF=$(DOC_DIR)/conf.py
TEXI=$(BUILD_DIR)/python-$(PYVERSION).texi
INFO=python-$(PYVERSION).info
ZINFO=$(INFO)$(GZIPEXT)

.PHONY: all clean install uninstall cleanall

all: $(ZINFO)

$(ZINFO): $(TEXI)
	makeinfo --no-split -o $(INFO) $<
	[ -n "$(GZIPEXT)" ] && gzip $(INFO)

$(TEXI): $(BUILD_DIR)
	@if ! which $(SPHINX) >/dev/null 2>&1; then		\
		echo "You need to install sphinx first";	\
		false;						\
	fi
	@if ! grep -q "$(CONF_COOKIE)" "$(CONF)"; then		\
		echo "Appending conf.py to $(CONF)";		\
		sed -e 's/\(^\|[^%]\)%s/\1$(PYVERSION)/g'	\
			-e 's/%%/%/g' conf.py			\
			>> "$(CONF)";				\
	fi	
	cd "$(DOC_DIR)" && \
		$(SPHINX) $(SPHINXFLAGS) -b texinfo \
			-d build/doctrees . build/texinfo

$(BUILD_DIR): $(DIST)
	tar xzf "$<" -C build
	touch build/Python-$(PYVERSION)

$(DIST):
	mkdir -p build
	wget "$(PYURL)/$(PYVERSION)/Python-$(PYVERSION).tgz" -O "$@" 

install: all
	cp -t $(INFODIR) $(ZINFO)
	install-info --info-dir="$(INFODIR)" $(ZINFO)

uninstall: all
	rm -f -- "$(INFODIR)/$(ZINFO)"
	install-info --delete --info-dir="$(INFODIR)" $(ZINFO)

clean:
	rm -rf -- build/Python-$(PYVERSION)
	rm -f -- $(ZINFO)

cleanall: 
	rm -rf -- build
	rm -f -- python-*.info$(GZIPEXT)
