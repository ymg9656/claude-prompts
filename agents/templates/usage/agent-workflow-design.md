# Agent 워크플로우 설계

## 사용 시기

- 여러 단계로 구성된 복잡한 작업의 Agent 수행 절차를 설계할 때
- 반복 가능하고 일관된 Agent 작업 파이프라인이 필요할 때
- 조건 분기, 반복, 병렬 처리가 포함된 고급 워크플로우를 설계할 때
- Skill의 워크플로우 단계를 정의할 때

## 프롬프트

다음 프레임워크를 사용하여 Agent 워크플로우를 설계하세요.

---

### 1. 워크플로우 개요

```
## 워크플로우 정의

### 이름
{{WORKFLOW_NAME}}

### 목적
{{WORKFLOW_PURPOSE}}
<!-- 이 워크플로우가 해결하는 문제를 1~2문장으로 설명 -->

### 트리거
{{WORKFLOW_TRIGGER}}
<!-- 워크플로우가 시작되는 조건 (예: "PR이 생성되었을 때", "/review 명령 실행 시") -->

### 입력
- {{INPUT_1}}: {{INPUT_1_DESCRIPTION}}
- {{INPUT_2}}: {{INPUT_2_DESCRIPTION}}
- {{?INPUT_3}}: {{?INPUT_3_DESCRIPTION}}

### 최종 출력
{{FINAL_OUTPUT_DESCRIPTION}}
```

### 2. 단계 정의

```
## 워크플로우 단계

### Step 1: {{STEP_1_NAME}}
- 설명: {{STEP_1_DESCRIPTION}}
- 수행자: {{STEP_1_AGENT}}
- 입력: {{STEP_1_INPUT}}
- 도구: {{STEP_1_TOOLS}}
- 출력: {{STEP_1_OUTPUT}}
- 성공 조건: {{STEP_1_SUCCESS_CRITERIA}}
- 실패 시: {{STEP_1_ON_FAILURE}}

### Step 2: {{STEP_2_NAME}}
- 설명: {{STEP_2_DESCRIPTION}}
- 수행자: {{STEP_2_AGENT}}
- 입력: {{STEP_2_INPUT}} <!-- 이전 단계 출력 참조 가능 -->
- 도구: {{STEP_2_TOOLS}}
- 출력: {{STEP_2_OUTPUT}}
- 성공 조건: {{STEP_2_SUCCESS_CRITERIA}}
- 실패 시: {{STEP_2_ON_FAILURE}}

### Step 3: {{STEP_3_NAME}}
- 설명: {{STEP_3_DESCRIPTION}}
- 수행자: {{STEP_3_AGENT}}
- 입력: {{STEP_3_INPUT}}
- 도구: {{STEP_3_TOOLS}}
- 출력: {{STEP_3_OUTPUT}}
- 성공 조건: {{STEP_3_SUCCESS_CRITERIA}}
- 실패 시: {{STEP_3_ON_FAILURE}}

{{?STEP_4}}
{{?STEP_5}}
```

### 3. 흐름 제어

```
## 흐름 제어 패턴

### 조건 분기
{{?CONDITION_BRANCH}}
<!-- 예:
if (Step 1 결과 == "보안 이슈 발견"):
    → Step 2a: 보안 심층 분석
else:
    → Step 2b: 일반 코드 리뷰
-->

### 반복 (Loop)
{{?LOOP_DEFINITION}}
<!-- 예:
while (테스트 실패):
    → Step 3: 코드 수정
    → Step 4: 테스트 재실행
    max_iterations: 3
-->

### 병렬 실행
{{?PARALLEL_STEPS}}
<!-- 예:
parallel:
    - Step 2a: 코드 스타일 검사
    - Step 2b: 보안 취약점 검사
    - Step 2c: 성능 분석
join → Step 3: 결과 통합
-->

### 롤백
{{?ROLLBACK_STRATEGY}}
<!-- 중간 단계에서 실패 시 이전 상태로 복원하는 전략 -->
```

### 4. 데이터 흐름

```
## 단계 간 데이터 전달

### 데이터 흐름도
{{DATA_FLOW_DIAGRAM}}
<!-- 각 단계의 입출력이 어떻게 연결되는지 도식화 -->
<!-- 예:
[입력] → Step 1 → {분석 결과} → Step 2 → {수정 코드} → Step 3 → [최종 출력]
                                    ↑                          |
                                    └──── 피드백 루프 ──────────┘
-->

### 공유 상태
{{?SHARED_STATE}}
<!-- 여러 단계에서 공유하는 데이터나 상태 -->
```

### 5. 에러 처리 및 복구

```
## 에러 처리

### 단계별 실패 처리
| 단계 | 예상 실패 | 복구 전략 |
|------|-----------|-----------|
| {{STEP_1_NAME}} | {{STEP_1_FAILURE}} | {{STEP_1_RECOVERY}} |
| {{STEP_2_NAME}} | {{STEP_2_FAILURE}} | {{STEP_2_RECOVERY}} |
| {{STEP_3_NAME}} | {{STEP_3_FAILURE}} | {{STEP_3_RECOVERY}} |

### 전체 워크플로우 타임아웃
{{?WORKFLOW_TIMEOUT}}

### 에스컬레이션
{{ESCALATION_RULE}}
<!-- 자동 복구 실패 시 사용자에게 알리는 조건과 방법 -->
```

### 6. Skill YAML 매핑

```yaml
# SKILL.md frontmatter 예시
---
name: {{WORKFLOW_NAME}}
description: {{WORKFLOW_PURPOSE}}
triggers:
  - {{WORKFLOW_TRIGGER}}
steps:
  - name: {{STEP_1_NAME}}
    tool: {{STEP_1_TOOLS}}
  - name: {{STEP_2_NAME}}
    tool: {{STEP_2_TOOLS}}
  - name: {{STEP_3_NAME}}
    tool: {{STEP_3_TOOLS}}
---
```

<!-- Skill 형식으로 변환할 경우 YAML frontmatter에 워크플로우 정보를 매핑 -->

---

위 정보를 바탕으로 완전한 워크플로우 명세서를 작성하세요. 각 단계가 독립적으로 테스트 가능하고, 실패 시 복구 경로가 명확해야 합니다.

## 품질 기준

- [ ] 모든 단계에 입력/출력/성공 조건/실패 처리가 정의되었는가?
- [ ] 단계 간 데이터 흐름이 명확하게 연결되었는가?
- [ ] 조건 분기/반복/병렬 패턴이 적절하게 사용되었는가?
- [ ] 에러 처리 및 복구 전략이 각 단계별로 존재하는가?
- [ ] 전체 워크플로우의 시작 조건(트리거)과 종료 조건이 명확한가?
- [ ] 각 단계가 독립적으로 테스트 가능한 단위인가?
- [ ] 에스컬레이션 규칙이 정의되어 있는가?
- [ ] Skill YAML로의 매핑이 가능한가?
