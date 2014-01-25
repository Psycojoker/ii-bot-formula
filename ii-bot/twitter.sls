{% for twitter_name, twitter in server.get("twitter", {}).items() %}
{% for chan in twitter.chans %}
supervisorctl restart {{ bot_name }}_{{ server_address|replace(".", "_") }}_twitter_{{ twitter_name }}:
  cmd.wait:
    - watch:
      - pip: ii-twitter>=0.1.1
    - require:
      - file: /etc/supervisor/conf.d/{{ bot_name }}.conf
{% endfor %}
{% endfor %}
