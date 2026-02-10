---
name: git-commit
description: Git 변경사항을 분석하고 컨벤셔널 커밋 메시지를 생성하여 커밋을 수행합니다.
---

# Git Commit Skill

Git 스테이징 영역의 변경사항을 분석하고, Conventional Commits 규칙에 따라 커밋 메시지를 자동 생성한 후 커밋을 수행하는 Skill입니다.

## 핵심 기능

- 스테이징된 변경사항의 diff를 자동 분석
- Conventional Commits 형식의 커밋 메시지 생성 (type, scope, description)
- 변경 파일 수와 영향 범위에 따른 커밋 분할 제안
- 커밋 전 린트/테스트 검증 (pre-commit hook 연동)
- 커밋 히스토리와의 일관성 유지

## 워크플로우

### 1. 변경사항 확인

스테이징 영역과 작업 디렉토리의 현재 상태를 확인합니다.

```bash
git status
git diff --cached --stat
```

### 2. Diff 분석

스테이징된 변경사항의 상세 diff를 분석합니다.

```bash
git diff --cached
```

### 3. 커밋 히스토리 확인

최근 커밋 메시지 스타일을 확인하여 일관성을 유지합니다.

```bash
git log --oneline -10
```

### 4. 커밋 메시지 생성 및 커밋

분석된 변경사항을 바탕으로 Conventional Commits 형식의 메시지를 생성하고 커밋합니다.

```bash
# 헬퍼 스크립트를 사용하여 커밋 메시지 검증 후 커밋
./scripts/commit-helper.sh "feat(auth): 사용자 인증 토큰 갱신 로직 추가"
```

### 5. 결과 확인

커밋이 올바르게 생성되었는지 확인합니다.

```bash
git log --oneline -3
git show --stat HEAD
```

## 에러 처리

| 에러 | 원인 | 해결 |
|------|------|------|
| `nothing to commit` | 스테이징된 변경사항 없음 | `git add`로 변경사항을 스테이징 |
| pre-commit hook 실패 | 린트/포맷 검사 미통과 | 린트 오류를 수정하고 다시 `git add` 후 커밋 |
| 커밋 메시지 형식 오류 | Conventional Commits 형식 미준수 | `type(scope): description` 형식으로 수정 |
| merge conflict | 스테이징 중 충돌 발생 | 충돌을 해결하고 `git add` 후 재시도 |

## 사용 예시

### 예시 1: 단일 기능 커밋

```
사용자: "변경사항 커밋해줘"

→ Skill이 diff 분석 후:
  "feat(user): 프로필 이미지 업로드 기능 추가

  - 이미지 크기 제한 (5MB) 적용
  - WebP 변환 로직 추가
  - S3 업로드 연동"
```

### 예시 2: 버그 수정 커밋

```
사용자: "/commit"

→ Skill이 diff 분석 후:
  "fix(cart): 장바구니 수량 음수 입력 방지

  - 수량 입력 필드에 min=1 제약 추가
  - 서버 사이드 유효성 검증 보강"
```

### 예시 3: 커밋 분할 제안

```
사용자: "커밋 만들어줘"

→ Skill이 변경 파일 분석 후:
  "변경사항이 3개 영역(auth, cart, ui)에 걸쳐 있습니다.
  다음과 같이 분할 커밋을 권장합니다:
  1. feat(auth): 로그인 세션 타임아웃 설정
  2. fix(cart): 할인 금액 계산 오류 수정
  3. style(ui): 버튼 컴포넌트 스타일 통일"
```

## 리소스

- [Conventional Commits](https://www.conventionalcommits.org/) - 커밋 메시지 규칙
- `scripts/commit-helper.sh` - 커밋 메시지 검증 및 실행 헬퍼 스크립트
