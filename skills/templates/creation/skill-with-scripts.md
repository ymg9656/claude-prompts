# 스크립트 포함 Skill 생성 템플릿

## 사용 시기

- Skill의 워크플로우 중 복잡한 로직을 Shell/Python 스크립트로 분리해야 할 때
- 반복적인 명령어 조합을 하나의 스크립트로 캡슐화하려 할 때
- Skill이 `scripts/` 하위 디렉토리에 실행 가능한 스크립트를 포함해야 할 때

## 프롬프트

당신은 Claude Code Skill과 자동화 스크립트 설계 전문가입니다.
아래 정보를 바탕으로 SKILL.md 파일과 함께 사용할 스크립트 파일을 생성하세요.

### 입력 정보

- **Skill 이름**: {{SKILL_NAME}}
- **Skill 설명**: {{SKILL_DESCRIPTION}}
- **대상 작업**: {{TARGET_TASK}}
- **기술 스택**: {{TECH_STACK}}
- **스크립트 언어**: {{SCRIPT_LANGUAGE}}
<!-- shell (bash/zsh), python, node 중 선택 -->
- **스크립트 목적**: {{SCRIPT_PURPOSE}}
<!-- 각 스크립트가 수행할 구체적인 작업 -->
- **입력 파라미터**: {{SCRIPT_PARAMETERS}}
<!-- 스크립트가 받을 인자 목록과 설명 -->
- **실행 환경 요구사항**: {{?ENVIRONMENT_REQUIREMENTS}}
<!-- 필요한 CLI 도구, 런타임 버전 등 -->

### 생성 규칙

1. SKILL.md와 `scripts/` 디렉토리 구조를 함께 설계하세요
2. 스크립트 파일은 다음 규칙을 따르세요:
   - 파일 상단에 shebang(`#!/bin/bash` 등)과 용도 주석 포함
   - 입력 파라미터 유효성 검증 로직 포함
   - `set -euo pipefail` (bash) 또는 동등한 안전 장치 적용
   - 에러 발생 시 명확한 에러 메시지 출력
   - 종료 코드를 올바르게 반환 (성공: 0, 실패: 1+)
3. SKILL.md의 워크플로우에서 스크립트를 호출하는 방식을 명시하세요
4. 스크립트 간 의존성이 있으면 실행 순서를 명확히 하세요

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
└── scripts/
    ├── {{SCRIPT_1_FILENAME}}    # {{SCRIPT_1_PURPOSE}}
    └── {{?SCRIPT_2_FILENAME}}   # {{?SCRIPT_2_PURPOSE}}
```

## 워크플로우

### 1. 환경 확인

필요한 도구와 권한을 확인합니다.

```bash
# 스크립트 실행 권한 부여
chmod +x scripts/{{SCRIPT_1_FILENAME}}

# 의존성 확인
{{DEPENDENCY_CHECK_COMMAND}}
```

### 2. {{STEP_2_TITLE}}

{{STEP_2_DESCRIPTION}}

```bash
./scripts/{{SCRIPT_1_FILENAME}} {{SCRIPT_1_ARGS}}
```

### 3. {{STEP_3_TITLE}}

{{STEP_3_DESCRIPTION}}

```bash
{{STEP_3_COMMAND}}
```

## 에러 처리

| 에러 | 원인 | 해결 |
|------|------|------|
| `Permission denied` | 스크립트 실행 권한 없음 | `chmod +x scripts/*.sh` 실행 |
| {{ERROR_2}} | {{CAUSE_2}} | {{SOLUTION_2}} |
| {{ERROR_3}} | {{CAUSE_3}} | {{SOLUTION_3}} |

## 사용 예시

### 예시 1: {{EXAMPLE_1_TITLE}}

```
{{EXAMPLE_1_USAGE}}
```

## 리소스

- {{RESOURCE_1}}
```

#### 스크립트 파일 (scripts/{{SCRIPT_1_FILENAME}})

```bash
#!/bin/bash
# {{SCRIPT_1_PURPOSE}}
# Usage: ./scripts/{{SCRIPT_1_FILENAME}} {{SCRIPT_1_USAGE_ARGS}}

set -euo pipefail

# === 설정 ===
{{SCRIPT_CONFIG_VARIABLES}}

# === 입력 검증 ===
if [ $# -lt {{MIN_ARGS}} ]; then
    echo "Error: 필수 인자가 부족합니다."
    echo "Usage: $0 {{SCRIPT_1_USAGE_ARGS}}"
    exit 1
fi

{{PARAMETER_VALIDATION}}

# === 메인 로직 ===
{{SCRIPT_MAIN_LOGIC}}

# === 결과 출력 ===
{{SCRIPT_OUTPUT}}

exit 0
```

## 품질 기준

- [ ] SKILL.md에 디렉토리 구조가 명시되어 있는가?
- [ ] 모든 스크립트에 shebang과 용도 주석이 있는가?
- [ ] 스크립트에 입력 파라미터 유효성 검증이 있는가?
- [ ] `set -euo pipefail` 또는 동등한 안전 장치가 적용되었는가?
- [ ] 에러 메시지가 사용자 친화적이며 해결 방법을 안내하는가?
- [ ] 스크립트 종료 코드가 올바르게 반환되는가?
- [ ] SKILL.md 워크플로우에서 스크립트 호출 방법이 명확한가?
- [ ] 스크립트 간 의존성과 실행 순서가 문서화되었는가?
