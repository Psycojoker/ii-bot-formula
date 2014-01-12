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
{% endfor %}
