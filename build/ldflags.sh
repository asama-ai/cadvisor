#!/usr/bin/env bash
# Echo linker flags for github.com/google/cadvisor/cmd (aligned with cadvisor/build/build.sh)
# plus -s -w for package-sized binaries.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CADVISOR_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${CADVISOR_ROOT}"

repo_path="github.com/google/cadvisor"
BUILD_USER="${BUILD_USER:-${USER:-unknown}@${HOSTNAME:-unknown}}"
BUILD_DATE="${BUILD_DATE:-$(date +%Y%m%d-%H:%M:%S)}"

version=${VERSION:-$(git describe --tags --dirty --abbrev=14 | sed -E 's/-([0-9]+)-g/.\1+/')}
revision=$(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')
go_version=$(go version | sed -e 's/^[^0-9.]*\([0-9.]*\).*/\1/')

ldseparator="="
case "${go_version}" in
1.4*) ldseparator=" " ;;
esac

printf '%s ' \
	'-s' '-w' \
	"-X ${repo_path}/version.Version${ldseparator}${version}" \
	"-X ${repo_path}/version.Revision${ldseparator}${revision}" \
	"-X ${repo_path}/version.Branch${ldseparator}${branch}" \
	"-X ${repo_path}/version.BuildUser${ldseparator}${BUILD_USER}" \
	"-X ${repo_path}/version.BuildDate${ldseparator}${BUILD_DATE}" \
	"-X ${repo_path}/version.GoVersion${ldseparator}${go_version}"
