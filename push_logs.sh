#!/usr/bin/env bash
set -euo pipefail
REPO_DIR="/home/snicken/snicken_luft"
SOURCE_LOGS="/home/snicken/pms_logs"
BRANCH="master"

cd "$REPO_DIR"

git pull --rebase origin "$BRANCH"

YESTERDAY=$(TZ=Europe/Stockholm date -d "yesterday" +%F)
rsync -a --include='*/' --include="*__${YESTERDAY}.csv" --exclude='*' "$SOURCE_LOGS"/ "$REPO_DIR/pms_logs/"

rsync -a "$SOURCE_LOGS"/ "$REPO_DIR/pms_logs/"

git add pms_logs

if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

git commit -m "Add logs $(YESTERDAY)"
git push origin "$BRANCH"
