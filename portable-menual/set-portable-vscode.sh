#! /bin/bash

INSTALL_DIR="/tmp/portable-sources"
PROGRAM_DIR="/tmp/portable-vscode"
APP_DIR="$HOME/.local/share/applications"

INSTALL_NAME="vscode-1.85.tar.gz"
PROGRAM_NAME="code"
APP_NAME="portable-vscode.desktop"

# 0. 폴더 만들기
echo ">>> creating folders..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$PROGRAM_DIR"
mkdir -p "$APP_DIR"

# 1. 공식 주소에서 1.85.2 버전 다운로드
echo ">>> downloading vscode..."
wget https://update.code.visualstudio.com/1.85.2/linux-x64/stable -O "$INSTALL_DIR/$INSTALL_NAME"

# 2-1. 압축 해제
echo ">>> extracting vscode..."
tar -xzvf "$INSTALL_DIR/$INSTALL_NAME" -C "$PROGRAM_DIR" --strip-components=1

# 2-2. vscode 환경을 저장할 폴더 생성
echo ">>> making vscode data folder..."
mkdir "$PROGRAM_DIR/data"

# 3-1. .desktop 파일 생성
echo ">>>cteating .desktop file..."
cat << EOF > "$APP_DIR/$APP_NAME"
[Desktop Entry]
Name=VS Code Portable
Comment=Code Editing. Redefined.
GenericName=Text Editor
# [중요] --no-sandbox 옵션 필수, %F는 파일 인자 전달
Exec=$PROGRAM_DIR/$PROGRAM_NAME --no-sandbox %F
Icon=$PROGRAM_DIR/resources/app/resources/linux/code.png
Type=Application
StartupNotify=false
StartupWMClass=Code
Categories=TextEditor;Development;IDE;
# [중요] vscode:// 프로토콜 핸들러 등록
MimeType=text/plain;inode/directory;application/x-code-workspace;x-scheme-handler/vscode;
EOF

# 3-2. .desktop 파일 바탕화면으로 복사
echo ">>> making .desktop shortcut to Desktop..."
cp "$APP_DIR/$APP_NAME" ~/Desktop

# 4-1. 데스크톱 데이터베이스 갱신
echo ">>> updating database..."
update-desktop-database "$APP_DIR"

# 4-2. vscode:// 링크의 기본 프로그램을 이것으로 지정
echo "setting to default program..."
xdg-mime default portable-vscode.desktop x-scheme-handler/vscode


# ==========================================
# 5. 확장 프로그램 자동 설치
# ==========================================
echo ">>> 확장 프로그램 설치를 시작합니다..."

# 설치할 확장 프로그램 ID 목록 (띄어쓰기로 구분하거나 줄바꿈)
# 필요한 것들을 여기에 추가하세요.
EXT_LIST=(
    "formulahendry.auto-close-tag"              # Auto Close Tag
    "formulahendry.auto-rename-tag"             # Auto Rename Tag
    "vincaslt.highlight-matching-tag"           # Highlight Matching Tag
    "ecmel.vscode-html-css"                     # HTML CSS Support    
    "solnurkarim.html-to-css-autocompletion"    # HTML to CSS autocompletion
    "ritwickdey.liveserver"                     # Live Server
    "vscode-icons-team.vscode-icons"            # vscode-icons
    "eamodio.gitlens"                           # Git Lens
)

for ext in "${EXT_LIST[@]}"; do
    echo "  - 설치 중: $ext ..."
    # Portable 실행 파일을 이용해 설치 명령 수행
    # 1.85 버전 호환성을 위해 --force 옵션을 주면 좋지만, 
    # 버전이 안 맞으면 자동으로 호환 버전을 찾거나 실패할 수 있습니다.
    "$PROGRAM_DIR/code" --install-extension "$ext" --no-sandbox --force
done





