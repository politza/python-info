#### Build python info documentation.

### Settable Variables
# The sphinx-build program.
SPHINX ?= sphinx-build
# Root url for downloading python distributions.
PYURL ?= http://www.python.org/ftp/python
# Flags for sphinx-build
SPHINXFLAGS ?= -q
# Where to install the info files.
INFODIR ?= $(HOME)/.emacs.d/info
# Create info files for this python executable.
PYTHON ?= python
# Create info files for this python version.
PYVERSION ?= $(shell $(PYTHON) --version 2>&1 | cut -d ' ' -f2)


###
CONF_COOKIE=\#BEGIN texinfo
DOC_DIR=build/Python-$(PYVERSION)/Doc
BUILD_DIR=$(DOC_DIR)/build/texinfo
TEXI=$(BUILD_DIR)/python-$(PYVERSION).texi
INFO=$(BUILD_DIR)/python-$(PYVERSION).info
CONF=$(DOC_DIR)/conf.py
infodir = $(INFODIR)

export infodir 

.PHONY: all clean install uninstall distclean

all: $(TEXI)
	+$(MAKE) -C $(BUILD_DIR)

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
	touch $(BUILD_DIR)/*


$(BUILD_DIR): build/Python-$(PYVERSION).tgz
	tar xzf "$<" -C build
	touch build/Python-$(PYVERSION)

build/Python-$(PYVERSION).tgz:
	mkdir -p build
	wget "$(PYURL)/$(PYVERSION)/Python-$(PYVERSION).tgz" -O "$@" 

install: all 
	+$(MAKE) -C "$(BUILD_DIR)" install-info

uninstall: 
	+$(MAKE) -C "$(BUILD_DIR)" uninstall-info

clean:
	-[ -d "$(BUILD_DIR)" ] && $(MAKE) -C "$(BUILD_DIR)" clean

distclean: clean
	rm -rf -- build
