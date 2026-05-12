#!/bin/bash

set -e

# 버전 인자가 있는지 확인
if [ -z "$1" ]; then
  echo "사용법: ./make_release.sh <버전>"
  echo "예시: ./make_release.sh v1.0.0"
  exit 1
fi

VERSION=$1
ZIP_NAME="nfs_station-$VERSION.zip"
RELEASE_DIR="release"

echo "릴리스 프로세스 시작: $VERSION"

# 1. 빌드 준비 및 실행
flutter clean
flutter build macos --release

# 2. 바이너리 패키징 (ZIP)
mkdir -p "$RELEASE_DIR"
PROJECT_ROOT=$(pwd)
cd "build/macos/Build/Products/Release"
echo "앱 패키징 중..."
zip -r "$PROJECT_ROOT/$RELEASE_DIR/$ZIP_NAME" "NFS Station.app"
cd "$PROJECT_ROOT"

# 3. GitHub Release 생성 및 업로드
# --generate-notes: 이전 릴리스 이후의 커밋 로그를 바탕으로 릴리스 노트를 자동 생성합니다.
echo "GitHub Release 생성 및 바이너리 업로드 중..."
gh release create "$VERSION" \
    "$RELEASE_DIR/$ZIP_NAME" \
    --title "Release $VERSION" \
    --generate-notes

echo "릴리스 완료: https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)/releases/tag/$VERSION"
