# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``transfersh`` meta-state
    in reverse order, i.e. stops the transfersh services,
    removes their configuration and then removes their containers.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
