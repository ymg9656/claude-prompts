#!/bin/bash
# Git Commit Helper Script
# Conventional Commits 형식을 검증하고 커밋을 수행합니다.
# Usage: ./scripts/commit-helper.sh "커밋 메시지"

set -euo pipefail

# === 설정 ===
CONVENTIONAL_PATTERN="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .+"
MAX_SUBJECT_LENGTH=72
MIN_SUBJECT_LENGTH=10

# === 색상 정의 ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# === 함수 정의 ===
log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

show_usage() {
    echo "Usage: $0 \"<type>(<scope>): <description>\""
    echo ""
    echo "Types:"
    echo "  feat     새로운 기능 추가"
    echo "  fix      버그 수정"
    echo "  docs     문서 변경"
    echo "  style    코드 포맷팅 (기능 변경 없음)"
    echo "  refactor 리팩토링 (기능 변경 없음)"
    echo "  perf     성능 개선"
    echo "  test     테스트 추가/수정"
    echo "  build    빌드 시스템 변경"
    echo "  ci       CI 설정 변경"
    echo "  chore    기타 변경"
    echo "  revert   이전 커밋 되돌리기"
    echo ""
    echo "Examples:"
    echo "  $0 \"feat(auth): 사용자 인증 토큰 갱신 로직 추가\""
    echo "  $0 \"fix(cart): 장바구니 수량 음수 입력 방지\""
}

# === 입력 검증 ===
if [ $# -lt 1 ]; then
    log_error "커밋 메시지가 제공되지 않았습니다."
    show_usage
    exit 1
fi

COMMIT_MSG="$1"
SUBJECT_LINE=$(echo "$COMMIT_MSG" | head -n1)

# 빈 메시지 검사
if [ -z "$COMMIT_MSG" ]; then
    log_error "커밋 메시지가 비어있습니다."
    exit 1
fi

# Conventional Commits 형식 검증
if ! echo "$SUBJECT_LINE" | grep -qE "$CONVENTIONAL_PATTERN"; then
    log_error "커밋 메시지가 Conventional Commits 형식이 아닙니다."
    log_error "형식: <type>(<scope>): <description>"
    log_error "입력: $SUBJECT_LINE"
    show_usage
    exit 1
fi

# 제목 길이 검증
SUBJECT_LENGTH=${#SUBJECT_LINE}
if [ "$SUBJECT_LENGTH" -gt "$MAX_SUBJECT_LENGTH" ]; then
    log_error "제목이 너무 깁니다. (${SUBJECT_LENGTH}자 > 최대 ${MAX_SUBJECT_LENGTH}자)"
    exit 1
fi

if [ "$SUBJECT_LENGTH" -lt "$MIN_SUBJECT_LENGTH" ]; then
    log_error "제목이 너무 짧습니다. (${SUBJECT_LENGTH}자 < 최소 ${MIN_SUBJECT_LENGTH}자)"
    exit 1
fi

# === 스테이징 상태 확인 ===
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null)
if [ -z "$STAGED_FILES" ]; then
    log_error "스테이징된 변경사항이 없습니다."
    log_warn "먼저 'git add'로 변경사항을 스테이징하세요."
    exit 1
fi

# === 변경사항 요약 출력 ===
STAGED_COUNT=$(echo "$STAGED_FILES" | wc -l | tr -d ' ')
echo "---"
echo "커밋 메시지: $SUBJECT_LINE"
echo "스테이징된 파일: ${STAGED_COUNT}개"
echo "$STAGED_FILES" | while read -r file; do
    echo "  - $file"
done
echo "---"

# === 커밋 실행 ===
if git commit -m "$COMMIT_MSG"; then
    log_success "커밋이 성공적으로 생성되었습니다."
    echo ""
    git log --oneline -1
else
    log_error "커밋에 실패했습니다."
    log_warn "pre-commit hook 실패일 수 있습니다. 린트 오류를 확인하세요."
    exit 1
fi

exit 0
