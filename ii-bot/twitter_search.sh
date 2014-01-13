#!/bin/bash

icerockettail "{{ search.query }}" -n 0 | plag 2 > irc/{{ server_address }}/#{{ search.chan }}/in
