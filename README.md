# aptly-formula

Install and configure [aptly](https://www.aptly.info/), and manage its
repositories, mirrors, and published snapshots from pillar.

> See the full [Salt Formulas installation and usage instructions](https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html).

## Available states

| State | Description |
| --- | --- |
| `aptly` | Set up the aptly repo, install the aptly and bzip2 packages, and create the aptly user. |
| `aptly.aptly_config` | Create the directories and files aptly needs, and import the GPG keys. |
| `aptly.create_repos` | Create the repositories defined under `aptly:repos`. |
| `aptly.create_mirrors` | Create the mirrors defined under `aptly:mirrors`. |
| `aptly.publish_repos` | Publish the repositories. |
| `aptly.nginx` | Serve the published repo over HTTP — see below. |

Settings live under `aptly:lookup`; see `pillar.example`.

## `aptly.nginx`

Writes the vhost file (`/etc/nginx/sites-enabled/aptly` by default,
override with `aptly:lookup:nginx:site_file`).

By default this state has **no dependency on another formula**: it drops the
vhost in and reloads nginx in place, guarded on `nginx -t` and skipped
entirely if nginx isn't installed. It assumes something else installs and
manages nginx.

Set `aptly:lookup:nginx:use_nginx_formula: True` to instead include the
separate [nginx-formula](https://github.com/saltstack-formulas/nginx-formula)
and hand the service off to it; in that mode nginx-formula must be in your
`file_roots`.

## Relationship to upstream

**This is a heavily modified fork of
[`saltstack-formulas/aptly-formula`](https://github.com/saltstack-formulas/aptly-formula).
Do not treat it as a drop-in replacement for it.**

States have been renamed, split, merged, and removed; pillar keys have moved;
defaults differ; and behaviour has changed in ways that are not backward
compatible. Pointing an existing deployment at this formula without reading
`pillar.example` and the state list above will not do what you expect.

It is also not a newer version of upstream — it diverged and was maintained
separately, so upstream may well have fixes and platform support that this
does not. If you want the maintained original, use
[`saltstack-formulas/aptly-formula`](https://github.com/saltstack-formulas/aptly-formula).

### Credit

The foundation of this formula, and much of what still works well in it, is
the work of the [saltstack-formulas](https://github.com/saltstack-formulas)
authors and contributors. Any bugs introduced in the divergence are this
fork's own.

## License

Dedicated to the public domain under [CC0 1.0 Universal](LICENSE).
