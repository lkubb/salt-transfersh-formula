# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as transfersh with context %}

include:
  - {{ sls_config_clean }}

{%- if transfersh.install.autoupdate_service %}

Podman autoupdate service is disabled for transfer.sh:
{%-   if transfersh.install.rootless %}
  compose.systemd_service_disabled:
    - user: {{ transfersh.lookup.user.name }}
{%-   else %}
  service.disabled:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}

transfer.sh is absent:
  compose.removed:
    - name: {{ transfersh.lookup.paths.compose }}
    - volumes: {{ transfersh.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if transfersh.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ transfersh.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if transfersh.install.rootless %}
    - user: {{ transfersh.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

transfer.sh compose file is absent:
  file.absent:
    - name: {{ transfersh.lookup.paths.compose }}
    - require:
      - transfer.sh is absent

transfer.sh user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ transfersh.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ transfersh.lookup.user.name }}

transfer.sh user account is absent:
  user.absent:
    - name: {{ transfersh.lookup.user.name }}
    - purge: {{ transfersh.install.remove_all_data_for_sure }}
    - require:
      - transfer.sh is absent
    - retry:
        attempts: 5
        interval: 2

{%- if transfersh.install.remove_all_data_for_sure %}

transfer.sh paths are absent:
  file.absent:
    - names:
      - {{ transfersh.lookup.paths.base }}
    - require:
      - transfer.sh is absent
{%- endif %}
