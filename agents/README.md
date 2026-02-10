# agents — Agent 프롬프트

Claude Code Agent를 생성, 활용, 분석하기 위한 프롬프트 템플릿과 예시 모음입니다.

## 핵심 패턴

Agent 프롬프트는 **Identity → Role → Ownership → Interfaces → Workflow** 패턴을 따릅니다:

1. **Identity** — Agent의 이름과 정체성 선언
2. **Role** — 전문 분야와 책임 범위 정의
3. **Ownership** — 소유하는 코드/영역/산출물 명시
4. **Interfaces** — 다른 Agent/사용자와의 상호작용 인터페이스
5. **Workflow** — 작업 수행 절차와 의사결정 흐름

## 디렉토리 구조

```
agents/
├── README.md                              # 이 파일
├── templates/
│   ├── creation/                           # 생성 관련 프롬프트
│   │   ├── agent-system-prompt.md          # Agent 시스템 프롬프트 생성
│   │   ├── agent-claude-md.md              # CLAUDE.md 파일 생성
│   │   └── agent-sub-agent.md              # Sub-agent 설계
│   ├── usage/                              # 활용 관련 프롬프트
│   │   ├── agent-task-delegation.md        # 작업 위임
│   │   ├── agent-context-injection.md      # 컨텍스트 주입 최적화
│   │   └── agent-workflow-design.md        # 멀티스텝 워크플로우 설계
│   └── analysis/                           # 분석/개선 프롬프트
│       ├── agent-performance-review.md     # 성능 분석 리뷰
│       ├── agent-prompt-audit.md           # 프롬프트 품질 감사
│       └── agent-improvement.md            # 개선 제안 생성
└── examples/                               # 실제 사용 예시
    ├── code-reviewer-agent.md              # 코드 리뷰어 Agent 예시
    ├── debugger-agent.md                   # 디버거 Agent 예시
    └── architect-agent.md                  # 아키텍트 Agent 예시
```

## 템플릿 목록

### Creation (생성)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [agent-system-prompt.md](./templates/creation/agent-system-prompt.md) | Agent 시스템 프롬프트 생성 | 새로운 Agent의 핵심 지시사항 작성 |
| [agent-claude-md.md](./templates/creation/agent-claude-md.md) | CLAUDE.md 파일 생성 | Agent 프로젝트의 컨텍스트 파일 작성 |
| [agent-sub-agent.md](./templates/creation/agent-sub-agent.md) | Sub-agent 설계 | 위임 패턴과 하위 Agent 구성 |

### Usage (활용)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [agent-task-delegation.md](./templates/usage/agent-task-delegation.md) | 작업 위임 | Agent에게 효과적으로 작업 전달 |
| [agent-context-injection.md](./templates/usage/agent-context-injection.md) | 컨텍스트 주입 | Agent 대화에 맥락 정보 최적 전달 |
| [agent-workflow-design.md](./templates/usage/agent-workflow-design.md) | 워크플로우 설계 | 멀티스텝 Agent 파이프라인 구성 |

### Analysis (분석)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [agent-performance-review.md](./templates/analysis/agent-performance-review.md) | 성능 리뷰 | Agent 출력 품질과 성능 분석 |
| [agent-prompt-audit.md](./templates/analysis/agent-prompt-audit.md) | 프롬프트 감사 | Agent 프롬프트 품질 점검 |
| [agent-improvement.md](./templates/analysis/agent-improvement.md) | 개선 제안 | Agent 성능 개선 방향 도출 |

## 예시 목록

| 예시 | 설명 |
|------|------|
| [code-reviewer-agent.md](./examples/code-reviewer-agent.md) | 코드 리뷰 전문 Agent (완성된 시스템 프롬프트) |
| [debugger-agent.md](./examples/debugger-agent.md) | 디버깅 전문 Agent (완성된 시스템 프롬프트) |
| [architect-agent.md](./examples/architect-agent.md) | 소프트웨어 아키텍처 설계 Agent (완성된 시스템 프롬프트) |

## 관련 문서

- [프롬프트 표준 구조](../_common/prompt-structure.md)
- [플레이스홀더 규칙](../_common/placeholders.md)
- [공통 평가 기준](../_common/evaluation-criteria.md)
