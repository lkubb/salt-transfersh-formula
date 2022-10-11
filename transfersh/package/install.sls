# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as transfersh with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

transfer.sh user account is present:
  user.present:
{%- for param, val in transfersh.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ transfersh.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

transfer.sh user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ transfersh.lookup.user.name }}
    - enable: {{ transfersh.install.rootless }}
    - require:
      - user: {{ transfersh.lookup.user.name }}

transfer.sh paths are present:
  file.directory:
    - names:
      - {{ transfersh.lookup.paths.base }}
    - user: {{ transfersh.lookup.user.name }}
    - group: {{ transfersh.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ transfersh.lookup.user.name }}

transfer.sh compose file is managed:
  file.managed:
    - name: {{ transfersh.lookup.paths.compose }}
    - source: {{ files_switch(['docker-compose.yml', 'docker-compose.yml.j2'],
                              lookup='transfer.sh compose file is present'
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ transfersh.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - makedirs: true
    - context:
        transfersh: {{ transfersh | json }}

transfer.sh is installed:
  compose.installed:
    - name: {{ transfersh.lookup.paths.compose }}
{%- for param, val in transfersh.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in transfersh.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ transfersh.lookup.paths.compose }}
{%- if transfersh.install.rootless %}
    - user: {{ transfersh.lookup.user.name }}
    - require:
      - user: {{ transfersh.lookup.user.name }}
{%- endif %}

{%- if transfersh.install.autoupdate_service is not none %}

Podman autoupdate service is managed for transfer.sh:
{%-   if transfersh.install.rootless %}
  compose.systemd_service_{{ "enabled" if transfersh.install.autoupdate_service else "disabled" }}:
    - user: {{ transfersh.lookup.user.name }}
{%-   else %}
  service.{{ "enabled" if transfersh.install.autoupdate_service else "disabled" }}:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}
