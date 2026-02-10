# docs -- 문서 생성/리뷰 프롬프트

문서를 생성, 활용, 분석하기 위한 프롬프트 템플릿과 예시 모음입니다.

## 핵심 패턴

문서 프롬프트는 **대상 독자 -> 문서 유형 -> 구조 설계 -> 내용 작성 -> 품질 검증** 패턴을 따릅니다:

1. **대상 독자** -- 문서를 읽을 사람의 역할과 기술 수준 정의
2. **문서 유형** -- 기술 스펙, API 레퍼런스, 가이드 등 유형 명시
3. **구조 설계** -- 목차, 섹션 구성, 깊이 수준 결정
4. **내용 작성** -- 실제 내용 생성 (코드 예시, 다이어그램 포함)
5. **품질 검증** -- 정확성, 완전성, 일관성 체크

## 디렉토리 구조

```
docs/
├── README.md                                  # 이 파일
├── templates/
│   ├── creation/                              # 생성 관련 프롬프트
│   │   ├── doc-technical-spec.md              # 기술 사양서 생성
│   │   ├── doc-api-reference.md               # API 레퍼런스 문서 생성
│   │   └── doc-user-guide.md                  # 사용자 가이드 생성
│   ├── usage/                                 # 활용 관련 프롬프트
│   │   ├── doc-review-request.md              # 문서 리뷰 요청
│   │   ├── doc-translation.md                 # 한영/영한 번역
│   │   └── doc-summarization.md               # 문서 요약
│   └── analysis/                              # 분석/개선 프롬프트
│       ├── doc-quality-review.md              # 문서 품질 분석
│       ├── doc-completeness-check.md          # 문서 완전성 점검
│       └── doc-consistency-audit.md           # 문서 일관성 감사
└── examples/                                  # 실제 사용 예시
    ├── api-doc-example.md                     # API 문서 예시
    ├── architecture-doc-example.md            # 아키텍처 문서 예시
    └── onboarding-guide-example.md            # 온보딩 가이드 예시
```

## 템플릿 목록

### Creation (생성)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [doc-technical-spec.md](./templates/creation/doc-technical-spec.md) | 기술 사양서 생성 | 시스템/기능의 기술 스펙 문서 작성 |
| [doc-api-reference.md](./templates/creation/doc-api-reference.md) | API 레퍼런스 생성 | REST/GraphQL API 문서 작성 |
| [doc-user-guide.md](./templates/creation/doc-user-guide.md) | 사용자 가이드 생성 | 최종 사용자/개발자 가이드 작성 |

### Usage (활용)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [doc-review-request.md](./templates/usage/doc-review-request.md) | 문서 리뷰 요청 | 기존 문서에 대한 피드백 요청 |
| [doc-translation.md](./templates/usage/doc-translation.md) | 문서 번역 | 한국어/영어 간 기술 문서 번역 |
| [doc-summarization.md](./templates/usage/doc-summarization.md) | 문서 요약 | 긴 문서의 핵심 요약 생성 |

### Analysis (분석)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [doc-quality-review.md](./templates/analysis/doc-quality-review.md) | 품질 분석 | 문서의 전반적 품질 평가 |
| [doc-completeness-check.md](./templates/analysis/doc-completeness-check.md) | 완전성 점검 | 누락된 섹션/내용 식별 |
| [doc-consistency-audit.md](./templates/analysis/doc-consistency-audit.md) | 일관성 감사 | 여러 문서 간 용어/형식 일관성 검증 |

## 예시 목록

| 예시 | 설명 |
|------|------|
| [api-doc-example.md](./examples/api-doc-example.md) | REST API 문서 완성 예시 (인증 API) |
| [architecture-doc-example.md](./examples/architecture-doc-example.md) | 마이크로서비스 아키텍처 문서 완성 예시 |
| [onboarding-guide-example.md](./examples/onboarding-guide-example.md) | 신규 개발자 온보딩 가이드 완성 예시 |

## 관련 문서

- [프롬프트 표준 구조](../_common/prompt-structure.md)
- [플레이스홀더 규칙](../_common/placeholders.md)
- [공통 평가 기준](../_common/evaluation-criteria.md)
