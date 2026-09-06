# Multivisor web deployment

This repository owns the Sinclair group configuration, service scripts, and
locked Python environment for a Multivisor web dashboard. Application code is
installed as a Git dependency from
[SinclairQuantumLab/multivisor](https://github.com/SinclairQuantumLab/multivisor);
do not copy application source into this repository.

## Initial setup

Install [uv](https://docs.astral.sh/uv/getting-started/installation/) and clone
this repository:

```console
git clone https://github.com/SinclairQuantumLab/multivisor-web.git
cd multivisor-web
uv sync --frozen
```

The committed `.python-version` selects Python 3.14. The locked dependency is
the reviewed Multivisor Git revision declared in `pyproject.toml`; `uv sync
--frozen` must not silently upgrade it.

Create a local configuration from the template:

```console
cp multivisor.conf.template multivisor.conf
```

Add each Multivisor RPC host under its own `[supervisor:<name>]` section. The
URL is the Multivisor RPC endpoint, normally port 9002, not Supervisor's
HTTP/XML-RPC endpoint.

To enable the built-in login, uncomment `username` and `password` in
`multivisor.conf`, then create a local `.env` file containing a stable secret:

```console
uv run --frozen python -c "import secrets; print(secrets.token_hex(32))"
```

```ini
# .env (never commit this file)
MULTIVISOR_SECRET_KEY=<generated value>
```

## Run

On Unix, `Startup.sh` loads `.env`, activates the prepared environment, and
starts the dashboard:

```console
./Startup.sh
```

The equivalent direct command is:

```console
uv run --frozen multivisor -c multivisor.conf
```

For a service, adapt `supervisor/multivisor-web.conf` to the actual project
path. Use an absolute command and config path in production. The service
definition and local configuration stay here; the `multivisor` executable comes
from this repository's `.venv`.

## Upgrade or rollback the application

This branch intentionally exercises the fork's
`refactor/git-package-deployment` branch. It is an integration dependency, not
a production release. Once an approved fork tag exists, pin this repository to
that immutable tag:

```console
uv add "multivisor[web,cli] @ git+https://github.com/SinclairQuantumLab/multivisor.git@<release-tag>"
uv lock
uv sync --frozen
```

Commit both `pyproject.toml` and `uv.lock` together. Before upgrading, stop the
service and record `uv tree`; after upgrading, verify the dashboard and all
Supervisor connections. To roll back, restore the previous two files, run
`uv sync --frozen`, and restart.

Do not pin a floating branch for a production deployment. A Git dependency is
resolved to a commit in `uv.lock`, but changing the lock later could otherwise
pick up unrelated work.

## Supervisor/RPC hosts

The central web environment does not install Supervisor. Each managed host
runs its own Supervisor and the Multivisor RPC adapter. Follow the maintained
[RPC-host instructions](https://github.com/SinclairQuantumLab/multivisor/blob/refactor/git-package-deployment/PACKAGING.md#supervisor-and-rpc-hosts)
for the appropriate Python runtime and installation command. The Multivisor
RPC package supports Python 3.12–3.14. Current Windows `supervisor-win` hosts
remain on Python 3.12 because of supervisor-win's own `pywin32` dependency;
the central dashboard may use Python 3.14. When supervisor-win supports a
newer interpreter, the host environment can upgrade independently.

## Repository contents

- `multivisor.conf.template`: starting point for the untracked local config.
- `Startup.sh`: Unix dashboard launcher.
- `supervisor/`: example service-manager configuration.
- `uv.lock`: reviewed, reproducible application dependency resolution.

The inherited desktop-launcher files are convenience scripts for existing
machines; update their absolute paths before using them on another host.
