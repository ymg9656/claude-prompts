# 에이전트 팀 극대화 활용 계획

> 작성일: 2026-03-23
> 상태: Phase 1~2 진행 중

## 배경

매번 작업할 때마다 다른 에이전트, 다른 팀, 다른 스킬들을 사용하는 것이 관리도 안 되고 비효율적.
관리 가능한 에이전트 팀을 만들어 재사용하려는 목적.

## 목적

에이전트 팀을 효율적으로 활용하기 위해:
1. 각각의 에이전트를 만들고
2. 에이전트들이 활용 가능한 스킬을 만들어 두고
3. 팀 생성 시 목적에 맞는 에이전트들로 팀을 구성해 작업

## 목표

프로젝트별 최적화된 팀을 생성해 작업하고, 에이전트/스킬/팀을 관리 가능한 형태로 재사용 가능한 구조로 만든다.

---

## 아키텍처: 3-Layer Composable System

```
┌─────────────────────────────────────────────┐
│  Layer 3: Team Presets (팀 프리셋)            │
│  목적별 사전 정의된 팀 구성                      │
│  예: feature-dev, code-review, security-audit │
├─────────────────────────────────────────────┤
│  Layer 2: Agent Registry (에이전트 레지스트리)   │
│  역할별 재사용 가능한 에이전트 풀                  │
│  예: backend-dev, frontend-dev, tester, ...  │
├─────────────────────────────────────────────┤
│  Layer 1: Skill Library (스킬 라이브러리)       │
│  에이전트가 활용하는 공용 스킬                     │
│  예: git-commit, test-runner, deploy, ...    │
└─────────────────────────────────────────────┘
```

핵심 원칙: **Agent는 역할만 정의하고, 프로젝트 컨텍스트는 팀 생성 시 주입한다**

---

## Phase 1: Skill Library 구축 (기반)

에이전트들이 공통으로 사용하는 스킬을 정리한다.

### 기본 스킬 셋

| 스킬 | 용도 | 활용 Agent |
|------|------|-----------|
| `git-commit` | 커밋 메시지 생성, 커밋 실행 | 전체 |
| `test-runner` | 테스트 실행, 커버리지 분석 | tester, backend-dev, frontend-dev |
| `code-review` | 코드 리뷰 체크리스트 실행 | code-reviewer |
| `api-generator` | API 코드 자동 생성 | backend-dev |
| `deploy` | 배포 파이프라인 실행 | devops |
| `db-migration` | DB 스키마 마이그레이션 | backend-dev |
| `lint-fix` | 린트 검사 및 자동 수정 | 전체 |
| `doc-generator` | API 문서, 변경 로그 생성 | tech-writer |

### 설계 원칙

- 하나의 스킬 = 하나의 책임 (SRP)
- 프레임워크 비의존적으로 작성 (감지 로직은 스킬 내부에서 처리)
- 스킬 간 조합 가능 (예: `test-runner` → `git-commit` 체이닝)

---

## Phase 2: Agent Registry 구축 (핵심)

프로젝트 독립적인 재사용 가능 Agent를 설계한다.

### 디렉토리 구조

```
agents/registry/
├── index.md                    # 전체 Agent 목록 + 메타데이터
├── leaders/
│   ├── project-lead.md         # 범용 프로젝트 리더
│   ├── review-lead.md          # 리뷰 전문 리더
│   └── audit-lead.md           # 감사 전문 리더
├── developers/
│   ├── backend-dev.md          # 백엔드 개발자
│   ├── frontend-dev.md         # 프론트엔드 개발자
│   └── fullstack-dev.md        # 풀스택 개발자
├── quality/
│   ├── tester.md               # 테스트 전문가
│   ├── code-reviewer.md        # 코드 리뷰어
│   └── security-auditor.md     # 보안 감사자
└── support/
    ├── tech-writer.md          # 기술 문서 작성자
    ├── devops.md               # DevOps 엔지니어
    └── debugger.md             # 디버깅 전문가
```

### Agent 프롬프트 표준 구조

```markdown
# {{ROLE_NAME}} Agent

## 정체성
당신은 {{TEAM_NAME}}의 {{ROLE_DESCRIPTION}}입니다.

## 핵심 역량
1. [프로젝트 독립적 역량]

## 활용 스킬
- {{SKILL}}: [활용 시점]

## 프로토콜
표준화된 수신/완료 프로토콜

## 프로젝트 컨텍스트 (팀 생성 시 주입)
- 기술 스택: {{TECH_STACK}}
- 프로젝트 경로: {{PROJECT_PATH}}
```

### Agent-Skill 매핑

| Agent | 카테고리 | 기본 스킬 | 선택 스킬 |
|-------|---------|----------|----------|
| backend-dev | developers | git-commit, test-runner, lint-fix | api-generator, db-migration |
| frontend-dev | developers | git-commit, test-runner, lint-fix | - |
| fullstack-dev | developers | git-commit, test-runner, lint-fix | api-generator |
| tester | quality | test-runner, lint-fix | - |
| code-reviewer | quality | code-review, lint-fix | - |
| security-auditor | quality | code-review | - |
| devops | support | deploy, git-commit | - |
| tech-writer | support | doc-generator | - |
| debugger | support | test-runner, lint-fix | - |

---

## Phase 3: Team Presets 구축 (조합) — 예정

목적별 사전 정의된 팀 조합을 만든다.

| 작업 유형 | 추천 프리셋 | 규모 | 워크플로우 |
|-----------|-----------|------|-----------|
| 새 기능 개발 | feature-development | 3~5명 | 병렬+순차 혼합 |
| PR 리뷰 | code-review-pipeline | 3~5명 | 파이프라인 |
| 버그 수정 | bug-fix | 2~3명 | 순차 |
| 보안 점검 | security-audit | 3~5명 | 병렬 |
| 코드 개선 | refactoring | 2~3명 | 순차 |
| 문서 작성 | documentation | 2~3명 | 병렬 |

---

## Phase 4: 팀 생성 자동화 — 예정

팀 프리셋 + 프로젝트 컨텍스트로 팀을 즉시 생성하는 스킬을 만든다.

```
사용자 입력                    자동 처리
─────────                    ──────────
1. 프리셋 선택         →  2. Agent 프롬프트 조립
3. 프로젝트 정보 입력   →  4. config.json 생성
                       →  5. 멤버 시스템 프롬프트 생성
                       →  6. inbox/ 초기화
```

---

## 실행 로드맵

| Phase | 내용 | 우선순위 | 상태 |
|-------|------|---------|------|
| Phase 1 | Skill Library 구축 | 높음 | 진행 중 |
| Phase 2 | Agent Registry 구축 | 높음 | 진행 중 |
| Phase 3 | Team Presets 구축 | 중간 | 예정 |
| Phase 4 | 팀 생성 자동화 | 낮음 | 예정 |

---

## 비판적 검토

### 긍정적
- 재사용성 문제 해결 (레지스트리 기반)
- 점진적 구축 가능 (Phase 1부터 즉시 가치)
- Claude Code 아키텍처(config.json, inbox, subscription)와 정합

### 주의사항
- 오버엔지니어링 위험: 자주 사용하는 2~3개 팀부터 검증 후 확장
- 파라미터화 vs 전문화 트레이드오프: 범용 Agent가 전문 Agent보다 품질이 낮을 수 있음
- 토큰 비용: 팀 멤버 1명 = 독립 Claude 세션 = 비용 비례 증가
- 검증 필요: 실제 프로젝트 2~3개에 적용 후 회고 필수
