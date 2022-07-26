# -*- coding: utf-8 -*-
# vim: ft=yaml
---
transfersh:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: transfersh
      remove_orphans: true
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        restart_sec: 2
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/transfersh
      compose: docker-compose.yml
      config_transfersh: transfersh.env
      data: data
    user:
      groups: []
      home: null
      name: transfersh
      shell: /usr/sbin/nologin
      uid: null
      gid: null
    containers:
      transfersh:
        image: docker.io/dutchcoders/transfer.sh:latest-noroot
  install:
    rootless: true
    remove_all_data_for_sure: false
  config:
    basedir: /data
    listener: 127.0.0.1:7435
    provider: local

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://transfersh/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   transfersh-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      transfer.sh environment file is managed:
      - transfersh.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
