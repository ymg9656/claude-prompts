# Skill Library

Phase 1 스킬 라이브러리입니다. 모든 스킬은 동일한 YAML 프론트매터 + 마크다운 형식을 따릅니다.

## 스킬 목록

| 스킬명 | 설명 | 활용 Agent | 기본/선택 |
|--------|------|-----------|-----------|
| [git-commit](./git-commit/SKILL.md) | Git 변경사항 분석 및 컨벤셔널 커밋 메시지 생성 | 전체 | 기본 |
| [test-runner](./test-runner/SKILL.md) | 테스트 프레임워크 자동 감지 및 실행, 결과 분석 | 전체 | 기본 |
| [api-generator](./api-generator/SKILL.md) | OpenAPI 스펙 기반 REST API 엔드포인트 코드 자동 생성 | backend-dev | 선택 |
| [code-review](./code-review/SKILL.md) | 코드 리뷰 체크리스트 실행, 파일별 이슈 발견 및 심각도 분류 | code-reviewer, security-auditor | 기본 |
| [deploy](./deploy/SKILL.md) | 배포 파이프라인 실행 (빌드 → 테스트 → 배포), 환경별 배포 및 롤백 | devops | 선택 |
| [db-migration](./db-migration/SKILL.md) | DB 스키마 변경 마이그레이션 파일 생성 및 실행 | backend-dev | 선택 |
| [lint-fix](./lint-fix/SKILL.md) | 린트 검사 및 자동 수정, 수정 전후 diff 표시 | 전체 | 기본 |
| [doc-generator](./doc-generator/SKILL.md) | API 문서 자동 생성, CHANGELOG 생성, 아키텍처 문서 보조 | tech-writer | 선택 |
| [project-planning](./project-planning/SKILL.md) | 요구사항 분석, 비즈니스 기능 명세서 생성, WBS 작성, 일정 산정 | system-planner, project-manager | 기본 |
| [technical-spec](./technical-spec/SKILL.md) | API 스펙, DB 스키마, 아키텍처 설계 문서 작성 | backend-dev, frontend-dev, fullstack-dev | 선택 |

## 사용 방법

각 스킬의 `SKILL.md`를 참고하여 Agent에 연결하거나 단독으로 실행할 수 있습니다.

```
skills/library/
├── index.md                 # 이 파일
├── git-commit/SKILL.md      # 기존 스킬 (examples에서 참조)
├── test-runner/SKILL.md     # 기존 스킬 (examples에서 참조)
├── api-generator/SKILL.md   # 기존 스킬 (examples에서 참조)
├── code-review/SKILL.md     # 신규
├── deploy/SKILL.md          # 신규
├── db-migration/SKILL.md    # 신규
├── lint-fix/SKILL.md        # 신규
├── doc-generator/SKILL.md   # 신규
├── project-planning/SKILL.md # 신규
└── technical-spec/SKILL.md   # 신규
```
