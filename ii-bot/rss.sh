#!/bin/bash

feedstail -u "{{ rss.url }}" -n 0 -i 120 -f "{title} - {link}" -K -r -e -k "title" > irc/{{ server_address }}/#{{ rss.chan }}/in
