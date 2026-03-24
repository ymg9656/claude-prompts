---
name: technical-spec
description: API 스펙을 설계하거나, DB 스키마를 작성하거나, 아키텍처 문서를 만들 때 사용합니다. "API 스펙 작성해줘", "DB 스키마 설계해줘", "아키텍처 문서 만들어줘" 등의 요청에 트리거됩니다.
---

# Technical Spec Skill

기능 명세서를 기반으로 기술 설계 문서(API 스펙, DB 스키마, 아키텍처 문서)를 작성하는 Skill입니다. 개발 담당자가 "어떻게 구현할 것인가"를 기술적으로 정의합니다.

> **비즈니스 기능 명세서**(요구사항, 화면 흐름, 비즈니스 규칙)는 [`project-planning`](../project-planning/SKILL.md) 스킬을 사용하세요.

## 핵심 기능

- API 엔드포인트 설계 (RESTful 규칙, 요청/응답 스키마, 에러 코드 정의)
- DB 스키마 설계 (엔티티 정의, 관계 매핑, 인덱스/제약조건)
- 아키텍처 문서 작성 (컴포넌트 구조, 시퀀스 다이어그램, 기술 결정 기록)
- 기존 코드베이스 분석 기반 설계 (현행 패턴 파악 후 일관된 설계)
- 기능 명세서와의 추적성 유지 (FR-XXX ↔ API ↔ DB 매핑)

## 워크플로우

### 1. 기존 코드베이스 및 기능 명세 분석

현행 기술 스택과 패턴을 파악하고, 기능 명세서를 확인합니다.

```bash
# 프로젝트 기술 스택 확인
ls package.json build.gradle pom.xml requirements.txt go.mod Cargo.toml 2>/dev/null

# 기존 API 라우트 패턴 확인
grep -r "router\.\|@Get\|@Post\|@app.route\|@RequestMapping" src/ --include="*.ts" --include="*.py" --include="*.java" --include="*.go" 2>/dev/null | head -20

# 기존 DB 스키마/모델 확인
find src/ -name "*.entity.ts" -o -name "*.model.ts" -o -name "models.py" -o -name "*.schema.prisma" 2>/dev/null

# 기능 명세서 확인
ls docs/planning/feature-specs/ 2>/dev/null
```

### 2. API 스펙 작성

기능 명세서의 화면 흐름과 비즈니스 규칙을 기반으로 API를 설계합니다.

#### API 스펙 형식

```markdown
# API 스펙: {기능명}

## 관련 기능 명세
- 기능 ID: FR-XXX
- 기능 명세서: docs/planning/feature-specs/FR-XXX-{name}.md

## 엔드포인트 목록

### POST /api/v1/{resource}

**설명**: {동작 설명}

**인증**: Bearer Token 필수

**요청**:
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| field1 | string | Y | 설명 |
| field2 | number | N | 설명 |

**응답** (200 OK):
```json
{
  "id": "uuid",
  "field1": "value",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

**에러 응답**:
| 상태 코드 | 에러 코드 | 설명 | 대응 |
|----------|----------|------|------|
| 400 | INVALID_INPUT | 입력값 검증 실패 | 필드별 검증 메시지 반환 |
| 401 | UNAUTHORIZED | 인증 토큰 없음/만료 | 재로그인 유도 |
| 403 | FORBIDDEN | 권한 없음 | 권한 안내 메시지 |
| 404 | NOT_FOUND | 리소스 없음 | — |
| 409 | CONFLICT | 중복 데이터 | 기존 데이터 안내 |
```

### 3. DB 스키마 설계

API 스펙의 데이터 구조를 기반으로 DB 스키마를 설계합니다.

#### DB 스키마 형식

```markdown
# DB 스키마: {기능명}

## 관련 API 스펙
- docs/technical/api-spec-{name}.md

## 엔티티 정의

### {EntityName}
| 컬럼 | 타입 | 제약조건 | 설명 |
|------|------|---------|------|
| id | UUID | PK | 고유 식별자 |
| name | VARCHAR(100) | NOT NULL | 이름 |
| status | ENUM | NOT NULL, DEFAULT 'active' | 상태 |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | 생성일 |
| updated_at | TIMESTAMP | NOT NULL | 수정일 |

## 관계

| 관계 | 설명 |
|------|------|
| User 1:N Post | 사용자가 여러 게시글 작성 |
| Post N:M Tag | 게시글에 여러 태그 가능 |

## 인덱스

| 인덱스명 | 컬럼 | 타입 | 용도 |
|---------|------|------|------|
| idx_{table}_status | status | B-Tree | 상태별 필터링 |
| idx_{table}_created | created_at | B-Tree | 최신순 정렬 |

## 마이그레이션 노트
- 기존 테이블과의 호환성 고려사항
- 데이터 마이그레이션 필요 여부
```

### 4. 아키텍처 문서 작성

신규 기능의 전체적인 기술 구조를 문서화합니다.

#### 아키텍처 문서 형식

```markdown
# 아키텍처: {기능명}

## 컴포넌트 구조

```
[Client] → [API Gateway] → [Service Layer] → [Repository] → [DB]
                                   ↓
                          [External Service]
```

## 기술 결정 (ADR)

### 결정: {기술 선택 사항}
- **상태**: 제안 | 승인 | 폐기
- **컨텍스트**: 왜 이 결정이 필요한가
- **선택지**:
  1. 옵션 A — 장점 / 단점
  2. 옵션 B — 장점 / 단점
- **결정**: 선택한 옵션과 이유
- **결과**: 이 결정으로 인한 영향

## 시퀀스

```
사용자 → 프론트엔드 → API → 서비스 → DB
  1. 요청 전송
  2. 인증 검증
  3. 비즈니스 로직 처리
  4. 데이터 저장
  5. 응답 반환
```
```

### 5. 산출물 저장

기술 설계 문서를 프로젝트 문서 구조에 저장합니다.

```bash
# 기술 문서 디렉토리 생성
mkdir -p docs/technical

# 산출물 저장 위치
# docs/technical/api-spec-{feature}.md    — API 스펙
# docs/technical/db-schema-{feature}.md   — DB 스키마
# docs/technical/architecture-{feature}.md — 아키텍처 문서
```

## 에러 처리

| 에러 | 원인 | 해결 |
|------|------|------|
| 기능 명세서 미존재 | 기획 단계 미완료 | `project-planning` 스킬로 기능 명세서 먼저 작성 |
| 기존 API 패턴 불일치 | 신규 설계가 기존 컨벤션과 다름 | 기존 패턴 분석 후 일관성 유지 또는 마이그레이션 계획 수립 |
| 스키마 충돌 | 기존 테이블/컬럼과 이름 충돌 | 기존 스키마 확인 후 네이밍 조정, `db-migration` 스킬 연계 |
| 기술 스택 미파악 | 프로젝트 기술 스택 자동 감지 실패 | 수동으로 기술 스택 정보 입력 요청 |
| 명세-설계 불일치 | 기능 명세서와 기술 설계 간 간극 | FR-XXX ID로 추적성 확인, 누락된 요구사항 보완 |

## 사용 예시

### 예시 1: API 스펙 작성

```
사용자: "로그인 기능 API 스펙 작성해줘"

→ Skill이 기능 명세서 + 기존 코드 분석 후:
  "로그인 API 스펙을 작성했습니다.

  관련 기능: FR-001 (로그인)
  엔드포인트 3개:
  - POST /api/v1/auth/login — 로그인
  - POST /api/v1/auth/refresh — 토큰 갱신
  - POST /api/v1/auth/logout — 로그아웃

  에러 응답 6개 정의 (401, 403, 429 등)

  docs/technical/api-spec-auth.md에 저장했습니다."
```

### 예시 2: DB 스키마 설계

```
사용자: "대시보드 기능 DB 스키마 설계해줘"

→ Skill이 API 스펙 + 기존 스키마 분석 후:
  "대시보드 DB 스키마를 설계했습니다.

  엔티티 3개: Dashboard, Widget, WidgetConfig
  관계: User 1:N Dashboard, Dashboard 1:N Widget
  인덱스 4개 (사용자별 조회, 위젯 타입별 필터)

  기존 User 테이블과의 FK 관계 설정 포함.
  docs/technical/db-schema-dashboard.md에 저장했습니다."
```

### 예시 3: 아키텍처 문서 작성

```
사용자: "실시간 알림 기능 아키텍처 설계해줘"

→ Skill이 기존 아키텍처 + 요구사항 분석 후:
  "실시간 알림 아키텍처를 설계했습니다.

  기술 결정 2건:
  - WebSocket vs SSE → WebSocket 선택 (양방향 필요)
  - Redis Pub/Sub vs Kafka → Redis 선택 (규모 적합)

  컴포넌트: NotificationService, WebSocketGateway, EventStore
  시퀀스 다이어그램 포함.

  docs/technical/architecture-notification.md에 저장했습니다."
```

## 활용 Agent

- **Backend Dev**: API 스펙, DB 스키마, 서버 아키텍처
- **Frontend Dev**: API 인터페이스 확인, 컴포넌트 구조 설계
- **Fullstack Dev**: 전체 기술 설계
- **DevOps**: 인프라 아키텍처 관련 참고

## 리소스

- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html)
- [Database Normalization](https://en.wikipedia.org/wiki/Database_normalization)
- [Architecture Decision Records](https://adr.github.io/)
