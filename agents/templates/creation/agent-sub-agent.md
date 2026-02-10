# Sub-agent 설계

## 사용 시기

- 복잡한 작업을 여러 하위 Agent에게 위임하는 구조를 설계할 때
- Lead Agent와 Sub-agent 간의 역할 분담과 통신 패턴을 정의할 때
- 기존 단일 Agent를 멀티 Agent 구조로 분리할 때
- Team 구성에서 각 멤버 Agent의 역할과 인터페이스를 설계할 때

## 프롬프트

다음 정보를 기반으로 Sub-agent 구성과 위임 패턴을 설계하세요.

---

### 1. 전체 작업 정의

```
## 해결할 문제
{{PROBLEM_DESCRIPTION}}

## 작업 범위
- 입력: {{INPUT_DESCRIPTION}}
- 기대 출력: {{OUTPUT_DESCRIPTION}}
- 제약 조건: {{CONSTRAINTS}}
```

<!-- PROBLEM_DESCRIPTION: Sub-agent 구조가 필요한 복잡한 작업의 전체 설명 -->

### 2. Agent 분해

```
## Lead Agent
- 이름: {{LEAD_AGENT_NAME}}
- 역할: {{LEAD_AGENT_ROLE}}
- 책임: 전체 작업 조율, 결과 통합, 최종 출력 생성

## Sub-agents

### Sub-agent 1: {{SUB_AGENT_1_NAME}}
- 역할: {{SUB_AGENT_1_ROLE}}
- 전문성: {{SUB_AGENT_1_EXPERTISE}}
- 입력: {{SUB_AGENT_1_INPUT}}
- 출력: {{SUB_AGENT_1_OUTPUT}}
- 모델: {{?SUB_AGENT_1_MODEL}}

### Sub-agent 2: {{SUB_AGENT_2_NAME}}
- 역할: {{SUB_AGENT_2_ROLE}}
- 전문성: {{SUB_AGENT_2_EXPERTISE}}
- 입력: {{SUB_AGENT_2_INPUT}}
- 출력: {{SUB_AGENT_2_OUTPUT}}
- 모델: {{?SUB_AGENT_2_MODEL}}

### Sub-agent 3: {{?SUB_AGENT_3_NAME}}
- 역할: {{?SUB_AGENT_3_ROLE}}
- 전문성: {{?SUB_AGENT_3_EXPERTISE}}
- 입력: {{?SUB_AGENT_3_INPUT}}
- 출력: {{?SUB_AGENT_3_OUTPUT}}
- 모델: {{?SUB_AGENT_3_MODEL}}
```

<!-- SUB_AGENT_N_MODEL: 각 Agent에 할당할 모델 (예: claude-sonnet-4-20250514, claude-opus-4-20250115) -->
<!-- 복잡한 추론이 필요하면 Opus, 반복적 작업이면 Sonnet 권장 -->

### 3. 위임 패턴

```
## 위임 방식
{{DELEGATION_PATTERN}}
```

<!-- DELEGATION_PATTERN: 다음 중 선택하거나 조합하세요:
- **Sequential (순차)**: Agent 1 → Agent 2 → Agent 3 (파이프라인)
- **Parallel (병렬)**: Agent 1 & Agent 2를 동시 실행 후 결과 병합
- **Conditional (조건부)**: 조건에 따라 다른 Agent에게 위임
- **Iterative (반복)**: Agent 간 피드백 루프로 결과 개선
-->

```
## 위임 흐름

### 단계별 흐름
1. Lead Agent가 {{STEP_1_ACTION}}
2. {{SUB_AGENT_1_NAME}}에게 {{STEP_2_DELEGATION}}
3. {{SUB_AGENT_2_NAME}}에게 {{STEP_3_DELEGATION}}
4. Lead Agent가 {{STEP_4_INTEGRATION}}

### 에러 처리
- Sub-agent 실패 시: {{ERROR_HANDLING}}
- 타임아웃 시: {{?TIMEOUT_HANDLING}}
- 결과 불일치 시: {{?CONFLICT_RESOLUTION}}
```

### 4. 인터페이스 정의

```
## Agent 간 통신 형식

### Lead → Sub-agent 요청 형식
{{REQUEST_FORMAT}}

### Sub-agent → Lead 응답 형식
{{RESPONSE_FORMAT}}

### 공유 컨텍스트
{{?SHARED_CONTEXT}}
```

<!-- REQUEST_FORMAT 예시:
```json
{
  "task": "코드 리뷰",
  "target": "src/auth/login.ts",
  "focus": ["보안", "에러 처리"],
  "constraints": ["기존 API 계약 유지"]
}
```
-->

### 5. Team config.json 생성

```json
{
  "name": "{{TEAM_NAME}}",
  "description": "{{TEAM_DESCRIPTION}}",
  "leadAgentId": "{{LEAD_AGENT_ID}}",
  "members": [
    {
      "agentId": "{{SUB_AGENT_1_ID}}",
      "name": "{{SUB_AGENT_1_NAME}}",
      "agentType": "{{SUB_AGENT_1_TYPE}}",
      "model": "{{SUB_AGENT_1_MODEL}}"
    },
    {
      "agentId": "{{SUB_AGENT_2_ID}}",
      "name": "{{SUB_AGENT_2_NAME}}",
      "agentType": "{{SUB_AGENT_2_TYPE}}",
      "model": "{{SUB_AGENT_2_MODEL}}"
    }
  ]
}
```

<!-- AGENT_TYPE: "coder", "reviewer", "planner", "researcher" 등 -->
<!-- AGENT_ID: 고유 식별자 (예: "code-reviewer-01") -->

---

위 정보를 바탕으로 각 Sub-agent의 시스템 프롬프트 초안과 전체 위임 흐름도를 작성하세요.

## 품질 기준

- [ ] 각 Sub-agent의 역할이 명확하게 분리되어 겹치지 않는가?
- [ ] 위임 패턴이 작업의 특성에 적합한가? (순차/병렬/조건부/반복)
- [ ] Agent 간 인터페이스(입력/출력 형식)가 구체적으로 정의되었는가?
- [ ] Lead Agent의 조율 책임이 명확한가?
- [ ] 에러 처리 시나리오가 포함되었는가?
- [ ] 각 Sub-agent에 적절한 모델이 할당되었는가? (복잡도 기준)
- [ ] config.json 형식이 팀 구성 표준과 일치하는가?
- [ ] Sub-agent 수가 적절한가? (2~5개 권장, 과도한 분할 지양)
