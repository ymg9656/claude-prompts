# Agent Registry

> 재사용 가능한 Agent 목록입니다. 각 Agent는 프로젝트에 독립적이며, `{{PLACEHOLDER}}`를 통해 프로젝트 컨텍스트를 주입합니다.

## Agent 목록

| Agent명 | 카테고리 | 역할 요약 | 기본 스킬 | 선택 스킬 |
|---------|---------|-----------|----------|----------|
| [Project Lead](leaders/project-lead.md) | Leaders | 범용 프로젝트 리더 — 작업 분해, 멤버 분배, 진행 관리, 결과 통합 | — | — |
| [Review Lead](leaders/review-lead.md) | Leaders | 리뷰 전문 리더 — 리뷰 파이프라인 관리, 발견사항 통합, 최종 판정 | `code-review` | — |
| [Audit Lead](leaders/audit-lead.md) | Leaders | 감사 전문 리더 — 보안/품질 감사 조율, 리스크 매트릭스 작성 | `code-review` | — |
| [Backend Dev](developers/backend-dev.md) | Developers | 백엔드 개발자 — REST API, DB, 서비스 로직 구현 | `git-commit`, `test-runner`, `lint-fix` | `api-generator`, `db-migration` |
| [Frontend Dev](developers/frontend-dev.md) | Developers | 프론트엔드 개발자 — UI 컴포넌트, 상태관리, API 연동 | `git-commit`, `test-runner`, `lint-fix` | — |
| [Fullstack Dev](developers/fullstack-dev.md) | Developers | 풀스택 개발자 — 프론트+백엔드 통합, 소규모 팀용 | `git-commit`, `test-runner`, `lint-fix` | `api-generator` |
| [Tester](quality/tester.md) | Quality | 테스트 전문가 — 단위/통합/E2E 테스트, 커버리지 분석 | `test-runner`, `lint-fix` | — |
| [Code Reviewer](quality/code-reviewer.md) | Quality | 코드 리뷰어 — 코드 품질, 아키텍처 준수, 보안 취약점 검토 | `code-review`, `lint-fix` | — |
| [Security Auditor](quality/security-auditor.md) | Quality | 보안 감사자 — OWASP Top 10, 의존성 취약점, 인프라 보안 점검 | `code-review` | — |
| [Tech Writer](support/tech-writer.md) | Support | 기술 문서 작성자 — API 문서, 가이드, CHANGELOG 작성 | `doc-generator` | — |
| [DevOps](support/devops.md) | Support | DevOps 엔지니어 — CI/CD, 배포, 인프라 관리 | `deploy`, `git-commit` | — |
| [Debugger](support/debugger.md) | Support | 디버깅 전문가 — 런타임 에러 분석, 가설 기반 디버깅 | `test-runner`, `lint-fix` | — |

## 사용 방법

### 1. Agent 선택
프로젝트 요구사항에 맞는 Agent를 위 목록에서 선택합니다.

### 2. 프로젝트 컨텍스트 주입
각 Agent의 `프로젝트 컨텍스트` 섹션에 있는 플레이스홀더를 실제 값으로 대체합니다:
- `{{TEAM_NAME}}` — 팀 이름 (필수)
- `{{TECH_STACK}}` — 기술 스택 (필수)
- `{{PROJECT_PATH}}` — 프로젝트 경로 (필수)
- `{{?CONVENTIONS}}` — 코딩 컨벤션 (선택)
- `{{?PROJECT_DESCRIPTION}}` — 프로젝트 설명 (선택)

### 3. 팀 구성
[Teams 디렉토리](../../teams/)의 `config.json`에서 선택한 Agent들을 조합하여 팀을 구성합니다.

## 카테고리 설명

| 카테고리 | 설명 | 리더 필요 여부 |
|---------|------|--------------|
| **Leaders** | 팀을 조율하고 작업을 분배하는 리더 Agent | 해당 없음 (리더 자체) |
| **Developers** | 코드를 직접 작성하고 구현하는 개발 Agent | 권장 |
| **Quality** | 코드 품질, 보안, 테스트를 담당하는 품질 Agent | 권장 |
| **Support** | 문서, 인프라, 디버깅 등 지원 역할의 Agent | 선택 |
