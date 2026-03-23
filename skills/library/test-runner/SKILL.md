---
name: test-runner
description: 프로젝트의 테스트를 실행하고 결과를 분석하여 실패 원인과 개선 방안을 제시합니다.
source: skills/examples/test-runner-skill/SKILL.md
---

# Test Runner Skill

> 전체 구현은 [`skills/examples/test-runner-skill/SKILL.md`](../../examples/test-runner-skill/SKILL.md)를 참조하세요.

프로젝트의 테스트 프레임워크를 자동 감지하고, 테스트를 실행한 후 결과를 분석하여 실패 원인 진단과 개선 제안을 수행하는 Skill입니다.

## 핵심 기능

- 프로젝트의 테스트 프레임워크 자동 감지 (Jest, Pytest, JUnit, Go test 등)
- 전체 테스트 또는 특정 파일/패턴 기반 선택적 테스트 실행
- 테스트 실패 시 원인 분석 및 수정 제안
- 커버리지 리포트 생성 및 분석
- 테스트 패턴 가이드에 기반한 테스트 품질 점검

## 활용 Agent

- 전체 Agent에서 기본 스킬로 사용
