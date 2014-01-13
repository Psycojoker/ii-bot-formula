#!/bin/bash

icerockettail "{{ search.query }}" -n 0 > irc/{{ server_address }}/#{{ search.chan }}/in
