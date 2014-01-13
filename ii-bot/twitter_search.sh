#!/bin/bash

icerockettail "{{ search.query }}" > irc/{{ server_address }}/#{{ search.chan }}/in
