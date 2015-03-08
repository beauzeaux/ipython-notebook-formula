{% from "ipython_notebook/map.jinja" import ipython_notebook with context %}

ipython_notebook_deps:
  pkg.installed:
    - pkgs:
      - python
      - python-pip
      - python-dev

{{ ipython_notebook.user }}:
  user.present:
    - fullname: IPython Notebook Server
    - shell: /bin/bash

ipython_notebook:
  pip.installed:
    - name: ipython[notebook]
    - require:
      - pkg: ipython_notebook_deps
    - require_in:
      - service: ipython-notebook-server   

/home/{{ ipython_notebook.user }}/.ipython/profile_default/ipython_notebook_config.py:
  file.managed:
    - source: salt://ipython_notebook/templates/ipython_notebook_config.py.template
    - template: jinja
    - makedirs: True
    - require:
      - user: {{ ipython_notebook.user }}

/etc/init/ipython-notebook-server.conf:
  file.managed:
    - source: salt://ipython_notebook/templates/ipython-notebook-server.conf.template
    - template: jinja
    - makedirs: True
    - user: {{ipython_notebook.user}}
    - mode: 644

ipython-notebook-server:
  service.running:
    - enable: True
    - reload: True