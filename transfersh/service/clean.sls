# vim: ft=sls

{#-
    Stops the transfersh container services
    and disables them at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as transfersh with context %}

transfersh service is dead:
  compose.dead:
    - name: {{ transfersh.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if transfersh.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ transfersh.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if transfersh.install.rootless %}
    - user: {{ transfersh.lookup.user.name }}
{%- endif %}

transfersh service is disabled:
  compose.disabled:
    - name: {{ transfersh.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if transfersh.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ transfersh.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if transfersh.install.rootless %}
    - user: {{ transfersh.lookup.user.name }}
{%- endif %}
