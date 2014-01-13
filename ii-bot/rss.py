#!/usr/bin/env python

feedstail -u "$@" -n 0 -i 120 -f "{title} - {link}" -K -r -e -k "title"
