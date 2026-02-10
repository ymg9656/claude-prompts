# Claude Prompts

Claude Code에서 사용하는 프롬프트(Agent, Skill, Team, 문서, 대화)를 체계적으로 관리하는 템플릿/예시 저장소입니다.

## 구조

```
claude-prompts/
├── _common/          공통 패턴 (프롬프트 구조, 플레이스홀더, 평가 기준)
├── agents/           Agent 프롬프트 (시스템 프롬프트, CLAUDE.md, Sub-agent)
├── skills/           Skill 프롬프트 (SKILL.md, 스크립트, 레퍼런스)
├── teams/            Team 프롬프트 (config.json, 리더/멤버 Agent)
├── docs/             문서 생성/리뷰 프롬프트
└── conversation/     일반 대화 프롬프트 (시스템 프롬프트, CoT, Few-shot)
```

## 카테고리별 안내

### [_common/](./_common/) — 공통 패턴

| 파일 | 설명 |
|------|------|
| [prompt-structure.md](./_common/prompt-structure.md) | 5단계 프롬프트 표준 구조 (Identity → Context → Task → Examples → Quality) |
| [placeholders.md](./_common/placeholders.md) | 플레이스홀더 규칙 (`{{REQUIRED}}`, `{{?OPTIONAL}}`) |
| [evaluation-criteria.md](./_common/evaluation-criteria.md) | 공통 평가 기준 체크리스트 |

### [agents/](./agents/) — Agent 프롬프트

| 분류 | 템플릿 | 설명 |
|------|--------|------|
| 생성 | [agent-system-prompt.md](./agents/templates/creation/agent-system-prompt.md) | Agent 시스템 프롬프트 생성 |
| 생성 | [agent-claude-md.md](./agents/templates/creation/agent-claude-md.md) | CLAUDE.md 파일 생성 |
| 생성 | [agent-sub-agent.md](./agents/templates/creation/agent-sub-agent.md) | Sub-agent 설정 생성 |
| 활용 | [agent-task-delegation.md](./agents/templates/usage/agent-task-delegation.md) | 작업 위임 |
| 활용 | [agent-context-injection.md](./agents/templates/usage/agent-context-injection.md) | 컨텍스트 최적화 |
| 활용 | [agent-workflow-design.md](./agents/templates/usage/agent-workflow-design.md) | 워크플로우 설계 |
| 분석 | [agent-performance-review.md](./agents/templates/analysis/agent-performance-review.md) | 성능 분석 |
| 분석 | [agent-prompt-audit.md](./agents/templates/analysis/agent-prompt-audit.md) | 프롬프트 품질 감사 |
| 분석 | [agent-improvement.md](./agents/templates/analysis/agent-improvement.md) | 개선 제안 |

**예시:** [code-reviewer](./agents/examples/code-reviewer-agent.md) · [debugger](./agents/examples/debugger-agent.md) · [architect](./agents/examples/architect-agent.md)

### [skills/](./skills/) — Skill 프롬프트

| 분류 | 템플릿 | 설명 |
|------|--------|------|
| 생성 | [skill-md.md](./skills/templates/creation/skill-md.md) | SKILL.md 생성 |
| 생성 | [skill-with-scripts.md](./skills/templates/creation/skill-with-scripts.md) | 스크립트 포함 Skill |
| 생성 | [skill-with-references.md](./skills/templates/creation/skill-with-references.md) | 레퍼런스 포함 Skill |
| 활용 | [skill-trigger-optimization.md](./skills/templates/usage/skill-trigger-optimization.md) | 트리거 최적화 |
| 활용 | [skill-composition.md](./skills/templates/usage/skill-composition.md) | Skill 조합 활용 |
| 활용 | [skill-context-management.md](./skills/templates/usage/skill-context-management.md) | 컨텍스트 관리 |
| 분석 | [skill-effectiveness-review.md](./skills/templates/analysis/skill-effectiveness-review.md) | 효과성 분석 |
| 분석 | [skill-trigger-audit.md](./skills/templates/analysis/skill-trigger-audit.md) | 트리거 교차 감사 |
| 분석 | [skill-improvement.md](./skills/templates/analysis/skill-improvement.md) | 개선 제안 |

**예시:** [git-commit-skill](./skills/examples/git-commit-skill/) · [test-runner-skill](./skills/examples/test-runner-skill/) · [api-generator-skill](./skills/examples/api-generator-skill/)

### [teams/](./teams/) — Team 프롬프트

| 분류 | 템플릿 | 설명 |
|------|--------|------|
| 생성 | [team-config.md](./teams/templates/creation/team-config.md) | config.json 생성 |
| 생성 | [team-leader-agent.md](./teams/templates/creation/team-leader-agent.md) | 리더 Agent 생성 |
| 생성 | [team-member-agents.md](./teams/templates/creation/team-member-agents.md) | 멤버 Agent 일괄 생성 |
| 활용 | [team-task-assignment.md](./teams/templates/usage/team-task-assignment.md) | 작업 배분 |
| 활용 | [team-workflow-execution.md](./teams/templates/usage/team-workflow-execution.md) | 워크플로우 실행 |
| 활용 | [team-communication.md](./teams/templates/usage/team-communication.md) | 커뮤니케이션 설계 |
| 분석 | [team-performance-review.md](./teams/templates/analysis/team-performance-review.md) | 성과 분석 |
| 분석 | [team-bottleneck-analysis.md](./teams/templates/analysis/team-bottleneck-analysis.md) | 병목 분석 |
| 분석 | [team-restructuring.md](./teams/templates/analysis/team-restructuring.md) | 구조 개선 |

**예시:** [feature-dev-team](./teams/examples/feature-dev-team.md) · [code-review-pipeline](./teams/examples/code-review-pipeline.md) · [security-audit-team](./teams/examples/security-audit-team.md)

### [docs/](./docs/) — 문서 프롬프트

| 분류 | 템플릿 | 설명 |
|------|--------|------|
| 생성 | [doc-technical-spec.md](./docs/templates/creation/doc-technical-spec.md) | 기술 스펙 생성 |
| 생성 | [doc-api-reference.md](./docs/templates/creation/doc-api-reference.md) | API 레퍼런스 생성 |
| 생성 | [doc-user-guide.md](./docs/templates/creation/doc-user-guide.md) | 사용자 가이드 생성 |
| 활용 | [doc-review-request.md](./docs/templates/usage/doc-review-request.md) | 문서 리뷰 요청 |
| 활용 | [doc-translation.md](./docs/templates/usage/doc-translation.md) | 한/영 번역 |
| 활용 | [doc-summarization.md](./docs/templates/usage/doc-summarization.md) | 문서 요약 |
| 분석 | [doc-quality-review.md](./docs/templates/analysis/doc-quality-review.md) | 품질 분석 |
| 분석 | [doc-completeness-check.md](./docs/templates/analysis/doc-completeness-check.md) | 완성도 점검 |
| 분석 | [doc-consistency-audit.md](./docs/templates/analysis/doc-consistency-audit.md) | 일관성 감사 |

**예시:** [api-doc](./docs/examples/api-doc-example.md) · [architecture-doc](./docs/examples/architecture-doc-example.md) · [onboarding-guide](./docs/examples/onboarding-guide-example.md)

### [conversation/](./conversation/) — 일반 대화 프롬프트

| 분류 | 템플릿 | 설명 |
|------|--------|------|
| 생성 | [conv-system-prompt.md](./conversation/templates/creation/conv-system-prompt.md) | 시스템 프롬프트 생성 |
| 생성 | [conv-persona-design.md](./conversation/templates/creation/conv-persona-design.md) | 페르소나 설계 |
| 생성 | [conv-few-shot-builder.md](./conversation/templates/creation/conv-few-shot-builder.md) | Few-shot 예시 구성 |
| 활용 | [conv-chain-of-thought.md](./conversation/templates/usage/conv-chain-of-thought.md) | CoT 유도 |
| 활용 | [conv-structured-output.md](./conversation/templates/usage/conv-structured-output.md) | 구조화된 출력 |
| 활용 | [conv-iterative-refinement.md](./conversation/templates/usage/conv-iterative-refinement.md) | 반복적 개선 |
| 분석 | [conv-prompt-evaluation.md](./conversation/templates/analysis/conv-prompt-evaluation.md) | 프롬프트 효과성 평가 |
| 분석 | [conv-response-analysis.md](./conversation/templates/analysis/conv-response-analysis.md) | 응답 품질 분석 |
| 분석 | [conv-optimization.md](./conversation/templates/analysis/conv-optimization.md) | 프롬프트 최적화 |

**예시:** [code-review-conversation](./conversation/examples/code-review-conversation.md) · [brainstorming-session](./conversation/examples/brainstorming-session.md) · [technical-interview](./conversation/examples/technical-interview.md)

---

## 템플릿 사용법

### 1. 템플릿 선택
각 템플릿의 `## 사용 시기` 섹션을 확인하여 상황에 맞는 템플릿을 선택합니다.

### 2. 플레이스홀더 채우기
```
{{REQUIRED_FIELD}}   → 필수: 반드시 채워야 함
{{?OPTIONAL_FIELD}}  → 선택: 생략 가능 (해당 섹션 삭제)
<!-- 설명 -->         → 가이드: 채운 후 삭제
```

### 3. 품질 검증
`## 품질 기준` 체크리스트로 결과물을 검증합니다.

## 설계 원칙

- **실제 패턴 반영**: `~/.claude/skills/`, `~/.claude/teams/`의 실제 구조를 기반으로 설계
- **3-파트 구조 통일**: 사용 시기 → 프롬프트 → 품질 기준
- **생성/활용/분석 분류**: 각 카테고리의 라이프사이클을 커버
- **한국어 콘텐츠 + 영어 식별자**: 내용은 한국어, 파일명/플레이스홀더는 영어
