{% for search_name, search in server.get("twitter_search", {}).items() %}
/var/ii/{{ bot_name }}/twitter_search_{{ search_name }}_{{ server_address|replace(".", "_") }}.sh:
  file.managed:
    - source: salt://ii-bot/twitter_search.sh
    - user: ii
    - group: ii
    - template: jinja
    - context:
      search: {{ search }}
      search_name: {{ search_name }}
      server_address: {{ server_address }}
    - watch_in:
      - cmd: {{ bot_name }}_{{ server_address|replace(".", "_") }}_twitter_search_{{ search_name }}
    - require_in:
      - file: /etc/supervisor/conf.d/{{ bot_name }}.conf

{{ bot_name }}_{{ server_address|replace(".", "_") }}_twitter_search_{{ search_name }}:
  cmd.wait:
    - name: supervisorctl restart {{ bot_name }}_{{ server_address|replace(".", "_") }}_twitter_search_{{ search_name }}
    - require:
      - file: /etc/supervisor/conf.d/{{ bot_name }}.conf
{% endfor %}
