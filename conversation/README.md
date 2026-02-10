# conversation -- 대화 프롬프트

Claude와의 대화를 설계, 활용, 분석하기 위한 프롬프트 템플릿과 예시 모음입니다.

## 핵심 패턴

대화 프롬프트는 **Persona -> Structure -> Guidance -> Iteration** 패턴을 따릅니다:

1. **Persona** -- 대화 주체의 성격, 전문성, 톤 정의
2. **Structure** -- 응답 형식과 대화 흐름 설계
3. **Guidance** -- 추론 방식과 출력 품질 유도
4. **Iteration** -- 반복 개선을 통한 최적화

## 디렉토리 구조

```
conversation/
├── README.md                                  # 이 파일
├── templates/
│   ├── creation/                              # 생성 관련 프롬프트
│   │   ├── conv-system-prompt.md              # 대화용 시스템 프롬프트 설계
│   │   ├── conv-persona-design.md             # 페르소나 설계
│   │   └── conv-few-shot-builder.md           # Few-shot 예시 구성
│   ├── usage/                                 # 활용 관련 프롬프트
│   │   ├── conv-chain-of-thought.md           # Chain-of-Thought 추론 유도
│   │   ├── conv-structured-output.md          # 구조화된 출력 요청
│   │   └── conv-iterative-refinement.md       # 반복 개선 대화
│   └── analysis/                              # 분석/개선 프롬프트
│       ├── conv-prompt-evaluation.md          # 프롬프트 효과성 평가
│       ├── conv-response-analysis.md          # 응답 품질 분석
│       └── conv-optimization.md               # 프롬프트 최적화
└── examples/                                  # 실제 사용 예시
    ├── code-review-conversation.md            # 코드 리뷰 대화 예시
    ├── brainstorming-session.md               # 브레인스토밍 세션 예시
    └── technical-interview.md                 # 기술 인터뷰 예시
```

## 템플릿 목록

### Creation (생성)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [conv-system-prompt.md](./templates/creation/conv-system-prompt.md) | 시스템 프롬프트 설계 | 대화 목적에 맞는 시스템 프롬프트 작성 |
| [conv-persona-design.md](./templates/creation/conv-persona-design.md) | 페르소나 설계 | 전문성, 톤, 스타일을 갖춘 페르소나 구성 |
| [conv-few-shot-builder.md](./templates/creation/conv-few-shot-builder.md) | Few-shot 예시 구성 | 일관된 출력을 위한 예시 세트 설계 |

### Usage (활용)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [conv-chain-of-thought.md](./templates/usage/conv-chain-of-thought.md) | Chain-of-Thought 유도 | 단계적 추론을 통한 정확도 향상 |
| [conv-structured-output.md](./templates/usage/conv-structured-output.md) | 구조화된 출력 | JSON, 표, 특정 포맷의 출력 요청 |
| [conv-iterative-refinement.md](./templates/usage/conv-iterative-refinement.md) | 반복 개선 | 대화를 통한 점진적 결과물 개선 |

### Analysis (분석)

| 템플릿 | 설명 | 용도 |
|--------|------|------|
| [conv-prompt-evaluation.md](./templates/analysis/conv-prompt-evaluation.md) | 프롬프트 평가 | 프롬프트 효과성과 개선점 분석 |
| [conv-response-analysis.md](./templates/analysis/conv-response-analysis.md) | 응답 분석 | 응답 품질과 일관성 검증 |
| [conv-optimization.md](./templates/analysis/conv-optimization.md) | 프롬프트 최적화 | 성능 개선을 위한 프롬프트 리팩토링 |

## 예시 목록

| 예시 | 설명 |
|------|------|
| [code-review-conversation.md](./examples/code-review-conversation.md) | 코드 리뷰 대화 (완성된 시스템 프롬프트와 대화 흐름) |
| [brainstorming-session.md](./examples/brainstorming-session.md) | 브레인스토밍 세션 (아이디어 발산/수렴 대화 설계) |
| [technical-interview.md](./examples/technical-interview.md) | 기술 인터뷰 (면접관 역할 대화 구성) |

## 관련 문서

- [프롬프트 표준 구조](../_common/prompt-structure.md)
- [플레이스홀더 규칙](../_common/placeholders.md)
- [공통 평가 기준](../_common/evaluation-criteria.md)
