# vim: ft=sls

{#-
    Starts the transfersh container services
    and enables them at boot time.
    Has a dependency on `transfersh.config`_.
#}

include:
  - .running
