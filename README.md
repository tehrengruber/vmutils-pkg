# vmutils-pkg

Arch package for the [VictoriaMetrics](https://docs.victoriametrics.com/)
utilities — vmagent, vmalert, vmauth, vmbackup, vmctl — built from the upstream
release tarball.

Installed by the `monitoring` role in the ansible-devbox repository, which
clones this as `<base_url>vmutils-pkg.git`, runs `makepkg -rsi` and checks the
result with `pacman -Qi vmutils`. Repository name, `pkgname` and the role's
`monitoring_vmagent_package` therefore have to stay in step.

## Why this exists rather than the AUR

`victoriametrics-agent` had been flagged out of date for ten months while still
looking like a maintained package; `vmutils-bin` was current but six weeks old
with zero votes. Upstream ships static binaries, so packaging them here costs a
`pkgver` and two checksums per release and removes a stranger from the
dependency chain of the thing that is supposed to notice when other things
break.

## Contents

    /usr/bin/vmagent
    /usr/bin/vmalert
    /usr/bin/vmalert-tool
    /usr/bin/vmauth
    /usr/bin/vmbackup
    /usr/bin/vmctl
    /usr/bin/vmrestore

Binaries only, deliberately. The vmagent unit is environment specific — remote
write target, whether it also scrapes — so it lives in the ansible role rather
than here.

vmagent is what makes delivery durable: Prometheus buffers remote writes in its
WAL, which is truncated roughly every two hours, so a link down overnight loses
samples that still exist locally. vmagent spools to disk instead.

## Updating

    ./update.sh            # latest upstream release
    ./update.sh 1.151.0    # a specific one

Rewrites `pkgver`, `pkgrel` and both checksums from the GitHub release metadata,
which publishes a digest per asset — nothing is downloaded to be hashed. It
exits without touching anything if the version already matches.

`.github/workflows/update.yml` runs the same script daily, builds the result in
an Arch container, asserts all seven binaries are present, and opens a pull
request. The build is the part that matters: a checksum bump alone would sail
past an upstream that renames its `-prod` binaries, and that failure would
otherwise surface on the host at deploy time.

It opens a PR rather than pushing, because VictoriaMetrics ships breaking
changes between releases and that decision belongs to a person. The PR step
needs *Settings → Actions → General → Allow GitHub Actions to create and approve
pull requests*.
