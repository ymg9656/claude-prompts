---
name: test-runner
description: 프로젝트의 테스트를 실행하고 결과를 분석하여 실패 원인과 개선 방안을 제시합니다.
---

# Test Runner Skill

프로젝트의 테스트 프레임워크를 자동 감지하고, 테스트를 실행한 후 결과를 분석하여 실패 원인 진단과 개선 제안을 수행하는 Skill입니다.

## 핵심 기능

- 프로젝트의 테스트 프레임워크 자동 감지 (Jest, Pytest, JUnit, Go test 등)
- 전체 테스트 또는 특정 파일/패턴 기반 선택적 테스트 실행
- 테스트 실패 시 원인 분석 및 수정 제안
- 커버리지 리포트 생성 및 분석
- 테스트 패턴 가이드에 기반한 테스트 품질 점검

## 워크플로우

### 1. 프로젝트 분석

프로젝트의 테스트 환경을 감지합니다.

```bash
# 패키지 매니저 및 테스트 프레임워크 감지
ls package.json pyproject.toml build.gradle pom.xml go.mod 2>/dev/null

# package.json의 test 스크립트 확인 (Node.js 프로젝트)
cat package.json | grep -A 5 '"scripts"' 2>/dev/null
```

### 2. 테스트 실행

감지된 프레임워크에 맞는 명령어로 테스트를 실행합니다.

```bash
# Node.js (Jest/Vitest)
npm test -- --verbose

# Python (Pytest)
python -m pytest -v --tb=short

# Go
go test ./... -v

# Java (Gradle)
./gradlew test
```

### 3. 결과 분석

테스트 결과를 파싱하여 실패 항목을 분석합니다.

```bash
# 실패한 테스트만 필터링 (Jest 예시)
npm test -- --verbose 2>&1 | grep -E "(FAIL|PASS|Tests:)"
```

### 4. 커버리지 확인

테스트 커버리지 리포트를 생성하고 분석합니다.

```bash
# Node.js 커버리지
npm test -- --coverage --coverageReporters=text

# Python 커버리지
python -m pytest --cov=src --cov-report=term-missing
```

### 5. 품질 점검

`references/testing-patterns.md`를 참고하여 테스트 품질을 점검합니다.

```bash
# 테스트 패턴 가이드 로드
cat references/testing-patterns.md
```

## 에러 처리

| 에러 | 원인 | 해결 |
|------|------|------|
| `command not found: jest` | 테스트 프레임워크 미설치 | `npm install` 또는 `pip install pytest` 실행 |
| 테스트 타임아웃 | 비동기 테스트 대기 시간 초과 | 타임아웃 값 증가 또는 비동기 처리 검토 |
| `No tests found` | 테스트 파일 패턴 불일치 | 테스트 파일명이 규칙에 맞는지 확인 (예: `*.test.js`) |
| 커버리지 임계값 미달 | 테스트 커버리지 부족 | 미커버 영역에 테스트 추가 |
| 환경 변수 누락 | `.env.test` 파일 없음 | 테스트용 환경 변수 파일 생성 |

## 사용 예시

### 예시 1: 전체 테스트 실행

```
사용자: "테스트 돌려줘"

→ Skill이 프레임워크 감지 후:
  "Jest 프레임워크를 감지했습니다.

  테스트 결과:
  - 전체: 48개
  - 통과: 45개
  - 실패: 3개

  실패한 테스트:
  1. UserService.test.ts > 비밀번호 변경 > 기존 비밀번호 불일치 시 에러
     원인: mock 설정에서 bcrypt.compare 반환값이 잘못됨
     수정: mockReturnValue(true) → mockReturnValue(false)

  2. CartController.test.ts > 수량 업데이트 > 음수 입력 방지
     원인: 유효성 검증 미들웨어가 테스트에서 누락
     수정: 테스트에 validateQuantity 미들웨어 추가 필요"
```

### 예시 2: 특정 파일 테스트

```
사용자: "auth 관련 테스트만 실행해줘"

→ Skill이 관련 테스트 파일 검색 후:
  "auth 관련 테스트 파일 3개를 찾았습니다:
  - src/auth/__tests__/login.test.ts
  - src/auth/__tests__/register.test.ts
  - src/auth/__tests__/token.test.ts

  전체 통과 (12/12 테스트)
  커버리지: 87.3% (auth/ 디렉토리)"
```

### 예시 3: 커버리지 분석

```
사용자: "테스트 커버리지 확인해줘"

→ Skill이 커버리지 리포트 생성 후:
  "전체 커버리지: 73.2% (목표: 80%)

  커버리지가 낮은 파일 (50% 미만):
  - src/services/payment.ts (32.1%) — 결제 취소 로직 미테스트
  - src/utils/date.ts (45.6%) — 타임존 변환 함수 미테스트

  권장: payment.ts에 대한 테스트를 우선 작성하세요."
```

## 리소스

- `references/testing-patterns.md` - 테스트 작성 패턴 가이드
- [Jest 공식 문서](https://jestjs.io/)
- [Pytest 공식 문서](https://docs.pytest.org/)
