# Agent 프롬프트 감사

## 사용 시기

- Agent 시스템 프롬프트의 품질을 체계적으로 점검하고 싶을 때
- Agent가 예상과 다르게 동작하여 프롬프트 원인을 찾아야 할 때
- 새로 작성한 프롬프트를 배포 전에 검증할 때
- 정기적인 프롬프트 품질 관리 프로세스를 수행할 때

## 프롬프트

다음 감사 프레임워크를 사용하여 Agent 프롬프트를 분석하세요.

---

### 1. 감사 대상

```
## 감사 대상 프롬프트

### Agent 정보
- Agent 이름: {{AGENT_NAME}}
- Agent 용도: {{AGENT_PURPOSE}}
- 프롬프트 버전: {{?PROMPT_VERSION}}
- 마지막 수정일: {{?LAST_MODIFIED}}

### 프롬프트 전문
{{FULL_PROMPT_TEXT}}
<!-- 감사할 시스템 프롬프트 전문을 여기에 붙여넣으세요 -->
```

### 2. 구조 감사

```
## 구조 분석

### 필수 섹션 점검
| 섹션 | 존재 여부 | 품질 등급 | 비고 |
|------|-----------|-----------|------|
| Identity (정체성) | {{HAS_IDENTITY}} | {{IDENTITY_GRADE}} | {{?IDENTITY_NOTE}} |
| Role (역할) | {{HAS_ROLE}} | {{ROLE_GRADE}} | {{?ROLE_NOTE}} |
| Constraints (제약) | {{HAS_CONSTRAINTS}} | {{CONSTRAINTS_GRADE}} | {{?CONSTRAINTS_NOTE}} |
| Tools (도구) | {{HAS_TOOLS}} | {{TOOLS_GRADE}} | {{?TOOLS_NOTE}} |
| Workflow (워크플로우) | {{HAS_WORKFLOW}} | {{WORKFLOW_GRADE}} | {{?WORKFLOW_NOTE}} |

### 구조적 문제
{{STRUCTURAL_ISSUES}}
<!-- 섹션 누락, 순서 오류, 중복 등 구조적 문제를 나열 -->
```

### 3. 명확성 감사

```
## 명확성 분석

### 모호한 표현 식별
| 위치 | 모호한 표현 | 문제점 | 개선 제안 |
|------|------------|--------|-----------|
| {{LOCATION_1}} | {{AMBIGUOUS_1}} | {{PROBLEM_1}} | {{SUGGESTION_1}} |
| {{?LOCATION_2}} | {{?AMBIGUOUS_2}} | {{?PROBLEM_2}} | {{?SUGGESTION_2}} |
| {{?LOCATION_3}} | {{?AMBIGUOUS_3}} | {{?PROBLEM_3}} | {{?SUGGESTION_3}} |

### 상충되는 지시사항
{{CONFLICTING_INSTRUCTIONS}}
<!-- 서로 모순되는 규칙이 있다면 명시 -->
<!-- 예: "모든 코드를 수정하세요" vs "기존 API를 변경하지 마세요" -->

### 암묵적 가정
{{IMPLICIT_ASSUMPTIONS}}
<!-- 명시되지 않았지만 Agent가 알아야 하는 전제 조건 -->
<!-- 예: 특정 환경 변수의 존재를 가정, 특정 디렉토리 구조를 가정 -->
```

### 4. 완전성 감사

```
## 완전성 분석

### 누락된 지침 점검
- [ ] 에러 발생 시 행동 지침: {{ERROR_HANDLING_STATUS}}
- [ ] 모호한 상황에서의 판단 기준: {{AMBIGUITY_HANDLING_STATUS}}
- [ ] 범위 밖 요청에 대한 대응: {{OUT_OF_SCOPE_STATUS}}
- [ ] 도구 사용 실패 시 대안: {{TOOL_FAILURE_STATUS}}
- [ ] 출력 형식 명세: {{OUTPUT_FORMAT_STATUS}}
- [ ] 에스컬레이션 조건: {{ESCALATION_STATUS}}

### 엣지 케이스 점검
{{EDGE_CASES}}
<!-- Agent가 마주칠 수 있는 예외적 상황과 그에 대한 지침 유무 -->
<!-- 예:
- 빈 파일이 입력되면? → 지침 없음 (추가 필요)
- 바이너리 파일이 포함되면? → "텍스트 파일만 처리" 규칙 존재
- 권한이 없는 파일에 접근하면? → 지침 없음 (추가 필요)
-->
```

### 5. 효율성 감사

```
## 효율성 분석

### 토큰 효율성
- 전체 토큰 수 (추정): {{ESTIMATED_TOKENS}}
- 중복/불필요한 부분: {{REDUNDANT_SECTIONS}}
- 압축 가능한 부분: {{COMPRESSIBLE_SECTIONS}}

### 정보 밀도
{{INFORMATION_DENSITY_ASSESSMENT}}
<!-- 높음: 모든 문장이 Agent 행동에 영향
     보통: 일부 배경 설명이 포함
     낮음: 불필요한 설명이 많음 -->

### 개선된 버전 (압축)
{{?COMPRESSED_VERSION}}
<!-- 동일한 의미를 유지하면서 토큰을 절약한 버전 제안 -->
```

### 6. 보안 감사

```
## 보안 분석

### Prompt Injection 취약점
{{INJECTION_VULNERABILITIES}}
<!-- Agent가 악의적 입력에 의해 지시를 무시할 수 있는 경로 -->

### 권한 과다 점검
{{OVER_PERMISSION_CHECK}}
<!-- Agent에게 필요 이상의 도구/권한이 부여되었는지 점검 -->

### 민감 정보 노출 위험
{{SENSITIVE_INFO_RISK}}
<!-- 프롬프트에 API 키, 내부 URL 등 민감 정보가 포함되었는지 점검 -->
```

### 7. 종합 감사 결과

```
## 종합 결과

### 점수
| 영역 | 점수 (100점) | 등급 |
|------|-------------|------|
| 구조 | {{STRUCTURE_SCORE}} | {{STRUCTURE_GRADE}} |
| 명확성 | {{CLARITY_SCORE}} | {{CLARITY_GRADE}} |
| 완전성 | {{COMPLETENESS_SCORE}} | {{COMPLETENESS_GRADE}} |
| 효율성 | {{EFFICIENCY_SCORE}} | {{EFFICIENCY_GRADE}} |
| 보안 | {{SECURITY_SCORE}} | {{SECURITY_GRADE}} |
| **종합** | **{{TOTAL_SCORE}}** | **{{TOTAL_GRADE}}** |

### 핵심 발견사항
1. {{KEY_FINDING_1}}
2. {{KEY_FINDING_2}}
3. {{?KEY_FINDING_3}}

### 우선 조치 사항
1. [긴급] {{URGENT_ACTION_1}}
2. [중요] {{IMPORTANT_ACTION_1}}
3. [권장] {{?RECOMMENDED_ACTION_1}}
```

---

위 감사 프레임워크의 모든 항목을 빠짐없이 분석하고, 구체적인 개선 제안을 포함한 감사 보고서를 작성하세요.

## 품질 기준

- [ ] 5개 감사 영역(구조/명확성/완전성/효율성/보안)이 모두 분석되었는가?
- [ ] 모호한 표현이 구체적 대안과 함께 식별되었는가?
- [ ] 상충되는 지시사항이 발견되고 해결 방안이 제시되었는가?
- [ ] 엣지 케이스가 충분히 점검되었는가?
- [ ] 토큰 효율성 개선 방안이 포함되었는가?
- [ ] 보안 관점의 취약점 분석이 포함되었는가?
- [ ] 조치 사항에 우선순위가 부여되었는가?
- [ ] 감사 결과가 점수/등급으로 정량화되었는가?
