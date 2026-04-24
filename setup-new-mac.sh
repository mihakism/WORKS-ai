#!/bin/bash
# 새 맥에서 WORKS-ai 환경 셋업 (한 번만 실행)
# 실행 방법: bash setup-new-mac.sh

set -e

echo "=== WORKS-ai 새 맥 셋업 ==="

# 1. rclone 설치
if ! which rclone > /dev/null 2>&1; then
  echo "▸ rclone 설치 중..."
  brew install rclone
else
  echo "✓ rclone 이미 설치됨"
fi

# 2. rclone 설정 (OAuth 자격증명 수동 입력 필요)
if [ ! -f ~/.config/rclone/rclone.conf ]; then
  echo ""
  echo "▸ rclone Google Drive 인증 설정 중..."
  echo "  (브라우저에서 hmihak@gmail.com으로 로그인하세요)"
  echo "  Google Cloud Console에서 발급한 OAuth 자격증명을 입력하세요."
  read -p "  Client ID: " CLIENT_ID
  read -p "  Client Secret: " CLIENT_SECRET
  rclone config create gdrive drive \
    client_id="$CLIENT_ID" \
    client_secret="$CLIENT_SECRET" \
    scope="drive"
else
  echo "✓ rclone 설정 이미 존재"
fi

# 3. 파일 다운로드
echo "▸ Drive에서 파일 다운로드 중..."
mkdir -p ~/Documents/WORKS-ai ~/Documents/WORKS_calendar_files
rclone sync gdrive:WORKS-ai ~/Documents/WORKS-ai --exclude ".git/**" --progress
rclone sync gdrive:WORKS_calendar_files ~/Documents/WORKS_calendar_files --progress

# 4. git 초기화
cd ~/Documents/WORKS-ai
if [ ! -d .git ]; then
  echo "▸ git 연결 중..."
  git init
  git remote add origin https://github.com/mihakism/WORKS-ai.git
  git fetch origin
  git checkout -b main --track origin/main
fi

echo ""
echo "✅ 셋업 완료!"
echo "   미리보기: python3 -m http.server 8090 --directory ~/Documents/WORKS-ai"
echo "   브라우저: http://localhost:8090/calendar.html"
echo "   동기화:   cd ~/Documents/WORKS-ai && ./sync.sh [up|down]"
