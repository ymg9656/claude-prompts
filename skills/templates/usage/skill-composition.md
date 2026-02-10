# 복합 Skill 조합 템플릿

## 사용 시기

- 하나의 작업을 완료하기 위해 여러 Skill을 순차적/병렬로 실행해야 할 때
- 기존 Skill들을 조합하여 새로운 고수준 워크플로우를 만들 때
- Skill 간 데이터 전달과 의존성을 설계해야 할 때

## 프롬프트

당신은 Claude Code Skill 아키텍트입니다.
아래 Skill들을 조합하여 복합 워크플로우를 설계하세요.

### 입력 정보

- **복합 워크플로우 이름**: {{WORKFLOW_NAME}}
- **워크플로우 목적**: {{WORKFLOW_PURPOSE}}
- **조합할 Skill 목록**: {{SKILL_LIST}}
<!-- 각 Skill의 이름, 핵심 기능, 입출력을 나열하세요 -->
- **실행 순서 유형**: {{EXECUTION_TYPE}}
<!-- sequential (순차), parallel (병렬), conditional (조건부) 중 선택 -->
- **Skill 간 데이터 전달**: {{DATA_FLOW}}
<!-- 어떤 Skill의 출력이 다른 Skill의 입력이 되는지 -->
- **전체 입력**: {{WORKFLOW_INPUT}}
- **기대 최종 출력**: {{WORKFLOW_OUTPUT}}
- **실패 처리 전략**: {{?FAILURE_STRATEGY}}
<!-- fail-fast, continue-on-error, rollback 중 선택 -->

### 설계 규칙

1. **의존성 그래프**: Skill 간 의존 관계를 명확히 도식화하세요
2. **데이터 계약**: 각 Skill 간 전달되는 데이터의 형식과 타입을 정의하세요
3. **실행 흐름**: 순차/병렬/조건부 분기를 명확히 구분하세요
4. **에러 전파**: 한 Skill의 실패가 전체 워크플로우에 미치는 영향을 정의하세요
5. **상태 관리**: 중간 결과를 임시 파일/변수에 저장하는 방법을 명시하세요

### 출력 형식

```markdown
## 복합 워크플로우: {{WORKFLOW_NAME}}

### 개요

{{WORKFLOW_PURPOSE}}

### Skill 의존성 그래프

```
{{DEPENDENCY_GRAPH}}
<!-- 예시:
[Skill A] → [Skill B] → [Skill D]
                ↘
[Skill A] → [Skill C] ↗
-->
```

### 실행 계획

#### Phase 1: {{PHASE_1_NAME}}
- **실행 Skill**: {{PHASE_1_SKILLS}}
- **실행 방식**: {{sequential/parallel}}
- **입력**: {{PHASE_1_INPUT}}
- **출력**: {{PHASE_1_OUTPUT}}

```bash
# Phase 1 실행
{{PHASE_1_COMMAND}}
```

#### Phase 2: {{PHASE_2_NAME}}
- **실행 Skill**: {{PHASE_2_SKILLS}}
- **실행 방식**: {{sequential/parallel}}
- **입력**: Phase 1의 출력
- **출력**: {{PHASE_2_OUTPUT}}

```bash
# Phase 2 실행
{{PHASE_2_COMMAND}}
```

<!-- 필요한 만큼 Phase 추가 -->

### 데이터 계약

| 송신 Skill | 수신 Skill | 데이터 형식 | 설명 |
|------------|------------|------------|------|
| {{SENDER_1}} | {{RECEIVER_1}} | {{FORMAT_1}} | {{DATA_DESC_1}} |
| {{SENDER_2}} | {{RECEIVER_2}} | {{FORMAT_2}} | {{DATA_DESC_2}} |

### 에러 처리

| 실패 지점 | 영향 범위 | 처리 방법 |
|-----------|----------|-----------|
| {{FAIL_POINT_1}} | {{IMPACT_1}} | {{HANDLING_1}} |
| {{FAIL_POINT_2}} | {{IMPACT_2}} | {{HANDLING_2}} |

### 사용 예시

```
{{WORKFLOW_USAGE_EXAMPLE}}
```
```

## 품질 기준

- [ ] Skill 의존성 그래프가 순환 참조 없이 명확한가?
- [ ] 데이터 계약이 모든 Skill 간 전달에 대해 정의되었는가?
- [ ] 실행 방식(순차/병렬/조건부)이 각 Phase에 명시되었는가?
- [ ] 에러 전파 경로와 처리 방법이 정의되었는가?
- [ ] 중간 상태 저장 방법이 명시되었는가?
- [ ] 전체 워크플로우의 예상 실행 시간이 합리적인가?
- [ ] 개별 Skill을 독립적으로도 사용할 수 있는가?
