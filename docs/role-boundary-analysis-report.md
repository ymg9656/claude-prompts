# 역할 경계 분석 리포트

> 분석일: 2026-03-24
> 대상: 전체 Agent (14개), Skill (10개), Team (3개 예시 + 템플릿)
> 목적: `project-planning` 스킬의 역할 경계 문제와 유사한 패턴을 전체 문서에서 식별

---

## 요약

전체 문서를 분석한 결과 **Agent 13건, Skill 9건, Team 15건**, 총 **37건**의 역할 경계 이슈를 발견했습니다.

| 심각도 | Agent | Skill | Team | 합계 |
|--------|-------|-------|------|------|
| **High** | 3 | 4 | 4 | **11** |
| **Medium** | 7 | 3 | 7 | **17** |
| **Low** | 3 | 2 | 4 | **9** |

### 근본 원인

**기획 → 설계 → 구현** 3단계의 역할 경계가 불명확합니다:

```
기획자 (project-planning)  →  무엇을 만들 것인가 (비즈니스 명세)
설계자 (technical-spec)    →  어떻게 구현할 것인가 (기술 설계)
개발자 (code generators)   →  실제 구현 (코드 생성/실행)
```

현재 문서에서는 이 경계가 곳곳에서 침범되고 있습니다.

---

## 1. Agent 역할 경계 이슈 (13건)

### High (즉시 수정 필요)

#### 1-1. Project Lead vs Project Manager — 일정 관리 권한 중복

| 항목 | 내용 |
|------|------|
| **Agent** | Project Lead, Project Manager |
| **문제** | 두 Agent 모두 일정 관리/진행 추적을 담당 |
| **충돌 내용** | PL: "작업 상태 추적, 블로커 식별, 우선순위 조정" / PM: "작업 상태 대시보드 관리, 지연 항목 식별, 일정 재조정" |
| **권장** | PM이 일정/마일스톤 소유, PL은 작업 분배/실행 관리만 담당 |

#### 1-2. Debugger — 코드 수정 권한 월권

| 항목 | 내용 |
|------|------|
| **Agent** | Debugger |
| **문제** | "원인 분석 후 수정 방안을 제시하거나 **직접 수정**합니다" + Edit 도구 사용 |
| **충돌** | Backend-Dev/Frontend-Dev의 코드 수정 권한 침범 |
| **권장** | Debugger는 진단/원인 분석만 수행, 수정은 개발자에게 위임 |

#### 1-3. Security Auditor vs Code Reviewer — 보안 리뷰 이중 수행

| 항목 | 내용 |
|------|------|
| **Agent** | Security Auditor, Code Reviewer |
| **문제** | Code Reviewer가 "보안 취약점 탐지: SQL Injection, XSS, 인증/인가 이슈 식별"을 포함 |
| **충돌** | Security Auditor의 SAST/보안 분석과 완전 중복 |
| **권장** | Code Reviewer에서 보안 리뷰 제거, 코드 품질/아키텍처 검증에 집중 |

### Medium (개선 권장)

| # | Agent | 문제 | 충돌 대상 |
|---|-------|------|----------|
| 1-4 | System Planner / Project Manager | 제약 조건 확인 영역 구분 필요 (SP: 기술적 제약, PM: 일정/리소스 제약) | 영역별 소유권 명시 |
| 1-5 | Audit Lead / Review Lead | 리뷰 파이프라인 관리 경계 모호 | 감사 vs 코드리뷰 구분 |
| 1-6 | Backend-Dev / Fullstack-Dev | API 설계/구현 동일 책임 | 상호 배타적 역할 명시 필요 |
| 1-7 | DevOps / Backend-Dev | 환경 변수 관리 소유권 | Backend는 목록 제공만, 설정은 DevOps |
| 1-8 | Architect (Example) / System Planner | Architect 예시에 관계(relationships) 섹션 자체가 누락됨 | System Planner와의 협업 정의 필요 |
| 1-9 | Security Auditor / DevOps | 인프라 보안 점검 vs 인프라 관리 | 감사(읽기)와 설정(쓰기) 분리 필요 |
| 1-10 | Project Manager / Project Lead | 리스크 관리 이중 수행 | PM이 리스크 레지스터 소유 명시 필요 |

### Low (참고)

| # | Agent | 문제 |
|---|-------|------|
| 1-11 | Tech Writer / System Planner | 문서 체계 전략(Planner) vs 문서 작성 실행(Writer) 경계 |
| 1-12 | Tester / Code Reviewer | 테스트 적절성 검토 권한 (전략 vs 코드 품질) |
| 1-13 | Fullstack-Dev | 통합 테스트 수행 — Tester 영역 침범 |

---

## 2. Skill 역할 경계 이슈 (9건)

### High (즉시 수정 필요)

#### 2-1. api-generator — 설계와 구현의 혼재

| 항목 | 내용 |
|------|------|
| **Skill** | `api-generator` |
| **문제** | "자연어 요구사항에서 API 스펙 자동 추출" — API **설계**를 포함 |
| **충돌** | `technical-spec`이 API 설계를 담당해야 하는데 api-generator도 동일 기능 수행 |
| **권장** | api-generator는 **이미 설계된** API 스펙을 받아 코드만 생성. 설계는 technical-spec 전용 |

#### 2-2. technical-spec vs db-migration — DB 스키마 소유권

| 항목 | 내용 |
|------|------|
| **Skill** | `technical-spec`, `db-migration` |
| **문제** | technical-spec이 DB 스키마를 설계하지만, db-migration이 technical-spec에 대한 의존 관계를 명시하지 않음 |
| **충돌** | db-migration은 이미 변경된 스키마로부터 마이그레이션을 생성하지만, 설계 단계(technical-spec)와의 연결이 문서에 없음 |
| **권장** | db-migration에 "technical-spec의 스키마 설계를 기반으로 실행" 의존 관계 명시 |

#### 2-3. code-review vs lint-fix — 코드 스타일 검사 중복

| 항목 | 내용 |
|------|------|
| **Skill** | `code-review`, `lint-fix` |
| **문제** | code-review가 "가독성" (네이밍, 포맷팅 포함)을 검사, lint-fix도 스타일/포맷팅 수정 |
| **충돌** | 자동화 가능한 검사(lint-fix)와 의미적 검토(code-review) 경계 모호 |
| **권장** | lint-fix = 도구 기반 자동 검사 (ESLint, Prettier), code-review = 의미적/논리적 검토만 |

#### 2-4. API 문서 — 3개 스킬에서 중복 생성

| 항목 | 내용 |
|------|------|
| **Skill** | `technical-spec`, `api-generator`, `doc-generator` |
| **문제** | 3개 스킬 모두 API 문서 관련 기능 보유 |
| **충돌** | technical-spec이 OpenAPI 설계 → api-generator가 코드 생성 → doc-generator가 코드에서 문서 추출. 파이프라인은 맞지만 경계가 문서에 명시되지 않음 |
| **권장** | 단방향 흐름 명시: `technical-spec(설계)` → `api-generator(구현)` → `doc-generator(문서화)` |

### Medium (개선 권장)

| # | Skill | 문제 | 충돌 대상 |
|---|-------|------|----------|
| 2-5 | `test-runner` | "품질 점검" (테스트 패턴 가이드 기반) — 단, 테스트 코드 품질이지 프로덕션 코드 품질은 아님 | `code-review` (도메인 차이 있음) |
| 2-6 | `deploy` | 배포 전 테스트 실행은 test-runner 영역 (배포 안전 게이트로 정당화 가능) | `test-runner` |
| 2-7 | `doc-generator` | 프로젝트 구조 분석(프레임워크 감지 등)은 개발자 작업 | 개발자 영역 |

### Low (참고)

| # | Skill | 문제 |
|---|-------|------|
| 2-8 | `git-commit` | 커밋 전 린트/테스트 검증 — lint-fix, test-runner 영역 |
| 2-9 | `deploy` | 롤백 시 db-migration 롤백 연계 미정의 (프로세스 갭) |

---

## 3. Team 역할 경계 이슈 (15건)

### High (즉시 수정 필요)

#### 3-1. 리더가 멤버 작업 수행 (전체 예시 공통)

| 항목 | 내용 |
|------|------|
| **Team** | feature-dev-team, code-review-pipeline, security-audit-team |
| **문제** | 리더가 요구사항 분석, PR 분석, 프로젝트 구조 분석 등 전문 작업 직접 수행 |
| **위반** | 아키텍처 원칙 §5: "리더: 작업 분배, 진행 모니터링, 결과 통합 (Skill 최소화)" |
| **권장** | 리더는 분배/통합만, 전문 분석은 멤버에게 위임 |

#### 3-2. 멤버 간 책임 중복 (code-review, security-audit)

| 항목 | 내용 |
|------|------|
| **Team** | code-review-pipeline, security-audit-team |
| **문제** | logic-reviewer와 security-auditor가 "설계 패턴" 동시 분석, 3개 Agent가 입력 검증 중복 분석 |
| **위반** | 아키텍처 원칙 §5: "겹치는 역할 금지: 각 멤버의 책임 범위가 명확히 분리" |
| **권장** | 각 분석 영역에 단일 소유자 지정, 교차 검증 시 프로토콜 명시 |

#### 3-3. Skill 매핑 누락 (전체 예시)

| 항목 | 내용 |
|------|------|
| **Team** | 3개 예시 모두 |
| **문제** | Agent 정의에 `skills:` 필드가 없음 — 레지스트리의 스킬 매핑이 팀 예시에 반영되지 않음 |
| **위반** | 아키텍처 원칙 §5의 Agent 카테고리별 Skill 매핑 |
| **권장** | 모든 팀 예시의 Agent 정의에 skills 필드 추가 |

#### 3-4. 레지스트리 미등록 Agent 사용 (code-review, security-audit)

| 항목 | 내용 |
|------|------|
| **Team** | code-review-pipeline (style-checker, logic-reviewer, performance-analyst), security-audit-team (static-analyzer, dependency-checker, infra-auditor, pentest-simulator) |
| **문제** | Agent Registry에 없는 커스텀 Agent 7개 사용 |
| **권장** | 레지스트리에 추가하거나, 기존 Agent(Code Reviewer 등)를 재활용하도록 리팩터 |

### Medium (개선 권장)

| # | Team | 문제 |
|---|------|------|
| 3-5 | 전체 | 구독 패턴 비순환 검증 규칙 부재 — 실제로는 비순환이지만 형식적 보장 없음 |
| 3-6 | 전체 | 충돌 해결 프로토콜 없음 — 멤버 간 결과 충돌 시 처리 방안 미정의 |
| 3-7 | code-review-pipeline | 핸드오프 페이로드 스키마 미정의 — 파이프라인 단계 간 데이터 형식 불명확 |
| 3-8 | 전체 리더 정의 | 리더 역할 범위 모호 — "결과물 검토"가 승인인지 재작업인지 불명확 |
| 3-9 | 전체 | 에러 핸들링 불완전 — blocked 상태의 에스컬레이션 경로 미정의 |
| 3-10 | code-review-pipeline | Agent 간 직접 통신 미정의 — 파이프라인인데 메시지 타입 없음 |
| 3-11 | 전체 | 팀 규모/비용 제약 미반영 — 5명 상한 검증 로직 없음 |

### Low (참고)

| # | Team | 문제 |
|---|------|------|
| 3-12 | 테스트 템플릿 | 팀 예시와의 크로스 레퍼런스 없음 |
| 3-13 | 전체 | 의존성 그래프 시각화 없음 |
| 3-14 | 전체 | Phase 표기 불일치 ("Phase 1" vs "1단계") |
| 3-15 | Skill Library | 팀 예시의 스킬 참조와 라이브러리 매핑 미검증 |

---

## 4. 우선 수정 로드맵

### Phase 1: 즉시 수정 (High 이슈)

| 순서 | 작업 | 대상 파일 | 이슈 # |
|------|------|----------|--------|
| 1 | Debugger에서 코드 수정 권한 제거 | `agents/registry/support/debugger.md` | 1-2 |
| 2 | Code Reviewer에서 보안 리뷰 제거 | `agents/registry/quality/code-reviewer.md` | 1-3 |
| 3 | api-generator에서 API 설계 기능 분리 | `skills/library/api-generator/SKILL.md` | 2-1 |
| 4 | code-review에서 자동화 가능 스타일 검사 제거 | `skills/library/code-review/SKILL.md` | 2-3 |
| 5 | 스킬 간 단방향 파이프라인 명시 | `technical-spec`, `api-generator`, `doc-generator` | 2-4 |
| 6 | technical-spec/db-migration 의존 관계 명시 | 양쪽 SKILL.md | 2-2 |
| 7 | 팀 예시에서 리더 역할 축소 | 3개 팀 예시 | 3-1 |
| 8 | 팀 예시에 Skill 매핑 추가 | 3개 팀 예시 | 3-3 |

### Phase 2: 단기 개선 (Medium 이슈)

| 순서 | 작업 | 이슈 # |
|------|------|--------|
| 1 | PL/PM 일정 관리 권한 분리 | 1-1 |
| 2 | Backend-Dev/Fullstack-Dev 상호 배타 명시 | 1-6 |
| 3 | deploy에서 테스트 실행 제거 (smoke test만 유지) | 2-6 |
| 4 | 팀 커뮤니케이션 핸드오프 스키마 정의 | 3-7 |
| 5 | 미등록 Agent 레지스트리 추가 또는 리팩터 | 3-4 |
| 6 | 충돌 해결 프로토콜 추가 | 3-6 |

### Phase 3: 장기 개선 (Low 이슈 + 구조적 개선)

- 스킬 간 파이프라인 다이어그램 추가
- 팀 테스트 템플릿과 예시 간 크로스 레퍼런스
- 팀 비용 모델 가이드 추가
- 용어 통일 (Phase vs 단계)

---

## 5. 핵심 설계 원칙 제안

분석 결과를 바탕으로 아키텍처 원칙에 추가할 규칙을 제안합니다:

### 역할 경계 원칙

```
1. 단일 소유자: 모든 산출물에는 단일 소유 역할이 있어야 한다
2. 읽기/쓰기 분리: 감사/리뷰 역할은 읽기만, 수정은 소유 역할이 수행
3. 단방향 흐름: 기획 → 설계 → 구현 → 검증, 역방향 의존 금지
4. 상호 배타: 동일 도메인의 일반형/전문형 Agent는 같은 팀에 배치 금지
   (예: Backend-Dev + Fullstack-Dev 동시 사용 금지)
5. 리더 최소 개입: 리더는 분배/통합만, 전문 작업 직접 수행 금지
```

### 스킬 파이프라인

```
project-planning (비즈니스 명세)
       ↓
technical-spec (기술 설계: API 스펙, DB 스키마)
       ↓
  ┌────┴────┐
  ↓         ↓
api-generator  db-migration (구현)
  ↓
doc-generator (문서화)
```
