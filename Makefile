LIBNAME = xcbada

# This is used to add a postfix to the .gpr filed copied while installing
# We use this for easier integration with Jenkins
# I promise I will find a better way to do this
PROJECTFILE_POSTFIX =

.POSIX:
INSTALL = /usr/bin/install -c
PREFIX = /usr

all: $(LIBNAME)

# -----------------------------------
# Create a xcbada library for objects
# -----------------------------------
# 
xcbada:
	gprbuild -p xcbada_build.gpr

# -----------------------------------
# Maintenance targets
# -----------------------------------
#
# remove editor and compiler generated files
clean:
	gprclean xcbada_build.gpr

# install xcbada
install:
	# make needed dirs
	mkdir -p $(PREFIX)/share/ada/adainclude/$(LIBNAME)/
	mkdir -p $(PREFIX)/lib/ada/adalib/$(LIBNAME)/

	# copy library files
	cp -pr lib/*.ali $(PREFIX)/lib/ada/adalib/$(LIBNAME)/
	cp -pr lib/lib$(LIBNAME).a $(PREFIX)/lib/lib$(LIBNAME).a
	# copy includes
	cp -pr src/*.ads $(PREFIX)/share/ada/adainclude/$(LIBNAME)/
	cp -pr src/*.adb $(PREFIX)/share/ada/adainclude/$(LIBNAME)/
	# copy project file
	cp -p $(LIBNAME)$(PROJECTFILE_POSTFIX).gpr $(PREFIX)/share/ada/adainclude/

	# fix permissions
	/bin/chmod 755 $(PREFIX)/share/ada/ -R
	/bin/chmod 755 $(PREFIX)/lib/ada/ -R

uninstall:
	rm -rf $(PREFIX)/share/ada/adainclude/$(LIBNAME)/
	rm -rf $(PREFIX)/share/ada/adainclude/$(LIBNAME).gpr
	rm -rf $(PREFIX)/lib/ada/adalib/$(LIBNAME)/
	rm -rf $(PREFIX)/lib/lib$(LIBNAME).a

.PHONY: install uninstall clean
