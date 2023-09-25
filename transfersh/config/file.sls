# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as transfersh with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

transfer.sh environment files are managed:
  file.managed:
    - names:
      - {{ transfersh.lookup.paths.config_transfersh }}:
        - source: {{ files_switch(
                        ["transfersh.env", "transfersh.env.j2"],
                        config=transfersh,
                        lookup="transfersh environment file is managed",
                        indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ transfersh.lookup.user.name }}
    - makedirs: true
    - template: jinja
    - require:
      - user: {{ transfersh.lookup.user.name }}
    - require_in:
      - transfer.sh is installed
    - context:
        transfersh: {{ transfersh | json }}
