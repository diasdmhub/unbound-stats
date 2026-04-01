#!/bin/sh
echo "Content-type: text/plain"
echo ""
exec unbound-control stats 2>&1 || echo "[Lighttpd] ERROR: unbound-control failed. Check if unbound-control is enabled"
