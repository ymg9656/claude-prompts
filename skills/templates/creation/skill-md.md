# SKILL.md 파일 생성 템플릿

## 사용 시기

- 새로운 Claude Code Skill을 처음 만들 때
- 기존 수동 워크플로우를 Skill로 자동화하려 할 때
- YAML frontmatter + Markdown 본문 형식의 표준 SKILL.md가 필요할 때

## 프롬프트

당신은 Claude Code Skill 설계 전문가입니다.
아래 정보를 바탕으로 SKILL.md 파일을 생성하세요.

### 입력 정보

<!-- Skill의 기본 정보를 입력하세요 -->

- **Skill 이름**: {{SKILL_NAME}}
- **Skill 설명**: {{SKILL_DESCRIPTION}}
- **대상 작업**: {{TARGET_TASK}}
<!-- 이 Skill이 자동화할 구체적인 작업을 서술하세요 -->
- **기술 스택**: {{TECH_STACK}}
- **트리거 문구**: {{SKILL_TRIGGERS}}
<!-- 사용자가 이 Skill을 호출할 때 사용할 문구 목록 (예: "/commit", "커밋 해줘") -->
- **선행 조건**: {{?PREREQUISITES}}
<!-- 이 Skill 실행 전에 필요한 환경/도구/설정 -->

### 생성 규칙

1. YAML frontmatter에 `name`과 `description`을 포함하세요
2. 본문은 다음 섹션 순서를 따르세요:
   - `# Skill 제목`
   - `## 핵심 기능` — 3~5개 핵심 기능 bullet 목록
   - `## 워크플로우` — 번호 매긴 단계별 절차, 각 단계에 bash 코드 블록 포함
   - `## 에러 처리` — 테이블 형식 (에러 | 원인 | 해결)
   - `## 사용 예시` — 최소 2개의 사용 시나리오
   - `## 리소스` — 참조할 외부 도구/문서 목록
3. 워크플로우의 각 단계는 독립적으로 실행 가능해야 합니다
4. 에러 처리 테이블에 최소 3개의 에러 시나리오를 포함하세요
5. 트리거 문구는 자연어와 슬래시 명령어 모두 포함하세요

### 출력 형식

```markdown
---
name: {{SKILL_NAME}}
description: {{SKILL_DESCRIPTION}}
---

# {{SKILL_TITLE}}

{{?SKILL_OVERVIEW}}
<!-- 1~2문장의 개요. 생략 가능 -->

## 핵심 기능

- {{FEATURE_1}}
- {{FEATURE_2}}
- {{FEATURE_3}}
<!-- 3~5개 작성 -->

## 워크플로우

### 1. {{STEP_1_TITLE}}

{{STEP_1_DESCRIPTION}}

```bash
{{STEP_1_COMMAND}}
```

### 2. {{STEP_2_TITLE}}

{{STEP_2_DESCRIPTION}}

```bash
{{STEP_2_COMMAND}}
```

### 3. {{STEP_3_TITLE}}

{{STEP_3_DESCRIPTION}}

```bash
{{STEP_3_COMMAND}}
```

<!-- 필요한 만큼 단계를 추가하세요 -->

## 에러 처리

| 에러 | 원인 | 해결 |
|------|------|------|
| {{ERROR_1}} | {{CAUSE_1}} | {{SOLUTION_1}} |
| {{ERROR_2}} | {{CAUSE_2}} | {{SOLUTION_2}} |
| {{ERROR_3}} | {{CAUSE_3}} | {{SOLUTION_3}} |

## 사용 예시

### 예시 1: {{EXAMPLE_1_TITLE}}

```
{{EXAMPLE_1_USAGE}}
```

### 예시 2: {{EXAMPLE_2_TITLE}}

```
{{EXAMPLE_2_USAGE}}
```

## 리소스

- {{RESOURCE_1}}
- {{RESOURCE_2}}
<!-- 외부 도구, 문서, API 레퍼런스 등 -->
```

## 품질 기준

- [ ] YAML frontmatter에 `name`과 `description`이 올바르게 작성되었는가?
- [ ] 핵심 기능이 3~5개 범위 내이며, 각각 구체적인가?
- [ ] 워크플로우의 각 단계가 bash 코드 블록을 포함하는가?
- [ ] 워크플로우 단계가 독립적으로 실행 가능한가?
- [ ] 에러 처리 테이블에 최소 3개의 시나리오가 있는가?
- [ ] 사용 예시가 최소 2개이며, 실제적인가?
- [ ] 트리거 문구가 다른 Skill과 충돌하지 않는가?
