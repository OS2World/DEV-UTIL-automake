#! /bin/sh
# Copyright (C) 2006-2013 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Make sure Automake requires AM_PROG_CC_C_O when either per-targets
# flags or subdir-objects are used.

. test-init.sh

cat >>configure.ac <<EOF
AC_PROG_CC
AC_OUTPUT
EOF

cat >Makefile.am <<EOF
bin_PROGRAMS = wish
wish_SOURCES = a.c
wish_CPPFLAGS = -DWHATEVER
EOF

touch a.c

$ACLOCAL
$AUTOCONF
AUTOMAKE_fails --copy --add-missing
grep '^Makefile\.am:2:.*per-target.*AM_PROG_CC_C_O' stderr


cat >Makefile.am <<EOF
bin_PROGRAMS = wish
wish_SOURCES = sub/a.c
EOF

mkdir sub
mv a.c sub

$AUTOMAKE --copy --add-missing

echo 'AUTOMAKE_OPTIONS = subdir-objects' >> Makefile.am
AUTOMAKE_fails --copy --add-missing
grep '^Makefile\.am:2:.*subdir.*AM_PROG_CC_C_O' stderr

:
