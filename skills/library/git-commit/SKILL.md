---
name: git-commit
description: Git 변경사항을 분석하고 컨벤셔널 커밋 메시지를 생성하여 커밋을 수행합니다.
source: skills/examples/git-commit-skill/SKILL.md
---

# Git Commit Skill

> 전체 구현은 [`skills/examples/git-commit-skill/SKILL.md`](../../examples/git-commit-skill/SKILL.md)를 참조하세요.

Git 스테이징 영역의 변경사항을 분석하고, Conventional Commits 규칙에 따라 커밋 메시지를 자동 생성한 후 커밋을 수행하는 Skill입니다.

## 핵심 기능

- 스테이징된 변경사항의 diff를 자동 분석
- Conventional Commits 형식의 커밋 메시지 생성 (type, scope, description)
- 변경 파일 수와 영향 범위에 따른 커밋 분할 제안
- 커밋 전 린트/테스트 검증 (pre-commit hook 연동)
- 커밋 히스토리와의 일관성 유지

## 활용 Agent

- 전체 Agent에서 기본 스킬로 사용
