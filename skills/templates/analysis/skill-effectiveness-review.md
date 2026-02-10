# Skill 효과성 리뷰 템플릿

## 사용 시기

- 운영 중인 Skill의 실제 효과를 평가하려 할 때
- Skill 도입 전후의 생산성 변화를 측정하려 할 때
- Skill을 유지/개선/폐기할지 결정해야 할 때
- 정기적인 Skill 포트폴리오 점검 시

## 프롬프트

당신은 Claude Code Skill 효과 분석 전문가입니다.
아래 Skill을 다면적으로 분석하여 효과성 리뷰 보고서를 작성하세요.

### 입력 정보

- **Skill 이름**: {{SKILL_NAME}}
- **SKILL.md 내용**: {{SKILL_MD_CONTENT}}
<!-- SKILL.md 전체 내용을 붙여넣으세요 -->
- **운영 기간**: {{OPERATION_PERIOD}}
<!-- 예: "2024-01 ~ 현재 (6개월)" -->
- **사용 빈도**: {{USAGE_FREQUENCY}}
<!-- 예: "주 15회", "일 3회" -->
- **대상 사용자**: {{TARGET_USERS}}
<!-- 예: "백엔드 개발팀 5명" -->
- **Skill 도입 전 작업 방식**: {{BEFORE_WORKFLOW}}
<!-- Skill 없이 동일 작업을 어떻게 수행했는지 -->
- **관찰된 문제점**: {{?OBSERVED_PROBLEMS}}
<!-- 사용 중 발견된 문제나 불편사항 -->
- **사용자 피드백**: {{?USER_FEEDBACK}}

### 분석 규칙

다음 5개 차원에서 평가하세요:

1. **기능 완전성**: Skill이 의도한 기능을 모두 수행하는가?
2. **정확성**: 결과물의 품질이 일관되고 정확한가?
3. **효율성**: 시간/노력을 얼마나 절약하는가?
4. **사용성**: 트리거가 자연스럽고 워크플로우가 직관적인가?
5. **유지보수성**: Skill이 쉽게 업데이트/확장 가능한가?

각 차원에 1-5점으로 점수를 부여하고 근거를 명시하세요.

### 출력 형식

```markdown
## Skill 효과성 리뷰: {{SKILL_NAME}}

### 요약

| 항목 | 내용 |
|------|------|
| Skill 이름 | {{SKILL_NAME}} |
| 리뷰 일자 | {{REVIEW_DATE}} |
| 운영 기간 | {{OPERATION_PERIOD}} |
| 종합 점수 | {{TOTAL_SCORE}}/25 |
| 권고 사항 | {{RECOMMENDATION}} |
<!-- 유지, 개선 필요, 대폭 수정, 폐기 중 선택 -->

### 차원별 평가

#### 1. 기능 완전성 ({{SCORE_1}}/5)

**평가**: {{COMPLETENESS_ASSESSMENT}}

- 구현된 기능: {{IMPLEMENTED_FEATURES}}
- 누락된 기능: {{MISSING_FEATURES}}
- 불필요한 기능: {{UNNECESSARY_FEATURES}}

#### 2. 정확성 ({{SCORE_2}}/5)

**평가**: {{ACCURACY_ASSESSMENT}}

- 정확한 결과 비율: {{ACCURACY_RATE}}%
- 자주 발생하는 오류: {{COMMON_ERRORS}}
- 오류 원인 분석: {{ERROR_CAUSES}}

#### 3. 효율성 ({{SCORE_3}}/5)

**평가**: {{EFFICIENCY_ASSESSMENT}}

| 지표 | Skill 도입 전 | Skill 도입 후 | 개선율 |
|------|-------------|-------------|--------|
| 작업 소요 시간 | {{BEFORE_TIME}} | {{AFTER_TIME}} | {{TIME_IMPROVEMENT}}% |
| 수동 단계 수 | {{BEFORE_STEPS}} | {{AFTER_STEPS}} | {{STEP_IMPROVEMENT}}% |
| 오류 발생률 | {{BEFORE_ERROR_RATE}} | {{AFTER_ERROR_RATE}} | {{ERROR_IMPROVEMENT}}% |

#### 4. 사용성 ({{SCORE_4}}/5)

**평가**: {{USABILITY_ASSESSMENT}}

- 트리거 인식률: {{TRIGGER_RECOGNITION_RATE}}%
- 학습 곡선: {{LEARNING_CURVE}}
- 사용자 만족도: {{USER_SATISFACTION}}

#### 5. 유지보수성 ({{SCORE_5}}/5)

**평가**: {{MAINTAINABILITY_ASSESSMENT}}

- 코드/문서 복잡도: {{COMPLEXITY}}
- 외부 의존성: {{DEPENDENCIES}}
- 마지막 업데이트: {{LAST_UPDATE}}

### 개선 권고 사항

#### 즉시 개선 (Critical)
1. {{CRITICAL_IMPROVEMENT_1}}
2. {{?CRITICAL_IMPROVEMENT_2}}

#### 단기 개선 (1~2주)
1. {{SHORT_TERM_1}}
2. {{?SHORT_TERM_2}}

#### 장기 개선 (1개월+)
1. {{LONG_TERM_1}}
2. {{?LONG_TERM_2}}

### 결론

{{CONCLUSION}}
```

## 품질 기준

- [ ] 5개 차원 모두에 대해 점수와 근거가 제시되었는가?
- [ ] 정량적 데이터(비율, 시간, 횟수)가 포함되었는가?
- [ ] 도입 전후 비교가 구체적인가?
- [ ] 개선 권고가 우선순위별로 구분되었는가?
- [ ] 권고 사항이 실행 가능하고 구체적인가?
- [ ] 결론이 데이터에 기반한 객관적 판단인가?
