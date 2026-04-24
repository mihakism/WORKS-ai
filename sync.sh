#!/bin/bash
# WORKS-ai ↔ Google Drive 동기화

DRIVE_REMOTE="gdrive"
LOCAL_PROJECT="$HOME/Documents/WORKS-ai"
LOCAL_REF="$HOME/Documents/WORKS_calendar_files"

case "$1" in
  up)
    echo "▲ Drive로 업로드 중..."
    rclone sync "$LOCAL_PROJECT" "$DRIVE_REMOTE:WORKS-ai" --exclude ".git/**" --progress
    rclone sync "$LOCAL_REF" "$DRIVE_REMOTE:WORKS_calendar_files" --progress
    rclone copyto ~/.config/rclone/rclone.conf "$DRIVE_REMOTE:_setup/rclone.conf"
    echo "✓ 업로드 완료"
    ;;
  down)
    echo "▼ Drive에서 다운로드 중..."
    mkdir -p "$LOCAL_PROJECT" "$LOCAL_REF"
    rclone sync "$DRIVE_REMOTE:WORKS-ai" "$LOCAL_PROJECT" --exclude ".git/**" --progress
    rclone sync "$DRIVE_REMOTE:WORKS_calendar_files" "$LOCAL_REF" --progress
    echo "✓ 다운로드 완료"
    ;;
  *)
    echo "사용법: ./sync.sh [up|down]"
    echo "  up   — 로컬 → Drive 업로드"
    echo "  down — Drive → 로컬 다운로드"
    ;;
esac
