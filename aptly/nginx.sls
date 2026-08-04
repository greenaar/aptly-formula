# -*- coding: utf-8 -*-
# vim: ft=sls

{%- from "aptly/map.jinja" import aptly with context %}

{#- Publishing the repo over HTTP needs a web server, but this formula
   does not own one. Two modes:

   * use_nginx_formula: true  - include the separate nginx-formula and
     hand off the service to it (the original behaviour).
   * use_nginx_formula: false - the default. Assume nginx is already
     installed and managed elsewhere, drop the vhost in, and reload it
     with a guarded `nginx -s reload`. No dependency on any other
     formula. #}

{%- if aptly.nginx.use_nginx_formula %}
include:
  - nginx
  - nginx.config
{%- endif %}

aptly_site:
  file.managed:
    - name: {{ aptly.nginx.site_file }}
    - source: salt://aptly/files/aptly.jinja
    - template: jinja
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: true
{%- if aptly.nginx.use_nginx_formula %}
    - watch_in:
      - service: nginx
{%- endif %}

{%- if not aptly.nginx.use_nginx_formula and aptly.nginx.reload %}
aptly_site_reload_nginx:
  cmd.run:
    - name: nginx -t && nginx -s reload
    # Only if nginx is actually installed and running - this state is a
    # no-op on a host where something else serves the repo.
    - onlyif:
      - which nginx
      - nginx -t
    - onchanges:
      - file: aptly_site
{%- endif %}
