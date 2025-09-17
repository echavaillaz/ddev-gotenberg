[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/echavaillaz/ddev-gotenberg/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/echavaillaz/ddev-gotenberg/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/echavaillaz/ddev-gotenberg)](https://github.com/echavaillaz/ddev-gotenberg/commits)
[![release](https://img.shields.io/github/v/release/echavaillaz/ddev-gotenberg)](https://github.com/echavaillaz/ddev-gotenberg/releases/latest)

## What is ddev-gotenberg?

This repository allows you to quickly install [Gotenberg](https://gotenberg.dev) into a [DDEV](https://ddev.readthedocs.io) project using the instructions below.

## Installation

For DDEV v1.23.5 or above run

```sh
ddev add-on get echavaillaz/ddev-gotenberg
```

For earlier versions of DDEV run

```sh
ddev get echavaillaz/ddev-gotenberg
```

Then restart the project

```sh
ddev restart
```

## Explanation

This Gotenberg recipe for [DDEV](https://ddev.readthedocs.io) installs a [`.ddev/docker-compose.gotenberg.yaml`](docker-compose.gotenberg.yaml) using the [`gotenberg/gotenberg`](https://hub.docker.com/r/gotenberg/gotenberg) Docker image.

## Interacting with Gotenberg

* The Gotenberg instance will listen on TCP port 300 (the Gotenberg default).
* Configure your application to access Gotenberg on the host:port `gotenberg:3000`.


## Resources

1. [Official documentation](https://gotenberg.dev)
2. [Official repository](https://github.com/gotenberg/gotenberg)
3. [Awesome Gotenberg](https://github.com/gotenberg/awesome-gotenberg)
