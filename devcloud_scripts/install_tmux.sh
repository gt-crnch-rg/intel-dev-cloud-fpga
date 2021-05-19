#!/bin/bash
 
# Script for installing a minimal, yet up-to-date development environment
# It's assumed that wget and a C/C++ compiler are installed.

# MGL Notes
# tmux:
# need if "/usr/bin/ld: cannot find -lc" -> need to install glibc-static
# git: 
# needs zlib-devel, openssl-devel, libcurl-devel, expat-devel, gettext-devel
# needs asciidoc, makeinfo for documentation
 
#Specify comment macros
[ -z $BASH ] || shopt -s expand_aliases
alias BEGINCOMMENT="if [ ]; then"
alias ENDCOMMENT="fi"
####

# exit on error
set -e
 
# create our directories
mkdir -p $HOME/local/src
cd $HOME/local/src
 
#######################
####### Now tmux ######
#######################

build_tmux() {

	#Specify the versions of files so this script can be updated for newer versions
	TMUXV=3.2
	LIBEVENTV=2.1.8-stable
	NCURSESV=6.1

	## download source files for tmux, libevent, and ncurses
	wget https://github.com/tmux/tmux/releases/download/${TMUXV}/tmux-${TMUXV}.tar.gz --no-check-certificate
	wget https://github.com/libevent/libevent/releases/download/release-${LIBEVENTV}/libevent-${LIBEVENTV}.tar.gz --no-check-certificate
	wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-${NCURSESV}.tar.gz
	# 
	## extract files, configure, and compile
	# 
	## libevent #
	tar xvzf libevent-${LIBEVENTV}.tar.gz
	cd libevent-${LIBEVENTV}
	./configure --prefix=$HOME/local --disable-shared
	make -j4
	make install
	cd ..
	rm -rf libevent-${LIBEVENTV}
	rm libevent-${LIBEVENTV}.tar.gz
	# 
	## ncurses #
	tar xvzf ncurses-${NCURSESV}.tar.gz
	cd ncurses-${NCURSESV}
	./configure --prefix=$HOME/local
	make -j4
	make install
	cd ..
	rm ncurses-${NCURSESV}.tar.gz
	rm -rf ncurses-${NCURSESV}

	# tmux #
	tar xvzf tmux-${TMUXV}.tar.gz
	cd tmux-${TMUXV}
	# Compile tmux with static libraries (no shared lib dependencies). Note that this requires that libc.a be installed or the configure script will fail
	#./configure --enable-static CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -static-libgcc -L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include -levent"
	#CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -static-libgcc -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib -levent" make -j4
	# OR compile tmux with shared libraries
	./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include -levent"
	CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib -levent" make -j4
	cp tmux $HOME/local/bin
	cd ..
	rm tmux-${TMUXV}.tar.gz
	rm -rf tmux-${TMUXV}
	 
	echo "$HOME/local/bin/tmux is now available. You can optionally add $HOME/local/bin to your PATH." 

}

#Select which packages to install
build_tmux
