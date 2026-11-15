#!/bin/bash
#
# Bump this PKGBUILD to an upstream release.
#
#   ./update.sh [version]      # default: the latest release
#
# Checksums come from the GitHub release metadata, which publishes a digest per
# asset, so nothing here downloads a 14 MB tarball to hash it.
#
set -euo pipefail

repo=VictoriaMetrics/VictoriaMetrics
asset_amd64='vmutils-linux-amd64-v%s.tar.gz'
asset_arm64='vmutils-linux-arm64-v%s.tar.gz'

here=$(cd "$(dirname "$0")" && pwd)
pkgbuild=$here/PKGBUILD

# Authenticate when a token is available. Anonymous API requests are limited to
# 60 an hour per IP, and CI runners share their IPs, so in a workflow the
# anonymous limit is usually already spent (curl: 403). Locally it works
# without one.
auth=()
if [[ -n ${GH_TOKEN:-} ]]; then
    auth=(-H "Authorization: Bearer $GH_TOKEN")
fi

api() {
    curl -sSf "${auth[@]}" -H 'Accept: application/vnd.github+json' \
         "https://api.github.com/repos/$repo/$1"
}

version=${1:-}
if [[ -z $version ]]; then
    # Fetch first, then parse: in a pipeline a failed request only shows up as
    # a JSON traceback on empty input.
    latest=$(api releases/latest)
    version=$(printf '%s' "$latest" |
              python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"].lstrip("v"))')
fi

current=$(sed -n 's/^pkgver=//p' "$pkgbuild")
if [[ $current == "$version" ]]; then
    printf 'already at %s\n' "$version"
    exit 0
fi

release=$(api "releases/tags/v$version")

digest_of() {
    printf '%s' "$release" | python3 -c '
import json, sys
name = sys.argv[1]
for asset in json.load(sys.stdin)["assets"]:
    if asset["name"] == name:
        print(asset["digest"].removeprefix("sha256:"))
        break
else:
    raise SystemExit(f"no asset named {name} in the release")
' "$1"
}

amd64=$(digest_of "$(printf "$asset_amd64" "$version")")
arm64=$(digest_of "$(printf "$asset_arm64" "$version")")

sed -i -e "s/^pkgver=.*/pkgver=$version/" \
       -e "s/^pkgrel=.*/pkgrel=1/" \
       -e "s/^sha256sums_x86_64=.*/sha256sums_x86_64=('$amd64')/" \
       -e "s/^sha256sums_aarch64=.*/sha256sums_aarch64=('$arm64')/" \
       "$pkgbuild"

printf '%s -> %s\n' "$current" "$version"
