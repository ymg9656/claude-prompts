# Agent CLAUDE.md 파일 생성

## 사용 시기

- Agent 전용 프로젝트의 CLAUDE.md 파일을 작성할 때
- Agent가 작업하는 저장소의 컨텍스트 정보를 체계적으로 정리할 때
- 여러 Agent가 공유하는 프로젝트에서 각 Agent의 컨텍스트를 분리할 때

## 프롬프트

다음 정보를 기반으로 Agent 프로젝트의 CLAUDE.md 파일을 생성하세요. CLAUDE.md는 Agent가 프로젝트에 진입했을 때 가장 먼저 읽는 컨텍스트 파일입니다.

---

```markdown
# {{PROJECT_NAME}} - Project Context

## 프로젝트 개요
{{PROJECT_DESCRIPTION}}

## 디렉토리 구조
<!-- 프로젝트의 핵심 디렉토리만 포함합니다. 모든 파일을 나열하지 마세요. -->
{{DIRECTORY_STRUCTURE}}

## 기술 스택
- 언어: {{LANGUAGE}}
- 프레임워크: {{FRAMEWORK}}
- 빌드 도구: {{BUILD_TOOL}}
- 테스트: {{TEST_FRAMEWORK}}
- {{?ADDITIONAL_TOOLS}}

## 코딩 컨벤션

### 네이밍 규칙
{{NAMING_CONVENTIONS}}

### 파일 구조 규칙
{{FILE_STRUCTURE_RULES}}

### 코드 스타일
{{CODE_STYLE_RULES}}

## 주요 명령어
<!-- Agent가 자주 실행하는 명령어를 정리합니다 -->
| 명령어 | 설명 |
|--------|------|
| {{COMMAND_1}} | {{COMMAND_1_DESC}} |
| {{COMMAND_2}} | {{COMMAND_2_DESC}} |
| {{COMMAND_3}} | {{COMMAND_3_DESC}} |
| {{?COMMAND_4}} | {{?COMMAND_4_DESC}} |

## 아키텍처 핵심 사항
<!-- Agent가 코드를 이해하는 데 필수적인 아키텍처 정보만 포함합니다 -->
{{ARCHITECTURE_OVERVIEW}}

### 핵심 모듈
{{KEY_MODULES}}

### 데이터 흐름
{{DATA_FLOW}}

## Agent별 지침

### {{AGENT_NAME}} 전용 지침
<!-- 이 프로젝트에서 해당 Agent가 특별히 주의해야 할 사항 -->
{{AGENT_SPECIFIC_GUIDELINES}}

### 금지 사항
- {{FORBIDDEN_ACTION_1}}
- {{FORBIDDEN_ACTION_2}}
- {{?FORBIDDEN_ACTION_3}}

## 자주 발생하는 이슈
<!-- Agent가 반복적으로 마주치는 문제와 해결 방법 -->
| 이슈 | 원인 | 해결 방법 |
|------|------|-----------|
| {{ISSUE_1}} | {{CAUSE_1}} | {{SOLUTION_1}} |
| {{?ISSUE_2}} | {{?CAUSE_2}} | {{?SOLUTION_2}} |

## 참고 문서
<!-- 프로젝트 이해에 도움이 되는 내부/외부 문서 링크 -->
- {{?REFERENCE_1}}
- {{?REFERENCE_2}}
```

---

### 작성 가이드

CLAUDE.md 작성 시 다음 원칙을 따르세요:

1. **간결성**: 컨텍스트 윈도우를 낭비하지 않도록 핵심 정보만 포함
2. **실행 가능성**: Agent가 바로 행동에 옮길 수 있는 구체적인 지침 제공
3. **최신성**: 프로젝트 변경 시 CLAUDE.md도 함께 업데이트
4. **Agent 특화**: 범용 문서가 아닌, Agent의 작업에 필요한 정보 중심

## 품질 기준

- [ ] 프로젝트 개요가 1~3문장으로 핵심을 전달하는가?
- [ ] 디렉토리 구조가 핵심 경로만 포함하는가? (전체 트리 X)
- [ ] 기술 스택 정보가 버전과 함께 명시되었는가?
- [ ] 코딩 컨벤션이 구체적이고 예시가 포함되었는가?
- [ ] 주요 명령어가 Agent의 실제 작업에 필요한 것들인가?
- [ ] 아키텍처 설명이 코드 이해에 충분한 수준인가?
- [ ] Agent별 전용 지침이 해당 Agent의 역할에 맞게 작성되었는가?
- [ ] 자주 발생하는 이슈가 실제 경험에서 나온 것인가?
- [ ] 전체 분량이 500줄 이내로 유지되는가?
