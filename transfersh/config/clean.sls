# vim: ft=sls

{#-
    Removes the configuration of the transfersh containers
    and has a dependency on `transfersh.service.clean`_.

    This does not lead to the containers/services being rebuilt
    and thus differs from the usual behavior.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as transfersh with context %}

include:
  - {{ sls_service_clean }}

transfer.sh environment files are absent:
  file.absent:
    - names:
      - {{ transfersh.lookup.paths.config_transfersh }}
    - require:
      - sls: {{ sls_service_clean }}
