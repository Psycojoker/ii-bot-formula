#!/bin/bash
while true
do
    # if you only have one chan
    {% for chan in bot.get(chans, []) %}
    (sleep 5; echo "/j {{ chan }}" > irc/irc.freenode.net/in) &
    {% endfor %}
    ii \
        -i "irc" \
        -s "irc.freenode.net" \
        -p "6667" \
        -n "{{ bot.name }}" \
        -f "{{ bot.name }}"
done
