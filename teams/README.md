# teams -- Team 프롬프트

Claude Code Team(멀티 에이전트 팀)을 생성, 운영, 분석하기 위한 프롬프트 템플릿과 예시 모음입니다.

## 핵심 패턴

Team 프롬프트는 **Config -> Leader -> Members -> Workflow -> Communication** 패턴을 따릅니다:

1. **Config** -- `config.json`으로 팀 구성 정의 (이름, 설명, 멤버 목록)
2. **Leader** -- 팀 리더 Agent 설계 (작업 분배, 품질 관리, 최종 통합)
3. **Members** -- 멤버 Agent 설계 (전문 역할, 도구, 제약 조건)
4. **Workflow** -- 작업 흐름 정의 (순차/병렬, 의존성, 마일스톤)
5. **Communication** -- `inboxes/` 기반 메시지 패싱 설계 (구독, 알림, 핸드오프)

## 핵심 구조: config.json

```json
{
  "name": "team-name",
  "description": "팀 설명",
  "createdAt": 1770709790101,
  "leadAgentId": "team-lead@team-name",
  "leadSessionId": "uuid",
  "members": [
    {
      "agentId": "agent-id@team-name",
      "name": "agent-name",
      "agentType": "team-lead | team-member",
      "model": "claude-opus-4-6",
      "joinedAt": 1770709790101,
      "tmuxPaneId": "",
      "cwd": "/path/to/workspace",
      "subscriptions": []
    }
  ]
}
```

## 디렉토리 구조

```
teams/
├── README.md                                    # 이 파일
├── templates/
│   ├── creation/                                # 생성 관련 프롬프트
│   │   ├── team-config.md                       # Team config.json 생성
│   │   ├── team-leader-agent.md                 # 팀 리더 Agent 설계
│   │   └── team-member-agents.md                # 팀 멤버 Agent 일괄 생성
│   ├── usage/                                   # 활용 관련 프롬프트
│   │   ├── team-task-assignment.md              # 작업 분배
│   │   ├── team-workflow-execution.md           # 워크플로우 실행
│   │   └── team-communication.md               # 에이전트 간 통신 설계
│   └── analysis/                                # 분석/개선 프롬프트
│       ├── team-performance-review.md           # 팀 성과 분석
│       ├── team-bottleneck-analysis.md          # 병목 지점 식별
│       └── team-restructuring.md                # 팀 재구성
└── examples/                                    # 실제 사용 예시
    ├── feature-dev-team.md                      # 기능 개발 팀 예시
    ├── code-review-pipeline.md                  # 코드 리뷰 파이프라인 예시
    └── security-audit-team.md                   # 보안 감사 팀 예시
```

## 템플릿 목록

### Creation (생성)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [team-config.md](./templates/creation/team-config.md) | Team config.json 생성 | 팀 구성 파일 초기 설정 |
| [team-leader-agent.md](./templates/creation/team-leader-agent.md) | 팀 리더 Agent 설계 | 리더의 역할/권한/워크플로우 정의 |
| [team-member-agents.md](./templates/creation/team-member-agents.md) | 멤버 Agent 일괄 생성 | 여러 멤버를 한 번에 설계 |

### Usage (활용)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [team-task-assignment.md](./templates/usage/team-task-assignment.md) | 작업 분배 | 팀원에게 효과적으로 작업 할당 |
| [team-workflow-execution.md](./templates/usage/team-workflow-execution.md) | 워크플로우 실행 | 팀 단위 워크플로우 실행 관리 |
| [team-communication.md](./templates/usage/team-communication.md) | 에이전트 간 통신 | inboxes 기반 메시지 패턴 설계 |

### Analysis (분석)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [team-performance-review.md](./templates/analysis/team-performance-review.md) | 성과 분석 | 팀 전체 성과와 개별 기여도 분석 |
| [team-bottleneck-analysis.md](./templates/analysis/team-bottleneck-analysis.md) | 병목 분석 | 워크플로우 병목 지점 식별 및 개선 |
| [team-restructuring.md](./templates/analysis/team-restructuring.md) | 팀 재구성 | 팀 구조 변경 및 역할 재배치 |

## 예시 목록

| 예시 | 설명 |
|------|------|
| [feature-dev-team.md](./examples/feature-dev-team.md) | 기능 개발 팀 (설계-구현-테스트-리뷰 파이프라인) |
| [code-review-pipeline.md](./examples/code-review-pipeline.md) | 코드 리뷰 파이프라인 (다단계 리뷰 체계) |
| [security-audit-team.md](./examples/security-audit-team.md) | 보안 감사 팀 (취약점 탐지-분석-보고) |

## 관련 문서

- [프롬프트 표준 구조](../_common/prompt-structure.md)
- [플레이스홀더 규칙](../_common/placeholders.md)
- [공통 평가 기준](../_common/evaluation-criteria.md)
