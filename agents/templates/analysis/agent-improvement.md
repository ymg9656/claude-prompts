# Agent 개선 제안 생성

## 사용 시기

- Agent 성능 리뷰나 프롬프트 감사 결과를 바탕으로 구체적인 개선안을 도출할 때
- Agent의 반복적인 실수 패턴을 교정하기 위한 프롬프트 수정안이 필요할 때
- Agent를 새 프로젝트나 작업 유형에 적용하기 위해 조정할 때
- Agent 성능의 점진적 개선(Iterative Improvement) 사이클을 운영할 때

## 프롬프트

다음 프레임워크를 사용하여 Agent 개선 제안을 생성하세요.

---

### 1. 현황 진단

```
## 현재 상태

### Agent 정보
- Agent 이름: {{AGENT_NAME}}
- 현재 역할: {{CURRENT_ROLE}}
- 사용 중인 모델: {{CURRENT_MODEL}}

### 성능 요약
- 종합 등급: {{CURRENT_GRADE}}
- 주요 강점: {{KEY_STRENGTHS}}
- 주요 약점: {{KEY_WEAKNESSES}}

### 문제 증상
{{PROBLEM_SYMPTOMS}}
<!-- Agent의 문제가 어떻게 나타나는지 구체적으로 기술 -->
<!-- 예:
- 코드 리뷰 시 보안 취약점을 50% 이상 놓침
- 리팩토링 결과물에서 기존 테스트가 30% 실패
- 대규모 파일(500줄 이상)에서 맥락을 잃어버림
-->
```

### 2. 원인 분석 및 개선 매핑

```
## 원인-개선 매핑

### 프롬프트 영역 개선
| 문제 | 원인 | 개선 방안 | 우선순위 | 예상 효과 |
|------|------|-----------|----------|-----------|
| {{PROBLEM_1}} | {{CAUSE_1}} | {{SOLUTION_1}} | {{PRIORITY_1}} | {{EXPECTED_EFFECT_1}} |
| {{PROBLEM_2}} | {{CAUSE_2}} | {{SOLUTION_2}} | {{PRIORITY_2}} | {{EXPECTED_EFFECT_2}} |
| {{?PROBLEM_3}} | {{?CAUSE_3}} | {{?SOLUTION_3}} | {{?PRIORITY_3}} | {{?EXPECTED_EFFECT_3}} |

### 컨텍스트 영역 개선
| 부족한 컨텍스트 | 추가할 정보 | 주입 위치 |
|----------------|------------|-----------|
| {{MISSING_CONTEXT_1}} | {{ADDITIONAL_INFO_1}} | {{INJECTION_POINT_1}} |
| {{?MISSING_CONTEXT_2}} | {{?ADDITIONAL_INFO_2}} | {{?INJECTION_POINT_2}} |

### 워크플로우 영역 개선
| 현재 워크플로우 | 문제점 | 개선된 워크플로우 |
|---------------|--------|-----------------|
| {{CURRENT_WORKFLOW_1}} | {{WORKFLOW_ISSUE_1}} | {{IMPROVED_WORKFLOW_1}} |
| {{?CURRENT_WORKFLOW_2}} | {{?WORKFLOW_ISSUE_2}} | {{?IMPROVED_WORKFLOW_2}} |
```

### 3. 구체적 프롬프트 수정안

```
## 프롬프트 수정안

### 수정 1: {{MODIFICATION_1_TITLE}}

#### 현재 (Before)
{{CURRENT_PROMPT_SECTION_1}}

#### 수정 (After)
{{MODIFIED_PROMPT_SECTION_1}}

#### 수정 이유
{{MODIFICATION_1_REASON}}

---

### 수정 2: {{MODIFICATION_2_TITLE}}

#### 현재 (Before)
{{CURRENT_PROMPT_SECTION_2}}

#### 수정 (After)
{{MODIFIED_PROMPT_SECTION_2}}

#### 수정 이유
{{MODIFICATION_2_REASON}}

---

### 수정 3: {{?MODIFICATION_3_TITLE}}

#### 현재 (Before)
{{?CURRENT_PROMPT_SECTION_3}}

#### 수정 (After)
{{?MODIFIED_PROMPT_SECTION_3}}

#### 수정 이유
{{?MODIFICATION_3_REASON}}
```

### 4. 새로운 규칙 추가

```
## 추가할 규칙

### 새로운 MUST 규칙
- {{NEW_MUST_RULE_1}}
- {{?NEW_MUST_RULE_2}}

### 새로운 MUST NOT 규칙
- {{NEW_MUST_NOT_RULE_1}}
- {{?NEW_MUST_NOT_RULE_2}}

### 새로운 판단 기준
- {{?NEW_DECISION_CRITERIA_1}}
- {{?NEW_DECISION_CRITERIA_2}}

### 새로운 에스컬레이션 조건
- {{?NEW_ESCALATION_CONDITION}}
```

### 5. 검증 계획

```
## 개선 검증 계획

### 테스트 시나리오
| 시나리오 | 입력 | 기대 결과 | 이전 결과 |
|---------|------|-----------|-----------|
| {{TEST_SCENARIO_1}} | {{TEST_INPUT_1}} | {{EXPECTED_OUTPUT_1}} | {{PREVIOUS_OUTPUT_1}} |
| {{TEST_SCENARIO_2}} | {{TEST_INPUT_2}} | {{EXPECTED_OUTPUT_2}} | {{PREVIOUS_OUTPUT_2}} |
| {{?TEST_SCENARIO_3}} | {{?TEST_INPUT_3}} | {{?EXPECTED_OUTPUT_3}} | {{?PREVIOUS_OUTPUT_3}} |

### 성공 기준
- {{IMPROVEMENT_CRITERION_1}}
- {{IMPROVEMENT_CRITERION_2}}
- {{?IMPROVEMENT_CRITERION_3}}
<!-- 예: "보안 취약점 식별률 50% → 80% 이상" -->

### A/B 테스트 설계
{{?AB_TEST_DESIGN}}
<!-- 현재 프롬프트 vs 개선된 프롬프트를 동일 작업에 적용하여 비교 -->

### 롤백 기준
{{ROLLBACK_CRITERIA}}
<!-- 개선이 역효과를 낼 경우 이전 버전으로 복원하는 조건 -->
```

### 6. 개선 로드맵

```
## 개선 로드맵

### Phase 1: 즉시 적용 (이번 주)
- {{IMMEDIATE_ACTION_1}}
- {{?IMMEDIATE_ACTION_2}}

### Phase 2: 단기 개선 (2주 내)
- {{SHORT_TERM_ACTION_1}}
- {{?SHORT_TERM_ACTION_2}}

### Phase 3: 중장기 개선 (1개월 내)
- {{?LONG_TERM_ACTION_1}}
- {{?LONG_TERM_ACTION_2}}

### 다음 리뷰 일정
{{NEXT_REVIEW_DATE}}
```

---

위 프레임워크에 따라 실행 가능한 개선 제안서를 작성하세요. 모든 개선안은 Before/After 형태로 구체적 변경사항을 보여주고, 검증 계획과 롤백 기준을 포함해야 합니다.

## 품질 기준

- [ ] 문제-원인-해결 매핑이 논리적으로 연결되었는가?
- [ ] 프롬프트 수정안이 Before/After로 비교 가능한가?
- [ ] 수정 이유가 데이터(성능 리뷰/감사 결과)에 근거하는가?
- [ ] 검증 테스트 시나리오가 충분히 포함되었는가?
- [ ] 개선의 우선순위가 영향도와 긴급도를 고려하여 설정되었는가?
- [ ] 롤백 기준이 명확한가?
- [ ] 개선 로드맵이 현실적인 일정으로 구성되었는가?
- [ ] 점진적 개선 사이클(개선 → 검증 → 리뷰)이 설계되었는가?
