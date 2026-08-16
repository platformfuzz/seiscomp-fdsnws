# seiscomp-fdsnws

![CI](https://github.com/platformfuzz/seiscomp-fdsnws/actions/workflows/ci.yml/badge.svg)
![Build and Release](https://github.com/platformfuzz/seiscomp-fdsnws/actions/workflows/build-and-release.yml/badge.svg)

Unofficial SeisComP fdsnws image built with public gsm. Not gempa-supported.

Serves FDSN station/dataselect on TCP 8080 from MariaDB inventory and an SDS tree.

**Package:** [ghcr.io/platformfuzz/seiscomp-fdsnws](https://github.com/platformfuzz/seiscomp-fdsnws/pkgs/container/seiscomp-fdsnws)

## Run

```bash
docker pull ghcr.io/platformfuzz/seiscomp-fdsnws:latest
docker run --rm ghcr.io/platformfuzz/seiscomp-fdsnws:latest
```

Needs a reachable MariaDB (`DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`).

## Build

```bash
docker build -t seiscomp-fdsnws:test .
```

Mount SDS at `/home/sysop/seiscomp/var/lib/archive` (typically the slarchive volume, read-only).

Waits until MariaDB has the SeisComP schema and four LEARN Station rows.
