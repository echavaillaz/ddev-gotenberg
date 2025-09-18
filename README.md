[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/echavaillaz/ddev-gotenberg/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/echavaillaz/ddev-gotenberg/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/echavaillaz/ddev-gotenberg)](https://github.com/echavaillaz/ddev-gotenberg/commits)
[![release](https://img.shields.io/github/v/release/echavaillaz/ddev-gotenberg)](https://github.com/echavaillaz/ddev-gotenberg/releases/latest)

# ddev-gotenberg

## Overview

This [DDEV](https://ddev.com/) add-on integrates [Gotenberg](https://gotenberg.dev), a powerful API for PDF generation and document conversions, into your DDEV project.
It makes it easy to convert HTML, Markdown, Office documents, and more into PDFs directly from your local dev environment.

## Installation

```bash
ddev add-on get echavaillaz/ddev-gotenberg
ddev restart
```

After installation, make sure to commit the `.ddev` directory to version control.

## Usage

Once installed, the add-on runs a Gotenberg service accessible inside your project.

| Command                                                                        | Description                            |
|--------------------------------------------------------------------------------|----------------------------------------|
| `ddev describe`                                                                | View service status and ports          |
| `ddev logs -s gotenberg`                                                       | Check Gotenberg logs                   |
| `curl http://gotenberg:3000/health`                                            | Health check inside the DDEV container |
| `curl -F files=@document.docx http://gotenberg:3000/forms/libreoffice/convert` | Convert a DOCX to PDF                  |

By default, your application should connect to Gotenberg at:

```
http://gotenberg:3000
```

## Advanced Customization

You can change the Gotenberg Docker image or version by overriding the default environment:

```bash
ddev dotenv set .ddev/.env.gotenberg --gotenberg-docker-image="gotenberg/gotenberg:8"
ddev add-on get echavaillaz/ddev-gotenberg
ddev restart
```

Customization options:

| Variable                 | Flag                       | Default                 |
|--------------------------|----------------------------|-------------------------|
| `GOTENBERG_DOCKER_IMAGE` | `--gotenberg-docker-image` | `gotenberg/gotenberg:8` |

Commit the `.ddev/.env.gotenberg` file to share settings across your team.

## Credits

Maintained by [@echavaillaz](https://github.com/echavaillaz).
Powered by [Gotenberg](https://gotenberg.dev) and [DDEV](https://ddev.com/).

## Resources

* [Official Gotenberg documentation](https://gotenberg.dev)
* [Gotenberg repository](https://github.com/gotenberg/gotenberg)
* [Awesome Gotenberg resources](https://github.com/gotenberg/awesome-gotenberg)
