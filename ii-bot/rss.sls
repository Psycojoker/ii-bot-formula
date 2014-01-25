{% for rss_name, rss in server.get("rss", {}).items() %}
/var/ii/{{ bot_name }}/rss_{{ rss_name }}_{{ server_address|replace(".", "_") }}.sh:
  file.managed:
    - source: salt://ii-bot/rss.sh
    - user: ii
    - group: ii
    - template: jinja
    - context:
      rss: {{ rss }}
      rss_name: {{ rss_name }}
      server_address: {{ server_address }}
    - watch_in:
      - cmd: {{ bot_name }}_{{ server_address|replace(".", "_") }}_rss_{{ rss_name }}
    - require_in:
      - file: /etc/supervisor/conf.d/{{ bot_name }}.conf

{{ bot_name }}_{{ server_address|replace(".", "_") }}_rss_{{ rss_name }}:
  cmd.wait:
    - name: supervisorctl restart {{ bot_name }}_{{ server_address|replace(".", "_") }}_rss_{{ rss_name }}
    - require:
      - file: /etc/supervisor/conf.d/{{ bot_name }}.conf
{% endfor %}
