---
name: lint-fix
description: 린트 검사 및 자동 수정을 수행하고 수정 전후 diff를 표시합니다.
---

# Lint Fix Skill

프로젝트의 린트 도구를 자동 감지하고, 코드 스타일 검사 및 자동 수정을 수행하는 Skill입니다. 수정 전후의 변경사항을 diff로 표시하여 어떤 부분이 수정되었는지 명확하게 보여줍니다.

## 핵심 기능

- 린트/포맷터 도구 자동 감지 (ESLint, Prettier, Black, Ruff, isort, Checkstyle, gofmt, rustfmt 등)
- 전체 프로젝트 또는 특정 파일/디렉토리 대상 린트 실행
- 자동 수정 가능한 이슈 일괄 수정
- 수정 전후 diff 표시
- 수정 불가능한 이슈 목록 및 수동 수정 가이드 제공
- 린트 설정 파일 분석 및 규칙 설명

## 워크플로우

### 1. 린트 도구 감지

프로젝트에서 사용 중인 린트/포맷터 도구를 자동으로 감지합니다.

```bash
# 린트 설정 파일 감지
ls .eslintrc.js .eslintrc.json .eslintrc.yml eslint.config.js \
   .prettierrc .prettierrc.json prettier.config.js \
   .stylelintrc .stylelintrc.json \
   pyproject.toml setup.cfg .flake8 .pylintrc \
   .golangci.yml .golangci.yaml \
   rustfmt.toml .rustfmt.toml \
   checkstyle.xml \
   2>/dev/null

# package.json에서 린트 스크립트 확인
cat package.json | grep -A 5 '"scripts"' 2>/dev/null | grep -E "(lint|format|prettier)"
```

### 2. 린트 검사 실행

감지된 도구로 린트 검사를 실행합니다.

```bash
# ESLint (JavaScript/TypeScript)
npx eslint . --ext .js,.jsx,.ts,.tsx --format stylish

# Prettier 검사 (포맷팅)
npx prettier --check "src/**/*.{ts,tsx,js,jsx,json,css}"

# Black (Python)
black --check --diff src/

# Ruff (Python)
ruff check src/

# gofmt (Go)
gofmt -l ./...

# Checkstyle (Java)
java -jar checkstyle.jar -c checkstyle.xml src/
```

### 3. 자동 수정 실행

수정 가능한 이슈를 자동으로 수정합니다.

```bash
# ESLint 자동 수정
npx eslint . --ext .js,.jsx,.ts,.tsx --fix

# Prettier 포맷팅
npx prettier --write "src/**/*.{ts,tsx,js,jsx,json,css}"

# Black 포맷팅
black src/

# Ruff 자동 수정
ruff check --fix src/

# isort (Python import 정렬)
isort src/

# gofmt 포맷팅
gofmt -w ./...
```

### 4. 수정 결과 확인

수정된 내용의 diff를 표시합니다.

```bash
# 수정 전후 변경사항 확인
git diff

# 변경된 파일 목록 확인
git diff --name-only

# 변경 통계 확인
git diff --stat
```

### 5. 수동 수정 필요 사항 안내

자동 수정이 불가능한 이슈를 정리합니다.

```bash
# 남은 ESLint 오류 확인
npx eslint . --ext .js,.jsx,.ts,.tsx --format stylish 2>&1 | grep "error"

# 남은 Ruff 오류 확인
ruff check src/ --output-format text
```

## 에러 처리

| 에러 | 원인 | 해결 |
|------|------|------|
| 린트 도구 미설치 | `eslint` 또는 `prettier` 미설치 | `npm install -D eslint prettier` 실행 |
| 설정 파일 없음 | `.eslintrc` 등 설정 파일 부재 | `npx eslint --init`으로 설정 파일 생성 |
| 플러그인 누락 | ESLint 플러그인 미설치 | 오류 메시지의 플러그인을 `npm install -D`로 설치 |
| 파서 오류 | TypeScript 파서 설정 누락 | `@typescript-eslint/parser` 설치 및 설정 |
| 충돌하는 규칙 | ESLint와 Prettier 규칙 충돌 | `eslint-config-prettier` 설치로 충돌 해소 |
| 파일 인코딩 오류 | 비 UTF-8 파일 포함 | `.eslintignore` 또는 `.prettierignore`에 해당 파일 추가 |

## 사용 예시

### 예시 1: 전체 프로젝트 린트 수정

```
사용자: "린트 오류 수정해줘"

→ Skill이 도구 감지 후:
  "ESLint + Prettier 환경을 감지했습니다.

  린트 검사 결과:
  - 전체 오류: 23개 (자동 수정 가능: 19개, 수동 수정 필요: 4개)

  자동 수정 실행 완료:
  변경된 파일: 8개

  주요 수정 내용:
  - 미사용 import 제거 (7건)
  - 세미콜론 추가 (5건)
  - 들여쓰기 정리 (4건)
  - 화살표 함수 괄호 통일 (3건)

  수동 수정 필요:
  1. src/services/user.ts:42 - no-any: any 타입 사용 → 적절한 타입 정의 필요
  2. src/utils/helper.ts:15 - no-unused-vars: 미사용 변수 'temp' 제거 또는 사용
  3. src/controllers/auth.ts:78 - no-console: console.log 제거 또는 logger 사용
  4. src/models/order.ts:23 - complexity: 함수 복잡도 초과 → 함수 분리 권장"
```

### 예시 2: 특정 파일 수정

```
사용자: "src/services/ 폴더만 린트 수정해줘"

→ Skill이 해당 디렉토리 검사 후:
  "src/services/ 린트 검사:
  - 대상 파일: 12개
  - 오류: 8개 (전부 자동 수정 가능)

  자동 수정 완료. 변경 diff:

  src/services/payment.ts
  - L15: const result = await   fetch(url)
  + L15: const result = await fetch(url)

  src/services/user.ts
  - L7: import { Request, Response, NextFunction } from 'express'
  + L7: import { Request, Response } from 'express'
  (미사용 import NextFunction 제거)

  전체 오류 해소 완료."
```

### 예시 3: Python 프로젝트 포맷팅

```
사용자: "코드 포맷팅 해줘"

→ Skill이 Python 프로젝트 감지 후:
  "Black + Ruff + isort 환경을 감지했습니다.

  1단계: isort (import 정렬)
  변경 파일: 5개

  2단계: Black (코드 포맷팅)
  변경 파일: 9개

  3단계: Ruff (린트 검사)
  자동 수정: 3건, 남은 오류: 0건

  변경된 파일 총 11개. git diff로 전체 변경사항을 확인하세요."
```

## 리소스

- [ESLint 공식 문서](https://eslint.org/docs/latest/) - JavaScript/TypeScript 린트
- [Prettier 공식 문서](https://prettier.io/docs/en/) - 코드 포맷터
- [Black 공식 문서](https://black.readthedocs.io/) - Python 코드 포맷터
- [Ruff 공식 문서](https://docs.astral.sh/ruff/) - 고속 Python 린터
- [gofmt](https://pkg.go.dev/cmd/gofmt) - Go 코드 포맷터
