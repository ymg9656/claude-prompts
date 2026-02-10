# 레퍼런스 포함 Skill 생성 템플릿

## 사용 시기

- Skill이 외부 문서, 코딩 컨벤션, 패턴 가이드 등을 참고해야 할 때
- 워크플로우 실행 시 특정 규칙 문서를 컨텍스트로 로드해야 할 때
- `references/` 하위 디렉토리에 참고 자료를 포함하는 Skill을 만들 때

## 프롬프트

당신은 Claude Code Skill과 기술 문서 설계 전문가입니다.
아래 정보를 바탕으로 레퍼런스 문서를 포함하는 SKILL.md를 생성하세요.

### 입력 정보

- **Skill 이름**: {{SKILL_NAME}}
- **Skill 설명**: {{SKILL_DESCRIPTION}}
- **대상 작업**: {{TARGET_TASK}}
- **기술 스택**: {{TECH_STACK}}
- **레퍼런스 유형**: {{REFERENCE_TYPE}}
<!-- coding-convention, design-pattern, api-spec, checklist, style-guide 중 선택 -->
- **레퍼런스 내용 요약**: {{REFERENCE_SUMMARY}}
<!-- 각 레퍼런스 문서에 담길 핵심 내용 -->
- **레퍼런스 적용 시점**: {{REFERENCE_USAGE_TIMING}}
<!-- 워크플로우의 어떤 단계에서 레퍼런스를 참조하는지 -->
- **레퍼런스 업데이트 주기**: {{?REFERENCE_UPDATE_FREQUENCY}}
<!-- 레퍼런스 문서를 얼마나 자주 갱신해야 하는지 -->

### 생성 규칙

1. SKILL.md와 `references/` 디렉토리 구조를 함께 설계하세요
2. 레퍼런스 문서는 다음 규칙을 따르세요:
   - Markdown 형식으로 작성
   - 문서 상단에 목적, 대상 독자, 최종 수정일 명시
   - 검색 가능한 제목 구조 (H2, H3 활용)
   - 코드 예시가 필요한 경우 실행 가능한 예시 포함
3. SKILL.md 워크플로우에서 레퍼런스를 참조하는 방법을 명시하세요
4. 레퍼런스 문서의 크기가 컨텍스트 윈도우를 초과하지 않도록 분할 전략을 포함하세요

### 출력 형식

#### SKILL.md

```markdown
---
name: {{SKILL_NAME}}
description: {{SKILL_DESCRIPTION}}
---

# {{SKILL_TITLE}}

## 핵심 기능

- {{FEATURE_1}}
- {{FEATURE_2}}
- {{FEATURE_3}}

## 디렉토리 구조

```
{{SKILL_NAME}}/
├── SKILL.md
└── references/
    ├── {{REFERENCE_1_FILENAME}}    # {{REFERENCE_1_PURPOSE}}
    └── {{?REFERENCE_2_FILENAME}}   # {{?REFERENCE_2_PURPOSE}}
```

## 워크플로우

### 1. 레퍼런스 로드

작업에 필요한 레퍼런스 문서를 확인합니다.

```bash
# 레퍼런스 문서 존재 확인
ls references/{{REFERENCE_1_FILENAME}}

# 레퍼런스 내용 로드
cat references/{{REFERENCE_1_FILENAME}}
```

### 2. {{STEP_2_TITLE}}

{{STEP_2_DESCRIPTION}}
레퍼런스 `{{REFERENCE_1_FILENAME}}`의 {{REFERENCE_SECTION}}을 참고합니다.

```bash
{{STEP_2_COMMAND}}
```

### 3. 규칙 검증

생성된 결과가 레퍼런스 규칙을 준수하는지 확인합니다.

```bash
{{VALIDATION_COMMAND}}
```

## 에러 처리

| 에러 | 원인 | 해결 |
|------|------|------|
| 레퍼런스 파일 누락 | `references/` 디렉토리에 파일 없음 | 레퍼런스 파일을 생성하거나 경로 확인 |
| 레퍼런스 내용 불일치 | 문서 버전이 현재 프로젝트와 맞지 않음 | 레퍼런스를 최신 버전으로 업데이트 |
| {{ERROR_3}} | {{CAUSE_3}} | {{SOLUTION_3}} |

## 사용 예시

### 예시 1: {{EXAMPLE_1_TITLE}}

```
{{EXAMPLE_1_USAGE}}
```

## 리소스

- {{RESOURCE_1}}
- `references/` 디렉토리 내 모든 레퍼런스 문서
```

#### 레퍼런스 문서 (references/{{REFERENCE_1_FILENAME}})

```markdown
# {{REFERENCE_TITLE}}

<!-- 목적: {{REFERENCE_PURPOSE}} -->
<!-- 대상: {{REFERENCE_AUDIENCE}} -->
<!-- 최종 수정: {{REFERENCE_LAST_UPDATED}} -->

## 개요

{{REFERENCE_OVERVIEW}}

## {{REFERENCE_SECTION_1_TITLE}}

{{REFERENCE_SECTION_1_CONTENT}}

### 규칙

| 규칙 | 설명 | 예시 |
|------|------|------|
| {{RULE_1}} | {{RULE_1_DESC}} | {{RULE_1_EXAMPLE}} |
| {{RULE_2}} | {{RULE_2_DESC}} | {{RULE_2_EXAMPLE}} |

### 코드 예시

```{{CODE_LANGUAGE}}
{{CODE_EXAMPLE}}
```

## {{REFERENCE_SECTION_2_TITLE}}

{{REFERENCE_SECTION_2_CONTENT}}
```

## 품질 기준

- [ ] 레퍼런스 문서에 목적, 대상, 수정일이 명시되어 있는가?
- [ ] 레퍼런스 내용이 검색 가능한 제목 구조로 되어 있는가?
- [ ] SKILL.md 워크플로우에서 레퍼런스 참조 시점이 명확한가?
- [ ] 레퍼런스 문서 크기가 적절한가? (단일 문서 500줄 이하 권장)
- [ ] 레퍼런스 간 내용 중복이 없는가?
- [ ] 레퍼런스 규칙이 구체적이고 검증 가능한가?
- [ ] 레퍼런스 업데이트 방법이 안내되어 있는가?
