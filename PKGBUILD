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
pkgver=1.154.1
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
sha256sums_x86_64=('989c8f73edc5d131eb169bb689d7b77bb1d31b14314159c7f6bbae38ba655938')
sha256sums_aarch64=('e9a44e352da8200d427815acab179850cef0a13ed4d0e5ef95a7f1e46c81b0aa')

package() {
  # Upstream ships every binary with a -prod suffix.
  local tool
  for tool in vmagent vmalert vmalert-tool vmauth vmbackup vmctl vmrestore; do
    install -Dm755 "${srcdir}/${tool}-prod" "${pkgdir}/usr/bin/${tool}"
  done
}
