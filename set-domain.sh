#!/usr/bin/env bash
#
# set-domain.sh — point a Biprimo site at a new domain in one command.
# Reusable across every site: it auto-detects the CURRENT domain from index.html's
# <link rel="canonical">, then rewrites it everywhere absolute URLs appear.
#
# Usage:   ./set-domain.sh <new-domain>
# Example: ./set-domain.sh trattoriaermes.it
#          ./set-domain.sh www.trattoriaermes.it
#
# Updates index.html, privacy.html, sitemap.xml, robots.txt. Internal links, images,
# fonts and the manifest are relative, so only the absolute SEO/OG URLs change.
# Run from the repo root. Review `git diff`, commit, push, then add the domain in Cloudflare Pages.

set -euo pipefail

NEW="${1:-}"
if [[ -z "$NEW" ]]; then
  echo "Usage: ./set-domain.sh <new-domain>   e.g. ./set-domain.sh trattoriaermes.it" >&2
  exit 1
fi
NEW="${NEW#http://}"; NEW="${NEW#https://}"; NEW="${NEW%/}"

# Auto-detect current domain from the canonical tag in index.html.
OLD=$(grep -oE 'rel="canonical" href="https?://[^/"]+' index.html | grep -oE 'https?://[^/"]+' | sed -E 's#https?://##' | head -1)
if [[ -z "$OLD" ]]; then
  echo "Could not find current domain in index.html canonical tag." >&2
  exit 1
fi

echo "Replacing  $OLD  →  $NEW"
total=0
for f in index.html privacy.html sitemap.xml robots.txt; do
  [[ -f "$f" ]] || continue
  n=$(grep -c "$OLD" "$f" || true)
  if [[ "$n" -gt 0 ]]; then
    perl -pi -e "s/\Q$OLD\E/$NEW/g" "$f"
    echo "  $f: $n reference(s) updated"
    total=$((total + n))
  fi
done

echo "Done — $total reference(s) updated."
echo "Next: git diff → commit + push (Cloudflare Pages redeploys) → add '$NEW' in Cloudflare Pages → Custom domains → curl -I https://$NEW/"
