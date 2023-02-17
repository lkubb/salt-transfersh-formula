Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``transfersh``
^^^^^^^^^^^^^^
*Meta-state*.

This installs the transfersh containers,
manages their configuration and starts their services.


``transfersh.package``
^^^^^^^^^^^^^^^^^^^^^^
Installs the transfersh containers only.
This includes creating systemd service units.


``transfersh.config``
^^^^^^^^^^^^^^^^^^^^^
Manages the configuration of the transfersh containers.
Has a dependency on `transfersh.package`_.


``transfersh.service``
^^^^^^^^^^^^^^^^^^^^^^
Starts the transfersh container services
and enables them at boot time.
Has a dependency on `transfersh.config`_.


``transfersh.clean``
^^^^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``transfersh`` meta-state
in reverse order, i.e. stops the transfersh services,
removes their configuration and then removes their containers.


``transfersh.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the transfersh containers
and the corresponding user account and service units.
Has a depency on `transfersh.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``transfersh.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the transfersh containers
and has a dependency on `transfersh.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``transfersh.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the transfersh container services
and disables them at boot time.


