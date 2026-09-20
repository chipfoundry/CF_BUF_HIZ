#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="${TMPDIR:-/tmp}/cf_buf_hiz_tb"
iverilog -g2005 -o "$OUT" \
  "$ROOT/hdl/gl/CF_BUF_HIZ.v" \
  "$ROOT/verify/beh_model/CF_BUF_HIZ_core.v" \
  "$ROOT/verify/beh_model/tb_CF_BUF_HIZ.v"
vvp "$OUT"
