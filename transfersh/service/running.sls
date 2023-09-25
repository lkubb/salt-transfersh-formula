# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as transfersh with context %}

include:
  - {{ sls_config_file }}

transfer.sh service is enabled:
  compose.enabled:
    - name: {{ transfersh.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if transfersh.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ transfersh.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - transfer.sh is installed
{%- if transfersh.install.rootless %}
    - user: {{ transfersh.lookup.user.name }}
{%- endif %}

transfer.sh service is running:
  compose.running:
    - name: {{ transfersh.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if transfersh.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ transfersh.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if transfersh.install.rootless %}
    - user: {{ transfersh.lookup.user.name }}
{%- endif %}
    - watch:
      - transfer.sh is installed
      - sls: {{ sls_config_file }}
