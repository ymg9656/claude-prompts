# Claude Prompts - Project Context

## 프로젝트 개요
Claude Code에서 사용하는 프롬프트(Agent, Skill, Team, 문서, 대화)를 체계적으로 관리하는 템플릿/예시 저장소.

## 디렉토리 구조
- `_common/` — 공통 패턴 (프롬프트 구조, 플레이스홀더 규칙, 평가 기준)
- `agents/` — Agent 프롬프트 (시스템 프롬프트, CLAUDE.md, Sub-agent 등)
- `skills/` — Skill 프롬프트 (SKILL.md, 스크립트, 레퍼런스 포함)
- `teams/` — Team 프롬프트 (config.json, 리더/멤버 Agent 설정)
- `docs/` — 문서 생성/리뷰 프롬프트
- `conversation/` — 일반 대화 프롬프트 (시스템 프롬프트, CoT, Few-shot 등)

## 템플릿 컨벤션

### 파일 구조
모든 템플릿은 3-파트 구조:
1. `## 사용 시기` — 선택 기준
2. `## 프롬프트` — `{{PLACEHOLDER}}`가 포함된 실제 프롬프트
3. `## 품질 기준` — 결과물 검증 체크리스트

### 플레이스홀더 규칙
- `{{REQUIRED_FIELD}}` — 필수 입력
- `{{?OPTIONAL_FIELD}}` — 선택 입력
- `<!-- 설명 -->` — 작성 가이드 주석

### 카테고리별 하위 구조
각 카테고리는 동일한 패턴:
```
category/
├── README.md
├── templates/
│   ├── creation/    # 생성 관련 프롬프트
│   ├── usage/       # 활용 관련 프롬프트
│   └── analysis/    # 분석/개선 프롬프트
└── examples/        # 실제 사용 예시
```

## 언어
- 템플릿 본문: 한국어 (프롬프트 내부 지시사항)
- 플레이스홀더 이름: 영어 대문자 (`{{PROJECT_NAME}}`)
- 파일명: 영어 소문자 케밥 케이스 (`agent-system-prompt.md`)
