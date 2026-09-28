# Maintainer: Till Ehrengruber <till@ehrengruber.ch>
#
# vmagent and friends from the upstream release tarball.
#
# Vendored rather than taken from the AUR. The AUR carries vmutils-bin, which
# was current when this was written, and victoriametrics-agent, which had been
# flagged out of date for ten months while still looking like a maintained
# package. Neither had more than two votes. Packaging it here costs a pkgver
# and two checksums per release (see ./update.sh), which is cheaper than
# carrying that risk.
#
# Binaries only, exactly like vmutils-bin: the vmagent unit is environment
# specific (remote write target, scrape config), so none is shipped here.

pkgname=vmutils
pkgver=1.153.0
pkgrel=1
pkgdesc="VictoriaMetrics utilities: vmagent, vmalert, vmauth, vmbackup, vmctl"
arch=('x86_64' 'aarch64')
url="https://docs.victoriametrics.com/"
license=('Apache-2.0')
provides=('vmagent' 'vmalert' 'vmctl')
conflicts=('vmutils-bin' 'victoriametrics-agent')

_url="https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v${pkgver}"
source_x86_64=("vmutils-${pkgver}-amd64.tar.gz::${_url}/vmutils-linux-amd64-v${pkgver}.tar.gz")
source_aarch64=("vmutils-${pkgver}-arm64.tar.gz::${_url}/vmutils-linux-arm64-v${pkgver}.tar.gz")
sha256sums_x86_64=('85aea24a4829cf26033d810aceb7888070bd4eaff321357168ff6db24bf7c00c')
sha256sums_aarch64=('8153c4feb73564215950a299c803d5c1e974772cd34b8c162d43ea2c5b516df5')

package() {
  # Upstream ships every binary with a -prod suffix.
  local tool
  for tool in vmagent vmalert vmalert-tool vmauth vmbackup vmctl vmrestore; do
    install -Dm755 "${srcdir}/${tool}-prod" "${pkgdir}/usr/bin/${tool}"
  done
}
