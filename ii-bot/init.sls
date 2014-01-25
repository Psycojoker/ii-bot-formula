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
      - icerockettail>=0.1.3
      - ii-twitter
    - require:
      - pkg: ii-bot_pkg

ii:
  user.present

{% for bot_name, bot in pillar.get("ii-bots", {}).items() %}
/var/ii/{{ bot_name }}/:
  file.directory:
    - user: ii
    - makedirs: True

{% for server_address, server in bot.get("servers", {}).items() %}
{{ bot_name }}_{{ server_address|replace(".", "_") }}_reconnection_loop_script:
  file.managed:
    - name: /var/ii/{{ bot_name }}/reconnection_{{ server_address|replace(".", "_") }}.sh
    - source: salt://ii-bot/reconnection.sh
    - template: jinja
    - user: ii
    - group: ii
    - context:
      bot: {{ bot }}
      bot_name: {{ bot_name }}
      server: {{ server }}
      server_address: {{ server_address }}
    - watch_in:
      - cmd: {{ bot_name }}_{{ server_address|replace(".", "_") }}_restart_reconnection_loop
    - require_in:
      - file: /etc/supervisor/conf.d/{{ bot_name }}.conf

{{ bot_name }}_{{ server_address|replace(".", "_") }}_restart_reconnection_loop:
  cmd.wait:
    - name: supervisorctl restart {{ bot_name }}_{{ server_address|replace(".", "_") }}_reconnection_loop
    - require:
      - file: /etc/supervisor/conf.d/{{ bot_name }}.conf

{% include "ii-bot/rss.sls" %}
{% include "ii-bot/twitter_search.sls" %}
{% endfor %}

/etc/supervisor/conf.d/{{ bot_name }}.conf:
  file.managed:
    - source: salt://ii-bot/supervisor.conf
    - template: jinja
    - user: ii
    - group: ii
    - context:
      bot: {{ bot }}
      bot_name: {{ bot_name }}
    - watch_in:
      - cmd: supervisor_latest-update
{% endfor %}
