include:
  - supervisor_latest

ii-bot_pkg:
  pkg.installed:
    - pkgs:
      - ii
      - python-pip

ii-bot_pip_pkg:
  pip.installed:
    - names:
      - feedstail
      - pipetk
      - icerockettail
    - require:
      - pkg: ii-bot_pkg

ii:
  user.present

{% for bot in pillar.get("ii-bots", []) %}
/var/ii/{{ bot.name }}/:
  file.directory:
    - user: ii
    - makedirs: True

{% for server_address, server in bot.get("servers", {}).items() %}
{{ bot.name }}_{{ server_address|replace(".", "_") }}_reconnection_loop_script:
  file.managed:
    - name: /var/ii/{{ bot.name }}/reconnection_{{ server_address|replace(".", "_") }}.sh
    - source: salt://ii-bot/reconnection.sh
    - template: jinja
    - user: ii
    - group: ii
    - context:
      bot: {{ bot }}
      server: {{ server }}
      server_address: {{ server_address }}
    - watch_in:
      - cmd: {{ bot.name }}_{{ server_address|replace(".", "_") }}_restart_reconnection_loop
    - require_in:
      - file: /etc/supervisor/conf.d/{{ bot.name }}.conf

{{ bot.name }}_{{ server_address|replace(".", "_") }}_restart_reconnection_loop:
  cmd.wait:
    - name: supervisorctl restart {{ bot.name }}_{{ server_address|replace(".", "_") }}_reconnection_loop
    - require:
      - file: /etc/supervisor/conf.d/{{ bot.name }}.conf

{% for rss in server.get("rss", []) %}
/var/ii/{{ bot.name }}/rss_{{ rss.name }}_{{ server_address|replace(".", "_") }}.sh:
  file.managed:
    - source: salt://ii-bot/rss.sh
    - user: ii
    - group: ii
    - template: jinja
    - context:
      rss: {{ rss }}
      server_address: {{ server_address }}
    - watch_in:
      - cmd: {{ bot.name }}_{{ server_address|replace(".", "_") }}_rss_{{ rss.name }}
    - require_in:
      - file: /etc/supervisor/conf.d/{{ bot.name }}.conf

{{ bot.name }}_{{ server_address|replace(".", "_") }}_rss_{{ rss.name }}:
  cmd.wait:
    - name: supervisorctl restart {{ bot.name }}_{{ server_address|replace(".", "_") }}_rss_{{ rss.name }}
    - require:
      - file: /etc/supervisor/conf.d/{{ bot.name }}.conf
{% endfor %}

{% for search in server.get("twitter_search", []) %}
/var/ii/{{ bot.name }}/twitter_search_{{ search.name }}_{{ server_address|replace(".", "_") }}.sh:
  file.managed:
    - source: salt://ii-bot/twitter_search.sh
    - user: ii
    - group: ii
    - template: jinja
    - context:
      search: {{ search }}
      server_address: {{ server_address }}
    - watch_in:
      - cmd: {{ bot.name }}_{{ server_address|replace(".", "_") }}_twitter_search_{{ search.name }}
    - require_in:
      - file: /etc/supervisor/conf.d/{{ bot.name }}.conf

{{ bot.name }}_{{ server_address|replace(".", "_") }}_twitter_search_{{ search.name }}:
  cmd.wait:
    - name: supervisorctl restart {{ bot.name }}_{{ server_address|replace(".", "_") }}_twitter_search_{{ search.name }}
    - require:
      - file: /etc/supervisor/conf.d/{{ bot.name }}.conf
{% endfor %}

{% endfor %}

/etc/supervisor/conf.d/{{ bot.name }}.conf:
  file.managed:
    - source: salt://ii-bot/supervisor.conf
    - template: jinja
    - user: ii
    - group: ii
    - context:
      bot: {{ bot }}
    - watch_in:
      - cmd: supervisor_latest-update
{% endfor %}
