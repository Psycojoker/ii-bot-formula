include:
  - supervisor_latest

ii-bot_pkg:
  pkg.installed:
    - name: ii

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
    - name: /var/ii/{{ bot.name }}/reconnection_{{ server_address }}.sh
    - source: salt://ii-bot/reconnection.sh
    - template: jinja
    - user: ii
    - group: ii
    - context:
      bot: {{ bot }}
      server: {{ server }}
      server_address: {{ server_address }}
    - watch_in:
      - cmd: {{ bot.name }}restart_reconnection_loop

{{ bot.name }}_{{ server_address|replace(".", "_") }}_restart_reconnection_loop:
  cmd.wait:
    - name: supervisorctl restart {{ bot.name }}_reconnection_loop
    - require:
      - file: /etc/supervisor/conf.d/{{ bot.name }}.conf
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
    - require:
      - file: {{ bot.name }}_reconnection_loop_script
{% endfor %}
