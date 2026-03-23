# 활용 가이드 — 다른 프로젝트에서 claude-prompts 사용하기

> 이 가이드는 claude-prompts 저장소의 Agent, Skill, Team을 자신의 프로젝트에서 활용하는 방법을 설명합니다.

---

## 전체 구조 이해

```
claude-prompts/
├── skills/library/          ← 스킬 라이브러리 (9개)
├── agents/registry/         ← 에이전트 레지스트리 (14개)
├── teams/templates/         ← 팀 생성/운영 템플릿
├── teams/examples/          ← 팀 구성 완성 예시
└── _common/                 ← 공통 규칙 (플레이스홀더, 평가 기준)
```

핵심 원칙: **Agent는 역할만 정의하고, 프로젝트 컨텍스트는 사용 시 주입한다.**

---

## 1단계: 단일 Agent 또는 Skill 활용

가장 빠른 시작 방법입니다. 필요한 Agent나 Skill 하나를 가져와서 바로 사용합니다.

### Agent 활용

1. `agents/registry/index.md`에서 필요한 Agent를 선택합니다.
2. 해당 Agent 파일을 열고 플레이스홀더를 자신의 프로젝트 정보로 대체합니다.
3. Claude Code의 시스템 프롬프트 또는 CLAUDE.md에 붙여넣습니다.

**예시: 코드 리뷰어 Agent 활용**

`agents/registry/quality/code-reviewer.md`를 열고:

```markdown
# 변경 전 (템플릿)
당신은 {{TEAM_NAME}}의 코드 리뷰어입니다.
- 기술 스택: {{TECH_STACK}}
- 프로젝트 경로: {{PROJECT_PATH}}

# 변경 후 (내 프로젝트)
당신은 my-saas-project의 코드 리뷰어입니다.
- 기술 스택: Next.js 14, TypeScript, Prisma, PostgreSQL
- 프로젝트 경로: /home/user/my-saas-project
```

이렇게 수정한 프롬프트를 다음 중 하나에 설정합니다:

```bash
# 방법 A: CLAUDE.md에 추가
echo "위 프롬프트 내용" >> /home/user/my-saas-project/CLAUDE.md

# 방법 B: .claude/agents/ 디렉토리에 Agent로 등록
mkdir -p /home/user/my-saas-project/.claude/agents
cp code-reviewer.md /home/user/my-saas-project/.claude/agents/
```

### Skill 활용

1. `skills/library/index.md`에서 필요한 Skill을 선택합니다.
2. SKILL.md 파일을 프로젝트의 `.claude/skills/` 디렉토리에 복사합니다.

```bash
# 예: test-runner 스킬을 내 프로젝트에 추가
mkdir -p /home/user/my-saas-project/.claude/skills/test-runner
cp skills/library/test-runner/SKILL.md \
   /home/user/my-saas-project/.claude/skills/test-runner/
```

스킬이 스크립트나 리소스를 포함하는 경우 함께 복사합니다:

```bash
# git-commit 스킬 (스크립트 포함)
cp -r skills/examples/git-commit-skill/* \
   /home/user/my-saas-project/.claude/skills/git-commit/
```

### 플레이스홀더 규칙

| 형식 | 의미 | 처리 |
|------|------|------|
| `{{FIELD_NAME}}` | 필수 입력 | 반드시 실제 값으로 대체 |
| `{{?FIELD_NAME}}` | 선택 입력 | 불필요하면 해당 줄 삭제 |
| `<!-- 설명 -->` | 작성 가이드 | 사용 후 삭제 |

자주 사용하는 플레이스홀더:

```
{{TEAM_NAME}}           → my-feature-team
{{TECH_STACK}}          → Next.js 14, TypeScript, Prisma, PostgreSQL
{{PROJECT_PATH}}        → /home/user/my-saas-project
{{?CONVENTIONS}}        → Airbnb ESLint, Conventional Commits
{{?PROJECT_DESCRIPTION}} → B2B SaaS 고객 관리 플랫폼
```

---

## 2단계: 팀 조합 활용

여러 Agent를 조합해 팀으로 운영합니다. 복잡한 기능 개발, 코드 리뷰 파이프라인, 보안 감사 등에 적합합니다.

### 팀 구성 프로세스

```
1. 목적에 맞는 Agent 선택 (registry에서)
    ↓
2. config.json 작성 (팀 구성 정의)
    ↓
3. 리더 시스템 프롬프트 작성 (워크플로우 정의)
    ↓
4. 멤버 시스템 프롬프트에 프로젝트 컨텍스트 주입
    ↓
5. 팀 실행
```

### 예시: 기능 개발 팀 구성

**Agent 선택:**

```
agents/registry/leaders/project-lead.md     → 리더
agents/registry/developers/backend-dev.md   → 백엔드
agents/registry/developers/frontend-dev.md  → 프론트엔드
agents/registry/quality/tester.md           → 테스터
```

**config.json 작성:**

`teams/templates/creation/team-config.md` 템플릿의 플레이스홀더를 채웁니다:

```json
{
  "name": "dashboard-feature-team",
  "description": "대시보드 기능 개발 팀",
  "leadAgentId": "team-lead@dashboard-feature-team",
  "members": [
    {
      "agentId": "team-lead@dashboard-feature-team",
      "agentType": "team-lead",
      "model": "claude-opus-4-6",
      "cwd": "/home/user/my-saas-project",
      "subscriptions": [
        "backend-dev@dashboard-feature-team",
        "frontend-dev@dashboard-feature-team",
        "tester@dashboard-feature-team"
      ]
    },
    {
      "agentId": "backend-dev@dashboard-feature-team",
      "agentType": "team-member",
      "model": "claude-opus-4-6",
      "cwd": "/home/user/my-saas-project",
      "subscriptions": ["team-lead@dashboard-feature-team"]
    },
    {
      "agentId": "frontend-dev@dashboard-feature-team",
      "agentType": "team-member",
      "model": "claude-opus-4-6",
      "cwd": "/home/user/my-saas-project",
      "subscriptions": [
        "team-lead@dashboard-feature-team",
        "backend-dev@dashboard-feature-team"
      ]
    },
    {
      "agentId": "tester@dashboard-feature-team",
      "agentType": "team-member",
      "model": "claude-opus-4-6",
      "cwd": "/home/user/my-saas-project",
      "subscriptions": [
        "team-lead@dashboard-feature-team",
        "backend-dev@dashboard-feature-team",
        "frontend-dev@dashboard-feature-team"
      ]
    }
  ]
}
```

**워크플로우 정의 (리더 프롬프트에 추가):**

```markdown
## 워크플로우

Phase 1 - 설계 (순차): 리더가 API/UI 스펙 작성
Phase 2 - 구현 (병렬): backend-dev + frontend-dev 동시 작업
Phase 3 - 통합 (순차): frontend-dev가 실제 API 연동
Phase 4 - 테스트 (순차): tester가 통합 테스트 실행
Phase 5 - 완료 (순차): 리더가 결과 통합, 완료 보고
```

### 팀 운영 참고 템플릿

| 목적 | 참고 파일 |
|------|----------|
| 작업 분배 전략 | `teams/templates/usage/team-task-assignment.md` |
| 워크플로우 실행 | `teams/templates/usage/team-workflow-execution.md` |
| 에이전트 간 통신 | `teams/templates/usage/team-communication.md` |
| 완성 예시 참고 | `teams/examples/feature-dev-team.md` |

### 커뮤니케이션 패턴 선택

| 패턴 | 적합한 경우 | 예시 |
|------|-----------|------|
| **Hub-and-spoke** | 리더가 중심, 멤버는 리더와만 통신 | 기능 개발 |
| **Pipeline** | 단계별 순차 처리, 앞 단계 출력이 다음 입력 | 코드 리뷰 |
| **Parallel** | 독립적인 작업을 동시 실행 후 결과 통합 | 보안 감사 |

---

## 3단계: 커스터마이징 및 확장

기존 Agent/Skill을 수정하거나 새로운 것을 추가합니다.

### 커스텀 Agent 추가

기존 Agent를 베이스로 프로젝트 전용 Agent를 만듭니다.

```bash
# 1. 기존 Agent를 복사하여 시작
cp agents/registry/developers/backend-dev.md \
   agents/registry/developers/data-engineer.md

# 2. 역할에 맞게 수정
# - 정체성, 핵심 역량, 활용 스킬, 도구 사용 규칙 변경
# - 프로토콜은 동일 구조 유지 (팀 호환성)
```

커스텀 Agent 작성 시 유지해야 할 구조:

```markdown
# {Role Name} Agent

## 정체성              ← 역할 정의
## 핵심 역량            ← 프로젝트 독립적 역량
## 활용 스킬            ← Skill Library 참조
## 도구 사용 규칙        ← 허용/금지 도구
## 작업 수신 프로토콜     ← 리더로부터 작업 수신 방법
## 작업 완료 프로토콜     ← JSON 메시지 형식
## 다른 멤버와의 관계     ← 역할 기반 관계
## 프로젝트 컨텍스트      ← {{PLACEHOLDER}} 유지
```

**핵심: 프로토콜 호환성을 유지하세요.** 작업 수신/완료의 JSON 형식을 동일하게 유지해야 다른 Agent들과 팀으로 조합할 수 있습니다.

### 커스텀 Skill 추가

```bash
mkdir -p skills/library/my-new-skill
```

SKILL.md 작성 형식:

```markdown
---
name: my-new-skill
description: 스킬 설명
---

# Skill Name

설명

## 핵심 기능
- 기능 목록

## 워크플로우
### 1. 단계명
설명 + 코드 블록

## 에러 처리
| 에러 | 원인 | 해결 |

## 사용 예시
### 예시 1: 제목
입출력 예시

## 리소스
- 참고 링크
```

스킬 추가 후 `skills/library/index.md`의 테이블에 등록합니다.

### 커스텀 Team Preset 추가

자주 사용하는 팀 조합을 프리셋으로 저장합니다.

```bash
# teams/presets/ 디렉토리에 프리셋 저장 (Phase 3 예정)
```

프리셋 파일 구조:

```markdown
# {Preset Name}

## 팀 구성
- agent 1 (registry 경로)
- agent 2 (registry 경로)

## 워크플로우
Phase 정의

## 커뮤니케이션 패턴
패턴 종류

## 프로젝트 주입 변수
필요한 플레이스홀더 목록
```

---

## 빠른 참조: Agent-Skill 매핑

어떤 Agent에 어떤 Skill을 연결해야 하는지 한눈에 확인합니다.

| Agent | 기본 스킬 | 선택 스킬 |
|-------|----------|----------|
| **system-planner** | `project-planning` | `doc-generator` |
| **project-manager** | `project-planning` | — |
| **project-lead** | — | — |
| **review-lead** | `code-review` | — |
| **audit-lead** | `code-review` | — |
| **backend-dev** | `git-commit`, `test-runner`, `lint-fix` | `api-generator`, `db-migration` |
| **frontend-dev** | `git-commit`, `test-runner`, `lint-fix` | — |
| **fullstack-dev** | `git-commit`, `test-runner`, `lint-fix` | `api-generator` |
| **tester** | `test-runner`, `lint-fix` | — |
| **code-reviewer** | `code-review`, `lint-fix` | — |
| **security-auditor** | `code-review` | — |
| **tech-writer** | `doc-generator` | — |
| **devops** | `deploy`, `git-commit` | — |
| **debugger** | `test-runner`, `lint-fix` | — |

---

## 빠른 참조: 작업 유형별 추천 팀 구성

| 작업 | 추천 구성 | 규모 | 패턴 |
|------|----------|------|------|
| 신규 프로젝트 (기획→개발) | project-lead + **system-planner** + **project-manager** + backend + frontend + tester | 6명 | Hub-and-spoke |
| 새 기능 개발 (기획 포함) | project-lead + **system-planner** + backend + frontend + tester | 5명 | Hub-and-spoke |
| 새 기능 개발 (기획 완료) | project-lead + backend + frontend + tester | 4명 | Hub-and-spoke |
| 소규모 기능 | project-lead + fullstack + tester | 3명 | Hub-and-spoke |
| PR 코드 리뷰 | review-lead + code-reviewer + security-auditor | 3명 | Pipeline |
| 버그 수정 | project-lead + debugger + tester | 3명 | Hub-and-spoke |
| 보안 감사 | audit-lead + security-auditor + code-reviewer | 3명 | Parallel |
| 문서 작성 | project-lead + tech-writer | 2명 | Hub-and-spoke |
| 리팩토링 | project-lead + fullstack + code-reviewer | 3명 | Hub-and-spoke |

### 기획 포함 팀의 워크플로우

기획 Agent가 포함된 팀은 설계 전에 기획 Phase가 추가됩니다:

```
Phase 0 - 기획 (순차)
  └─ system-planner: 요구사항 분석, 기능 명세서, 화면 흐름 작성
  └─ project-manager: WBS 작성, 일정 산정, 마일스톤 정의

Phase 1 - 설계 (순차)
  └─ 리더: 기획 산출물 기반으로 API 스펙, DB 스키마 설계

Phase 2 - 구현 (병렬)
  └─ backend-dev + frontend-dev 동시 작업

Phase 3 이후 - 테스트/리뷰/통합
  └─ (기존과 동일)
```

기획 산출물(요구사항 명세서, 기능 명세서)이 이후 모든 Phase의 입력이 됩니다.
세부 기술 문서(API 스펙, DB 스키마, 아키텍처 문서)는 각 담당자가 작성합니다.

---

## 주의사항

### 팀 사용 시 알아야 할 제약

- **세션 복구 불가**: `/resume`, `/rewind`으로 팀원 세션을 복구할 수 없음
- **팀 중첩 불가**: 팀원이 자신의 팀을 생성할 수 없음
- **세션당 1팀**: 하나의 리더 세션에서 하나의 팀만 운영
- **토큰 비용**: 팀원 N명 = 약 N배의 토큰 비용

### 팀이 필요 없는 경우

- 단순하고 순차적인 작업 → 단일 Agent로 충분
- 같은 파일을 동시에 편집해야 하는 경우 → 충돌 위험
- 빠르게 끝나는 작업 → 팀 셋업 오버헤드가 더 클 수 있음

### 효과적인 팀 활용 팁

1. **리더에게 충분한 컨텍스트를**: 리더 프롬프트에 프로젝트 구조, 코딩 컨벤션, 워크플로우를 상세히 기술
2. **작업 범위를 명확히**: 각 멤버의 책임 범위가 겹치지 않도록 설계
3. **의존성 최소화**: 병렬 실행 가능한 작업을 최대화
4. **작은 팀부터 시작**: 2~3명으로 시작하고 필요 시 확장
