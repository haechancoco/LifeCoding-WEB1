#! /bin/bash

INSTALL_DIR="/tmp/portable-sources"
PROGRAM_DIR="/tmp/portable-chrome"
APP_DIR="$HOME/.local/share/applications"
APP_NAME="portable-chrome.desktop"

# 0. 폴더 만들기
mkdir -p "$INSTALL_DIR"
mkdir -p "$PROGRAM_DIR"
mkdir -p "$APP_DIR"

# 1. 공식 패키지 다운로드
echo "Downloading Chrome..."
wget -N -P "$INSTALL_DIR" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# 2. 패키지 추출
echo "Extracting..."
dpkg -x "$INSTALL_DIR/google-chrome-stable_current_amd64.deb" "$PROGRAM_DIR"

# 3-1. 경로 의존성을 해결하고 샌드박스 옵션을 적용한 래퍼 스크립트 생성
cat << 'EOF' > "$PROGRAM_DIR/opt/google/chrome/run-chrome.sh"
#!/bin/bash

# 스크립트 위치를 기준으로 절대 경로 계산
HERE="$( cd "$( dirname "$0" )" && pwd )"

# 크롬 실행 (프로필 격리 + 샌드박스 해제 + URL 인자 전달)
# 주의: .desktop 연동을 위해 nohup/& 없이 포그라운드 실행 권장
"$HERE/google-chrome" \
  --user-data-dir="$HERE/profile" \
  --no-sandbox \
  "$@"
EOF

# 3-2. 생성한 스크립트에 실행 권한 부여
chmod +x "$PROGRAM_DIR/opt/google/chrome/run-chrome.sh"

# 4. .desktop 파일 생성
echo "Setting default browser..."
cat << EOF > "$APP_DIR/$APP_NAME"
[Desktop Entry]
Version=1.0
Type=Application
Name=Google Chrome Portable
Comment=Portable Web Browser
Exec=$PROGRAM_DIR/opt/google/chrome/run-chrome.sh %u
Icon=google-chrome
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
Terminal=false
EOF

# 5-1 데스크톱 데이터베이스 갱신
update-desktop-database "$APP_DIR"

# 5-2. 기본 브라우저 설정
xdg-settings set default-web-browser "$APP_NAME"

CURRENT_BROWSER=$(xdg-settings get default-web-browser)
printf "현재 기본 브라우저: %s\n" "$CURRENT_BROWSER"

