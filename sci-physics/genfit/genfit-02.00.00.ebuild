# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils versionator

#ESVN_REPO_URI="https://svn.code.sf.net/p/${PN}/code/tags/v$(replace_all_version_separators '-')"
#ESVN_PROJECT="${PN}.${PV}"

TAG_VER=${PN}-code-1688-tags-v$(replace_all_version_separators '-')

DESCRIPTION="a generic toolkit for track reconstruction for experiments in particle and nuclear physics"
HOMEPAGE="http://genfit.sourceforge.net/Main.html"
SRC_URI="http://sourceforge.net/code-snapshots/svn/g/ge/genfit/code/${TAG_VER}.zip"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	sci-physics/root
	dev-libs/boost"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )"

S=${WORKDIR}/${TAG_VER}

src_compile() {
	cmake-utils_src_compile
	use doc      && cmake-utils_src_compile doc
	use examples && cmake-utils_src_compile tests
}

src_install() {
	cmake-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${BUILD_DIR}/bin"
		doins "${S}/test/makeGeom.C"
		doins "${S}/test/README"
	fi
	cd doc || die
	use doc && dohtml -r "${S}/doc/html/"*
	echo
	elog "Note that there is no support in this ebuild for RAVE yet,"
	elog "which is also not in portage."
	elog "It should be possible to use a local installation of RAVE"
	elog "and set:"
	elog "  export RAVEPATH=<yourRaveDirectory>"
	echo
}
