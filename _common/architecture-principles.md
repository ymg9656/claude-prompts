# 아키텍처 원칙

Claude Code의 Agent, Skill, Team 설계 시 준수해야 하는 핵심 아키텍처 원칙입니다.

---

## 1. 의존성 계층 (Dependency Hierarchy)

```
Teams → Agents → Skills → MCP/Subagents → Model
```

**단방향 의존만 허용:**
- Team은 Agent를 조합하지만, Agent는 자신이 속한 Team을 알지 못함
- Agent는 Skill을 사용하지만, Skill은 특정 Agent에 의존하지 않음
- Skill은 MCP 서버를 활용하지만, MCP는 Skill 구현을 모름

**위반 시 문제:**
- 순환 의존 → 변경 영향 범위 확대, 재사용성 저하
- 상위 계층 인지 → 하위 계층의 독립 테스트 불가

| 계층 | 역할 | 런타임 위치 | 템플릿 위치 |
|------|------|-----------|------------|
| **Teams** | 멀티 에이전트 협업 오케스트레이션 | `.claude/teams/` config.json | `teams/templates/creation/` |
| **Agents** | 독립적 작업 수행 + 도구/권한 관리 | `.claude/agents/*.md` (YAML frontmatter) | `agents/templates/creation/`, `agents/registry/` |
| **Skills** | 재사용 가능한 지시사항 번들 | `.claude/skills/*/SKILL.md` | `skills/templates/creation/`, `skills/library/` |
| **MCP/Subagents** | 외부 도구 통합 및 포크 실행 | `mcpServers` 설정, `context: fork` | — |
| **Model** | 기반 LLM | `model` 필드 | — |

---

## 2. Progressive Disclosure (점진적 노출)

컨텍스트 윈도우를 효율적으로 사용하기 위해 정보를 3단계로 나누어 로드합니다.

### 단계

| 단계 | 내용 | 로드 시점 |
|------|------|----------|
| **1. 메타데이터** | YAML frontmatter (이름, 설명, 도구, 모델) | 항상 로드 |
| **2. 본문** | SKILL.md / Agent .md 본문 지시사항 | 호출 시 로드 |
| **3. 리소스** | references/, scripts/, 외부 문서 | 필요 시 동적 로드 |

### 적용 패턴

```markdown
<!-- 1단계: frontmatter — 항상 노출 -->
---
name: my-skill
description: 설명 (트리거 판단에 사용됨)
---

<!-- 2단계: 본문 — 호출 시 로드 -->
# 핵심 지시사항
...

<!-- 3단계: 리소스 — 필요 시 동적 주입 -->
현재 설정값:
!cat ${CLAUDE_SKILL_DIR}/references/config.yaml!
```

---

## 3. Agent vs Subagent 런타임 구분

| 속성 | Top-level Agent | Subagent |
|------|----------------|----------|
| 실행 방식 | 직접 실행 또는 `claude -a agent.md` | `context: fork`로 분리 실행 |
| 컨텍스트 | 부모 대화 전체 접근 | 독립 컨텍스트 (포크) |
| 재사용 | Agent .md 파일 자체가 재사용 단위 | 동일 .md를 subagent로도 사용 가능 |
| 비용 제어 | `model` 필드로 직접 지정 | `model: haiku` (저비용) / `model: opus` (고성능) |
| 안전 제어 | `--permission-mode`, `--max-turns` (CLI 런타임 옵션) | 동일 옵션 적용 |
| 결과 반환 | 직접 출력 | 부모에게 결과 메시지 반환 |

### 내장 Subagent 타입

| 타입 | 용도 | 특징 |
|------|------|------|
| `general-purpose` | 범용 작업 수행 | 모든 도구 접근 가능 |
| `plan` | 구현 전략 설계 | 읽기 전용 도구만 사용 |
| `explore` | 코드베이스 탐색 | 빠른 검색 특화 |

---

## 4. Skill 패턴 선택 가이드

Skill 설계 시 다음 3가지 패턴 중 적합한 것을 선택합니다.

| 패턴 | 구성 | 적합한 경우 | 예시 |
|------|------|------------|------|
| **A: 순수 마크다운** | SKILL.md만 | 지시사항/체크리스트/문서 참조 | 코드 리뷰 가이드, 커밋 규칙 |
| **B: 스크립트 번들** | SKILL.md + scripts/ | Shell/Python 로직 필요 | 빌드 자동화, 마이그레이션 |
| **C: MCP/Subagent** | SKILL.md + mcpServers/agent | 외부 시스템 연동, 복잡한 분석 | Jira 연동, 보안 감사 |

### 선택 기준 플로우

```
외부 시스템 연동이 필요한가?
  ├─ Yes → 패턴 C (MCP/Subagent)
  └─ No → Shell/Python 실행이 필요한가?
           ├─ Yes → 패턴 B (스크립트 번들)
           └─ No → 패턴 A (순수 마크다운)
```

### 저장소 내 Skill 패턴 분포

| 패턴 | Skill | 위치 |
|------|-------|------|
| **A: 순수 마크다운** | `code-review`, `project-planning`, `technical-spec`, `deploy`, `db-migration`, `lint-fix`, `doc-generator` 외 라이브러리 전체 | `skills/library/` |
| **B: 스크립트 번들** | `git-commit-skill` (scripts/), `test-runner-skill` (references/), `api-generator-skill` (assets/) | `skills/examples/` |
| **C: MCP/Subagent** | — | 필요 시 추가 |

> - 라이브러리 Skill은 모두 SKILL.md 단일 파일 (패턴 A)이며, 인라인 bash 코드 블록으로 워크플로우를 정의합니다.
> - 패턴 B 예시는 `skills/examples/`에서 확인할 수 있습니다.
> - 전체 Skill 목록: [`skills/library/index.md`](../skills/library/index.md)

---

## 5. Team 역할 분리 + Skill 매핑

### 역할 분리 원칙

- **리더**: 작업 분배, 진행 모니터링, 결과 통합 (Skill 최소화)
- **멤버**: 전문 작업 수행 (역할별 Skill 프리로드)
- **겹치는 역할 금지**: 각 멤버의 책임 범위가 명확히 분리

### Agent 카테고리별 Skill 매핑

| 카테고리 | Agent 예시 | 기본 Skill | 선택 Skill |
|---------|-----------|-----------|-----------|
| **Planning** | System Planner, Project Manager | `project-planning` | `doc-generator` |
| **Leaders** | Project Lead, Review Lead, Audit Lead | — (또는 `code-review`) | — |
| **Developers** | Backend Dev, Frontend Dev, Fullstack Dev | `git-commit`, `test-runner`, `lint-fix` | `api-generator`, `db-migration`, `technical-spec` |
| **Quality** | Tester, Code Reviewer, Security Auditor | `test-runner`/`code-review`, `lint-fix` | — |
| **Support** | Tech Writer, DevOps, Debugger | 역할별 상이 (`doc-generator`, `deploy` 등) | — |

> 전체 Agent 목록: [`agents/registry/index.md`](../agents/registry/index.md)

### 최적 팀 규모

- **멤버 수**: 3-5명 (리더 포함)
- **태스크/멤버**: 5-6개 이하
- **비용 인식**: 각 멤버가 독립 Claude 세션을 소비

---

## 6. Post-session Skill 추출 루프

반복 사용되는 대화 패턴을 Skill로 추출하는 개선 루프입니다.

### 프로세스

```
1. 대화 패턴 관찰
   └─ 동일한 지시를 3회 이상 반복하는가?

2. Skill 후보 식별
   └─ 재사용 가능한 단위로 분리 가능한가?

3. 패턴 선택 (A/B/C)
   └─ 아키텍처 원칙 §4 기준 적용

4. Skill 생성
   └─ frontmatter + 본문 + (리소스)

5. 테스트 검증
   └─ 테스트 계획 수립 → 실행 → 결과 분석 (templates/testing/ 참조)

6. Agent에 매핑
   └─ `skills` frontmatter 필드로 연결

7. 효과 측정
   └─ 트리거 정확도, 실행 성공률
```

### 추출 기준

| 기준 | 임계값 |
|------|--------|
| 반복 빈도 | 동일 패턴 3회 이상 |
| 복잡도 | 3단계 이상의 워크플로우 |
| 재사용성 | 2개 이상 프로젝트에서 활용 가능 |
| 독립성 | 특정 Agent/Team 없이 단독 실행 가능 |

---

## 7. 템플릿 라이프사이클

각 카테고리(agents, skills, teams, docs, conversation)는 동일한 4단계 라이프사이클을 따릅니다.

| 단계 | 디렉토리 | 목적 |
|------|---------|------|
| **Creation** | `templates/creation/` | 새 프롬프트 생성 |
| **Usage** | `templates/usage/` | 생성된 프롬프트 활용/최적화 |
| **Analysis** | `templates/analysis/` | 성능 분석 및 개선 |
| **Testing** | `templates/testing/` | 테스트 계획 수립 및 실행 |

### 흐름

```
Creation → Usage → Analysis → Testing
    ↑                              │
    └──── 개선 후 다시 ────────────┘
```

> 이 루프는 §6 Post-session Skill 추출 루프와 연결됩니다.
