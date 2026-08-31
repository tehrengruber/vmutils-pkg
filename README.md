# vmutils-pkg

Arch Linux package for the [VictoriaMetrics](https://docs.victoriametrics.com/)
utilities — `vmagent`, `vmalert`, `vmauth`, `vmbackup`, `vmctl` and friends —
built from the upstream release tarball.

## Why this exists

The AUR coverage of these tools was thin when this was written: the agent
package had been flagged out of date for ten months while still looking like a
maintained package, and the binary package was current but new and had no votes.
A package that has stopped tracking upstream looks exactly like one that has
not, which is the awkward part.

Upstream publishes static binaries for every release, so packaging them costs a
`pkgver` and two checksums. This repository automates that and keeps itself
current.

## Contents

    /usr/bin/vmagent
    /usr/bin/vmalert
    /usr/bin/vmalert-tool
    /usr/bin/vmauth
    /usr/bin/vmbackup
    /usr/bin/vmctl
    /usr/bin/vmrestore

Binaries only, deliberately. A vmagent unit is specific to wherever it runs —
what it scrapes, which remote write target it forwards to — so no unit is
shipped here.

vmagent is the piece that makes delivery durable. Prometheus buffers remote
writes in its WAL, which is truncated every couple of hours, so a link that is
down overnight loses samples that still exist locally. vmagent spools to disk
instead, and the backlog drains when the link returns.

## Updating

    ./update.sh            # latest upstream release
    ./update.sh 1.151.0    # a specific one

`update.sh` rewrites `pkgver`, `pkgrel` and both checksums from the GitHub
release metadata, which publishes a digest per asset, so nothing is downloaded
in order to be hashed. It exits without touching anything if the version already
matches.

A scheduled workflow runs the same script every day, builds the result in an
Arch container, checks all seven binaries are present and opens a pull request
with the bump. Building — rather than bumping checksums alone — is the part that
matters: a checksum change would sail straight past an upstream that renamed its
`-prod` binaries, and that failure would otherwise turn up at install time
instead of here.
