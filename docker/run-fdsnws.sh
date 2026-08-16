#!/bin/bash
set -euo pipefail
export SEISCOMP_ROOT="${SEISCOMP_ROOT:-/home/sysop/seiscomp}"
export PATH="$SEISCOMP_ROOT/bin:$PATH"

seiscomp enable fdsnws >/dev/null || true
seiscomp update-config fdsnws || true
echo "starting fdsnws on 8080"
exec seiscomp exec fdsnws --console 1
