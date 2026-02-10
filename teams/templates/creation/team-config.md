# Team config.json 생성

## 사용 시기

- 새로운 멀티 에이전트 팀을 처음 구성할 때
- 기존 팀의 config.json을 표준 형식으로 재작성할 때
- 프로젝트 요구사항에 맞춰 팀 구성을 설계할 때

## 프롬프트

당신은 Claude Code 멀티 에이전트 팀 아키텍트입니다.

주어진 프로젝트 요구사항을 기반으로 팀의 `config.json` 파일을 생성하세요.

### 프로젝트 정보

- **프로젝트명**: {{PROJECT_NAME}}
- **프로젝트 경로**: {{PROJECT_PATH}}
- **기술 스택**: {{TECH_STACK}}
- **프로젝트 설명**: {{PROJECT_DESCRIPTION}}

### 팀 요구사항

- **팀 이름**: {{TEAM_NAME}}
<!-- 케밥 케이스로 작성 (예: feature-dev-team) -->
- **팀 목적**: {{TEAM_PURPOSE}}
<!-- 이 팀이 해결해야 하는 핵심 문제 또는 목표 -->
- **필요한 역할 목록**: {{LIST_REQUIRED_ROLES}}
<!-- 예: 리더, 백엔드 개발자, 프론트엔드 개발자, 테스터, 리뷰어 -->
- **작업 방식**: {{WORKFLOW_TYPE}}
<!-- 순차적(sequential) / 병렬(parallel) / 혼합(hybrid) -->
- **사용 모델**: {{?MODEL_NAME}}
<!-- 기본값: claude-opus-4-6 -->

### 생성 규칙

1. `name` 필드는 케밥 케이스로 작성
2. `leadAgentId` 형식: `team-lead@{team-name}`
3. 멤버의 `agentId` 형식: `{role-name}@{team-name}`
4. `agentType`은 리더는 `"team-lead"`, 나머지는 `"team-member"`
5. `subscriptions`는 해당 Agent가 메시지를 수신해야 하는 다른 Agent의 agentId 목록
6. `cwd`는 모든 멤버가 동일한 프로젝트 경로를 사용
7. `tmuxPaneId`는 빈 문자열로 초기화 (런타임에 할당됨)

### 출력 형식

다음 형식으로 완전한 `config.json`을 생성하세요:

```json
{
  "name": "{{TEAM_NAME}}",
  "description": "팀 설명",
  "createdAt": <현재 타임스탬프>,
  "leadAgentId": "team-lead@{{TEAM_NAME}}",
  "leadSessionId": "<생성할 UUID>",
  "members": [
    {
      "agentId": "team-lead@{{TEAM_NAME}}",
      "name": "team-lead",
      "agentType": "team-lead",
      "model": "{{?MODEL_NAME}}",
      "joinedAt": <현재 타임스탬프>,
      "tmuxPaneId": "",
      "cwd": "{{PROJECT_PATH}}",
      "subscriptions": ["모든 멤버의 agentId"]
    },
    {
      "agentId": "<role>@{{TEAM_NAME}}",
      "name": "<role>",
      "agentType": "team-member",
      "model": "{{?MODEL_NAME}}",
      "joinedAt": <현재 타임스탬프>,
      "tmuxPaneId": "",
      "cwd": "{{PROJECT_PATH}}",
      "subscriptions": ["team-lead@{{TEAM_NAME}}"]
    }
  ]
}
```

추가로 각 멤버의 역할 요약 테이블을 함께 출력하세요:

| agentId | 역할 | 핵심 책임 | 구독 대상 |
|---------|------|----------|----------|
| ... | ... | ... | ... |

## 품질 기준

- [ ] config.json이 유효한 JSON 형식인가?
- [ ] 모든 agentId가 `{role}@{team-name}` 패턴을 따르는가?
- [ ] leadAgentId가 members 배열의 team-lead와 일치하는가?
- [ ] 모든 멤버의 cwd가 올바른 프로젝트 경로인가?
- [ ] subscriptions가 실제 존재하는 agentId만 참조하는가?
- [ ] 리더의 subscriptions에 모든 멤버가 포함되어 있는가?
- [ ] 역할 간 중복 없이 책임이 명확히 분리되어 있는가?
