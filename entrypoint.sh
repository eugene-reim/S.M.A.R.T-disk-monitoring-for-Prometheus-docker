#!/bin/bash
set -euo pipefail

OUTPUT="${SMARTMON_OUTPUT:-/var/lib/node_exporter/textfile_collector/smart_metrics.prom}"
INTERVAL="${SMARTMON_INTERVAL:-300}"

echo "🚀 Starting S.M.A.R.T. collector"
echo "   Interval : ${INTERVAL}s"
echo "   Output   : ${OUTPUT}"

mkdir -p "$(dirname "$OUTPUT")"

while true; do
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Collecting SMART metrics..."
    LC_NUMERIC=C /usr/local/bin/smartmon.sh > "${OUTPUT}" || echo "WARNING: smartmon.sh failed"
    sleep "${INTERVAL}"
done