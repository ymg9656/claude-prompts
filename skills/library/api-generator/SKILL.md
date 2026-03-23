---
name: api-generator
description: OpenAPI 스펙을 기반으로 REST API 엔드포인트 코드를 자동 생성합니다.
source: skills/examples/api-generator-skill/SKILL.md
---

# API Generator Skill

> 전체 구현은 [`skills/examples/api-generator-skill/SKILL.md`](../../examples/api-generator-skill/SKILL.md)를 참조하세요.

OpenAPI(Swagger) 스펙 또는 자연어 요구사항을 기반으로 REST API 엔드포인트의 컨트롤러, 서비스, DTO, 테스트 코드를 자동 생성하는 Skill입니다.

## 핵심 기능

- OpenAPI YAML/JSON 스펙 파싱 및 코드 생성
- 자연어 요구사항에서 API 스펙 자동 추출
- 컨트롤러, 서비스, DTO, 유효성 검증 코드 일괄 생성
- 기존 프로젝트의 코딩 컨벤션 자동 감지 및 적용
- 생성된 API에 대한 기본 테스트 코드 자동 생성

## 활용 Agent

- backend-dev Agent에서 선택 스킬로 사용
