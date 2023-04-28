[![tests](https://github.com/echavaillaz/ddev-gotenberg/actions/workflows/tests.yml/badge.svg)](https://github.com/echavaillaz/ddev-gotenberg/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

## What is ddev-gotenberg?

This repository allows you to quickly install [Gotenberg](https://gotenberg.dev) into a [DDEV](https://ddev.readthedocs.io) project using just `ddev get echavaillaz/ddev-gotenberg`.

## Installation

1. `ddev get echavaillaz/ddev-gotenberg`
2. `ddev restart`

## Explanation

This Gotenberg recipe for [DDEV](https://ddev.readthedocs.io) installs a [`.ddev/docker-compose.gotenberg.yaml`](docker-compose.gotenberg.yaml) using the [`gotenberg/gotenberg`](https://hub.docker.com/r/gotenberg/gotenberg) Docker image.

## Interacting with Gotenberg

* The Gotenberg instance will listen on TCP port 300 (the Gotenberg default).
* Configure your application to access Gotenberg on the host:port `gotenberg:3000`.


## Resources

1. [Official documentation](https://gotenberg.dev)
2. [Official repository](https://github.com/gotenberg/gotenberg)
3. [Awesome Gotenberg](https://github.com/gotenberg/awesome-gotenberg)
