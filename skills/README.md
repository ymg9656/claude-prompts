# skills — Skill 프롬프트

Claude Code Skill(SKILL.md) 생성, 활용, 분석을 위한 템플릿과 예시 모음입니다.

## Skill이란?

Skill은 Claude Code에서 슬래시 명령어(`/command`)로 호출되는 자동화된 워크플로우입니다.
YAML frontmatter + Markdown 본문으로 구성되며, 스크립트/레퍼런스/템플릿/에셋 등의 하위 리소스를 포함할 수 있습니다.

## 디렉토리 구조

```
skills/
├── README.md                          # 이 파일
├── templates/
│   ├── creation/                      # Skill 생성 프롬프트
│   │   ├── skill-md.md                # SKILL.md 파일 생성
│   │   ├── skill-with-scripts.md      # 스크립트 포함 Skill 생성
│   │   └── skill-with-references.md   # 레퍼런스 포함 Skill 생성
│   ├── usage/                         # Skill 활용 프롬프트
│   │   ├── skill-trigger-optimization.md  # 트리거 문구 최적화
│   │   ├── skill-composition.md           # 복합 Skill 조합
│   │   └── skill-context-management.md    # 컨텍스트/토큰 관리
│   └── analysis/                      # Skill 분석 프롬프트
│       ├── skill-effectiveness-review.md  # 효과성 리뷰
│       ├── skill-trigger-audit.md         # 트리거 충돌 감사
│       └── skill-improvement.md           # 개선 제안 생성
└── examples/                          # 실제 Skill 예시
    ├── git-commit-skill/              # Git 커밋 Skill (스크립트 포함)
    │   ├── SKILL.md
    │   └── scripts/commit-helper.sh
    ├── test-runner-skill/             # 테스트 실행 Skill (레퍼런스 포함)
    │   ├── SKILL.md
    │   └── references/testing-patterns.md
    └── api-generator-skill/           # API 생성 Skill (에셋 포함)
        ├── SKILL.md
        └── assets/api-template.yaml
```

## SKILL.md 표준 구조

```yaml
---
name: skill-name
description: Skill 설명
---
```

```markdown
# Skill 이름

## 핵심 기능
- 기능 1
- 기능 2

## 워크플로우
1. 단계 1
2. 단계 2

## 에러 처리
| 에러 | 원인 | 해결 |
|------|------|------|

## 사용 예시
## 리소스
```

## 템플릿 목록

### 생성 (Creation)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [skill-md.md](./templates/creation/skill-md.md) | SKILL.md 기본 생성 | 새 Skill 파일 작성 |
| [skill-with-scripts.md](./templates/creation/skill-with-scripts.md) | 스크립트 포함 Skill | Shell/Python 스크립트가 필요한 Skill |
| [skill-with-references.md](./templates/creation/skill-with-references.md) | 레퍼런스 포함 Skill | 참고 문서가 필요한 Skill |

### 활용 (Usage)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [skill-trigger-optimization.md](./templates/usage/skill-trigger-optimization.md) | 트리거 문구 최적화 | 트리거 인식률 개선 |
| [skill-composition.md](./templates/usage/skill-composition.md) | 복합 Skill 조합 | 여러 Skill 연계 사용 |
| [skill-context-management.md](./templates/usage/skill-context-management.md) | 컨텍스트 관리 | 토큰 사용량 최적화 |

### 분석 (Analysis)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [skill-effectiveness-review.md](./templates/analysis/skill-effectiveness-review.md) | 효과성 리뷰 | Skill 성능 평가 |
| [skill-trigger-audit.md](./templates/analysis/skill-trigger-audit.md) | 트리거 감사 | 트리거 충돌 검출 |
| [skill-improvement.md](./templates/analysis/skill-improvement.md) | 개선 제안 | Skill 품질 향상 |

## 예시 목록

| 예시 | 설명 | 포함 리소스 |
|------|------|-------------|
| [git-commit-skill](./examples/git-commit-skill/) | Git 커밋 자동화 | `scripts/` |
| [test-runner-skill](./examples/test-runner-skill/) | 테스트 실행 자동화 | `references/` |
| [api-generator-skill](./examples/api-generator-skill/) | API 코드 생성 | `assets/` |

## 활용 방법

1. **새 Skill 만들기**: `templates/creation/` 중 적합한 템플릿을 선택하여 플레이스홀더를 채웁니다
2. **기존 Skill 개선**: `templates/analysis/`로 현재 Skill을 분석한 후 `templates/usage/`로 최적화합니다
3. **예시 참고**: `examples/`의 완성된 Skill을 참고하여 구조를 파악합니다
