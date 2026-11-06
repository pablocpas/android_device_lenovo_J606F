#!/usr/bin/env bash
# Applies device/lenovo/J606F/patches/<project path>/*.patch to the Android tree.
# Run it from the root of the tree, after "repo sync":
#
#   bash device/lenovo/J606F/patches/aplicar.sh
#
# Idempotent: an already applied patch is skipped; one that does not apply stops.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
TREE="${TREE:-$PWD}"
[[ -f "$TREE/build/envsetup.sh" ]] || { echo "Run it from the root of the Android tree" >&2; exit 1; }
while IFS= read -r patch; do
    project="$(dirname "${patch#"$ROOT"/}")"
    [[ -d "$TREE/$project" ]] || { echo "Missing project: $project" >&2; exit 1; }
    if git -C "$TREE/$project" apply --check -R "$patch" 2>/dev/null; then
        echo "Already applied: $project/$(basename "$patch")"
    else
        git -C "$TREE/$project" apply "$patch"
        echo "Applied: $project/$(basename "$patch")"
    fi
done < <(find "$ROOT" -name '*.patch' | sort)
