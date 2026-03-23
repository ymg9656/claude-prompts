---
name: doc-generator
description: API 문서, 변경 로그(CHANGELOG), 아키텍처 문서를 자동 생성합니다.
---

# Doc Generator Skill

프로젝트의 코드와 변경 이력을 분석하여 API 문서(OpenAPI, JSDoc, Javadoc 등), 변경 로그(CHANGELOG), 아키텍처 문서를 자동 생성하는 Skill입니다. 기존 문서와의 일관성을 유지하며 누락된 문서를 식별합니다.

## 핵심 기능

- API 문서 자동 생성 (OpenAPI/Swagger, JSDoc, Javadoc, pydoc, godoc)
- 코드 주석 기반 문서 추출 및 정리
- CHANGELOG 자동 생성 (Conventional Commits 기반)
- 아키텍처 문서 작성 보조 (디렉토리 구조, 의존성 그래프)
- 문서 커버리지 분석 (미문서화 함수/클래스 탐지)
- 기존 문서 업데이트 및 동기화

## 워크플로우

### 1. 프로젝트 분석

프로젝트의 언어, 프레임워크, 기존 문서 상태를 분석합니다.

```bash
# 프로젝트 언어 및 프레임워크 감지
ls package.json pyproject.toml build.gradle pom.xml go.mod Cargo.toml 2>/dev/null

# 기존 문서 파일 확인
ls docs/ README.md CHANGELOG.md API.md \
   openapi.yaml swagger.json \
   typedoc.json jsdoc.json \
   2>/dev/null

# 기존 문서 도구 설정 확인
cat package.json | grep -E "(typedoc|jsdoc|swagger|openapi)" 2>/dev/null
```

### 2. API 문서 생성

코드에서 API 엔드포인트와 스키마를 추출하여 문서를 생성합니다.

```bash
# OpenAPI 스펙 생성 (Express/NestJS)
npx swagger-autogen ./swagger-output.json ./src/routes/*.ts

# TypeDoc (TypeScript)
npx typedoc --out docs/api src/

# JSDoc (JavaScript)
npx jsdoc -c jsdoc.json -d docs/api

# Javadoc (Java)
javadoc -d docs/api -sourcepath src/main/java -subpackages com.example

# Sphinx (Python)
sphinx-apidoc -o docs/source src/
sphinx-build -b html docs/source docs/build

# godoc (Go)
godoc -http=:6060
```

### 3. CHANGELOG 생성

커밋 히스토리를 분석하여 변경 로그를 생성합니다.

```bash
# Conventional Commits 기반 CHANGELOG 생성
npx conventional-changelog -p angular -i CHANGELOG.md -s

# 또는 수동으로 커밋 히스토리 분석
git log --oneline --since="last tag" | head -50

# 태그 간 변경사항 추출
git log v1.1.0..v1.2.0 --oneline --no-merges
```

#### CHANGELOG 형식

```markdown
# Changelog

## [1.2.0] - 2026-03-23

### 추가 (Added)
- 사용자 프로필 이미지 업로드 기능 (#123)
- 주문 상태 알림 기능 (#125)

### 변경 (Changed)
- 로그인 세션 타임아웃을 30분에서 60분으로 변경 (#124)

### 수정 (Fixed)
- 장바구니 수량 음수 입력 방지 (#126)
- 결제 금액 소수점 반올림 오류 수정 (#127)

### 삭제 (Removed)
- 레거시 인증 API 엔드포인트 제거 (#128)
```

### 4. 아키텍처 문서 작성

프로젝트 구조와 의존성을 분석하여 아키텍처 문서를 생성합니다.

```bash
# 디렉토리 구조 추출
find src -type f -name "*.ts" | head -50

# 의존성 분석
cat package.json | grep -A 30 '"dependencies"'

# 모듈 간 의존성 그래프 (madge 사용)
npx madge --image docs/dependency-graph.svg src/index.ts
```

### 5. 문서 커버리지 분석

미문서화된 함수, 클래스, 엔드포인트를 탐지합니다.

```bash
# TypeDoc 커버리지 확인
npx typedoc --validation.notExported --validation.notDocumented src/

# ESLint JSDoc 검사
npx eslint . --rule '{"jsdoc/require-jsdoc": "warn"}' --format stylish

# Python docstring 커버리지
python -m interrogate src/ -vv
```

## 에러 처리

| 에러 | 원인 | 해결 |
|------|------|------|
| 문서 도구 미설치 | `typedoc`, `jsdoc` 등 미설치 | `npm install -D typedoc` 또는 해당 도구 설치 |
| 파싱 오류 | 코드 문법 오류로 문서 생성 실패 | 먼저 코드 컴파일/린트 오류 수정 |
| 경로 오류 | 설정 파일의 소스 경로 불일치 | `tsconfig.json` 또는 문서 도구 설정의 경로 확인 |
| 태그 없음 | CHANGELOG 생성 시 Git 태그 부재 | `git tag v0.1.0`으로 초기 태그 생성 |
| 인코딩 오류 | 비 UTF-8 주석 포함 | 파일 인코딩을 UTF-8로 변환 |
| 커밋 형식 불일치 | Conventional Commits 미준수 | 수동으로 CHANGELOG 항목 작성 |

## 사용 예시

### 예시 1: API 문서 자동 생성

```
사용자: "API 문서 생성해줘"

→ Skill이 프로젝트 분석 후:
  "NestJS + Swagger 환경을 감지했습니다.

  API 문서 생성 완료:
  - 엔드포인트: 24개
  - 스키마(DTO): 15개
  - 문서 커버리지: 87%

  생성 파일: docs/openapi.yaml

  미문서화 항목:
  - POST /api/payments/webhook (설명 누락)
  - OrderStatusDto (필드 설명 누락)

  Swagger UI에서 확인: http://localhost:3000/api-docs"
```

### 예시 2: CHANGELOG 생성

```
사용자: "CHANGELOG 업데이트해줘"

→ Skill이 커밋 히스토리 분석 후:
  "v1.1.0 이후 커밋 18개를 분석했습니다.

  CHANGELOG.md에 추가:

  ## [1.2.0] - 2026-03-23

  ### 추가
  - 사용자 프로필 이미지 업로드 (#123)
  - 주문 상태 실시간 알림 (#125)

  ### 수정
  - 장바구니 수량 음수 입력 방지 (#126)
  - 결제 금액 소수점 오류 (#127)

  ### 변경
  - 세션 타임아웃 30분 → 60분 (#124)

  CHANGELOG.md가 업데이트되었습니다."
```

### 예시 3: 아키텍처 문서 작성

```
사용자: "프로젝트 아키텍처 문서 작성해줘"

→ Skill이 프로젝트 구조 분석 후:
  "프로젝트 아키텍처 문서를 생성합니다.

  1. 전체 구조
  - 아키텍처 패턴: 레이어드 아키텍처 (Controller → Service → Repository)
  - 주요 모듈: Auth, User, Product, Order, Payment

  2. 기술 스택
  - Runtime: Node.js 20 + TypeScript 5.3
  - Framework: NestJS 10
  - Database: PostgreSQL 15 + Prisma ORM
  - Cache: Redis 7

  3. 의존성 그래프
  docs/architecture/dependency-graph.svg 생성 완료

  4. 데이터 흐름
  docs/architecture/data-flow.md 생성 완료

  생성된 파일: docs/architecture/ (4개 파일)"
```

## 리소스

- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html) - OpenAPI 공식 스펙
- [TypeDoc](https://typedoc.org/) - TypeScript 문서 생성 도구
- [Conventional Changelog](https://github.com/conventional-changelog/conventional-changelog) - CHANGELOG 자동 생성
- [Keep a Changelog](https://keepachangelog.com/) - CHANGELOG 작성 가이드
- [Sphinx](https://www.sphinx-doc.org/) - Python 문서 생성 도구
