#!/bin/bash
while true
do
    # if you only have one chan
    {% for chan in server.get("chans", []) %}
    (sleep 5; echo "/j #{{ chan }}" > irc/{{ server_address }}/in) &
    {% endfor %}
    ii \
        -i "irc" \
        -s "{{ server_address }}" \
        -p "6667" \
        -n "{{ bot.name }}" \
        -f "{{ bot.name }}"
done
