# Agent 성능 리뷰

## 사용 시기

- Agent의 출력 품질을 체계적으로 평가하고 싶을 때
- Agent가 기대한 결과를 내지 못할 때 원인을 분석하고 싶을 때
- Agent 간 성능을 비교하거나 벤치마크를 수립할 때
- Agent 운영 주기적 리뷰에서 정량적 평가가 필요할 때

## 프롬프트

다음 프레임워크를 사용하여 Agent의 성능을 리뷰하세요.

---

### 1. 리뷰 대상 정보

```
## 리뷰 대상

### Agent 정보
- Agent 이름: {{AGENT_NAME}}
- Agent 역할: {{AGENT_ROLE}}
- 사용 모델: {{AGENT_MODEL}}
- 운영 기간: {{?OPERATION_PERIOD}}

### 리뷰 범위
- 평가 기간: {{REVIEW_PERIOD}}
- 평가 작업 수: {{TASK_COUNT}}
- 작업 유형: {{TASK_TYPES}}
```

### 2. 정량 평가

```
## 정량 지표

### 완료율
- 성공적으로 완료한 작업: {{COMPLETED_TASKS}} / {{TOTAL_TASKS}}
- 부분 완료 (수동 보완 필요): {{PARTIAL_TASKS}}
- 실패 (재작업 필요): {{FAILED_TASKS}}

### 품질 지표
| 지표 | 측정값 | 목표값 | 달성 여부 |
|------|--------|--------|-----------|
| 정확도 | {{ACCURACY}} | {{ACCURACY_TARGET}} | {{ACCURACY_MET}} |
| 완전성 | {{COMPLETENESS}} | {{COMPLETENESS_TARGET}} | {{COMPLETENESS_MET}} |
| 일관성 | {{CONSISTENCY}} | {{CONSISTENCY_TARGET}} | {{CONSISTENCY_MET}} |
| {{?CUSTOM_METRIC_1}} | {{?CUSTOM_VALUE_1}} | {{?CUSTOM_TARGET_1}} | {{?CUSTOM_MET_1}} |

### 효율성 지표
- 평균 작업 시간: {{AVG_TASK_TIME}}
- 평균 토큰 사용량: {{?AVG_TOKEN_USAGE}}
- 도구 호출 횟수 (평균): {{?AVG_TOOL_CALLS}}
- 반복/재시도 비율: {{?RETRY_RATE}}
```

### 3. 정성 평가

```
## 정성 분석

### 강점 분석
{{STRENGTHS}}
<!-- 최소 2개 이상의 구체적 강점을 예시와 함께 기술 -->
<!-- 예:
1. **에러 패턴 인식력 우수**: NullPointerException 관련 이슈를 95% 정확도로 식별
   - 사례: PR #142에서 잠재적 NPE를 3건 발견 (모두 실제 버그)
2. **코딩 컨벤션 준수**: 프로젝트 스타일 가이드를 일관되게 적용
-->

### 약점 분석
{{WEAKNESSES}}
<!-- 최소 2개 이상의 구체적 약점을 예시와 함께 기술 -->
<!-- 예:
1. **대규모 리팩토링 시 맥락 손실**: 10개 이상 파일 변경 시 일관성 저하
   - 사례: 인증 모듈 리팩토링에서 3개 파일의 import 업데이트 누락
2. **비즈니스 로직 이해 부족**: 도메인 특화 규칙을 놓치는 경우 발생
-->

### 대표 사례 분석

#### 성공 사례
- 작업: {{SUCCESS_CASE_TASK}}
- 상황: {{SUCCESS_CASE_CONTEXT}}
- 결과: {{SUCCESS_CASE_RESULT}}
- 성공 요인: {{SUCCESS_CASE_FACTOR}}

#### 실패 사례
- 작업: {{FAILURE_CASE_TASK}}
- 상황: {{FAILURE_CASE_CONTEXT}}
- 결과: {{FAILURE_CASE_RESULT}}
- 실패 원인: {{FAILURE_CASE_REASON}}
- 재발 방지: {{FAILURE_CASE_PREVENTION}}
```

### 4. 근본 원인 분석

```
## 문제 근본 원인

### 프롬프트 관련
{{?PROMPT_ISSUES}}
<!-- 시스템 프롬프트의 모호성, 누락된 지침, 상충되는 규칙 등 -->

### 컨텍스트 관련
{{?CONTEXT_ISSUES}}
<!-- 불충분한 프로젝트 정보, 오래된 CLAUDE.md, 누락된 코딩 컨벤션 등 -->

### 도구 관련
{{?TOOL_ISSUES}}
<!-- 도구 사용 규칙 미비, 부적절한 도구 선택, 도구 제한 사항 등 -->

### 모델 관련
{{?MODEL_ISSUES}}
<!-- 모델의 고유 한계, 할루시네이션 패턴, 토큰 제한 등 -->
```

### 5. 종합 평가

```
## 종합 평가

### 등급: {{OVERALL_GRADE}}
<!-- A (탁월) / B (양호) / C (보통) / D (미흡) / F (부적합) -->

### 평가 요약
{{EVALUATION_SUMMARY}}
<!-- 3~5문장으로 전체 평가를 요약 -->

### 우선 개선 사항
1. {{IMPROVEMENT_1}}
2. {{IMPROVEMENT_2}}
3. {{?IMPROVEMENT_3}}
```

---

위 프레임워크에 따라 체계적인 성능 리뷰를 작성하세요. 정량 데이터와 정성 분석을 균형 있게 포함하고, 실행 가능한 개선 사항을 도출하세요.

## 품질 기준

- [ ] 정량 지표와 정성 분석이 모두 포함되었는가?
- [ ] 강점과 약점이 구체적 사례와 함께 기술되었는가?
- [ ] 실패 사례의 근본 원인이 분석되었는가?
- [ ] 개선 사항이 실행 가능하고 구체적인가?
- [ ] 평가가 객관적이고 편향되지 않았는가?
- [ ] 종합 등급이 세부 평가와 일관되는가?
- [ ] 다음 리뷰 주기까지의 액션 아이템이 명확한가?
