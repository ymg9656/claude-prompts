# Skill 컨텍스트 관리 템플릿

## 사용 시기

- Skill이 많은 파일/레퍼런스를 읽어 토큰 사용량이 과도할 때
- 컨텍스트 윈도우 한계로 Skill 실행이 중단되거나 품질이 저하될 때
- Skill의 레퍼런스, 스크립트, 에셋을 효율적으로 로드하고 관리하려 할 때
- 긴 워크플로우에서 중간 상태를 효율적으로 유지해야 할 때

## 프롬프트

당신은 Claude Code 컨텍스트 최적화 전문가입니다.
아래 Skill의 컨텍스트 사용 패턴을 분석하고 최적화 방안을 제시하세요.

### 입력 정보

- **Skill 이름**: {{SKILL_NAME}}
- **현재 SKILL.md 내용**: {{SKILL_MD_CONTENT}}
<!-- SKILL.md 전체 내용을 붙여넣으세요 -->
- **포함 리소스 목록**: {{RESOURCE_LIST}}
<!-- 각 리소스 파일명과 대략적 크기(줄 수) -->
- **평균 워크플로우 실행 시 읽는 파일 수**: {{FILES_READ_COUNT}}
- **관찰된 문제**: {{?OBSERVED_ISSUES}}
<!-- "토큰 초과", "응답 품질 저하", "긴 대기 시간" 등 -->
- **컨텍스트 윈도우 크기**: {{?CONTEXT_WINDOW_SIZE}}
<!-- 기본값: 200K 토큰 -->

### 분석 및 최적화 규칙

다음 순서로 분석하세요:

1. **컨텍스트 사용량 감사**
   - SKILL.md 자체의 토큰 수 추정
   - 각 리소스 파일의 토큰 수 추정
   - 워크플로우 실행 시 총 토큰 사용량 추정

2. **최적화 전략 수립**
   - 불필요한 컨텍스트 제거
   - 레퍼런스 분할 (필요한 섹션만 로드)
   - 지연 로딩 (필요한 시점에만 읽기)
   - 요약 레이어 도입 (전체 대신 요약 로드)

3. **최적화 적용**
   - 개선된 SKILL.md 구조 제안
   - 리소스 분할/재구성 계획
   - 워크플로우 단계별 컨텍스트 로드 계획

### 출력 형식

```markdown
## 컨텍스트 사용량 감사

### 현재 상태

| 리소스 | 추정 줄 수 | 추정 토큰 수 | 필수 여부 |
|--------|-----------|-------------|----------|
| SKILL.md | {{LINES_1}} | {{TOKENS_1}} | 필수 |
| {{RESOURCE_1}} | {{LINES_2}} | {{TOKENS_2}} | {{REQUIRED_1}} |
| {{RESOURCE_2}} | {{LINES_3}} | {{TOKENS_3}} | {{REQUIRED_2}} |
| **합계** | {{TOTAL_LINES}} | {{TOTAL_TOKENS}} | - |

### 병목 분석

- 전체 컨텍스트 윈도우 대비 사용률: {{USAGE_PERCENTAGE}}%
- 가장 큰 리소스: {{LARGEST_RESOURCE}} ({{LARGEST_TOKENS}} 토큰)
- 불필요하게 로드되는 리소스: {{UNNECESSARY_RESOURCES}}

## 최적화 방안

### 방안 1: 리소스 분할

{{SPLIT_STRATEGY}}

```
# 변경 전
references/large-guide.md (500줄)

# 변경 후
references/guide-overview.md (50줄)    # 항상 로드
references/guide-section-a.md (150줄)  # 필요 시 로드
references/guide-section-b.md (150줄)  # 필요 시 로드
references/guide-section-c.md (150줄)  # 필요 시 로드
```

### 방안 2: 지연 로딩 워크플로우

{{LAZY_LOADING_STRATEGY}}

```markdown
## 워크플로우 (최적화)

### 1. 작업 분류
<!-- 이 단계에서는 SKILL.md만 필요 -->
작업 유형을 판단합니다.

### 2. 관련 레퍼런스 로드
<!-- 작업 유형에 따라 필요한 레퍼런스만 로드 -->
```bash
cat references/guide-section-{{RELEVANT_SECTION}}.md
```
```

### 방안 3: 요약 레이어

{{SUMMARY_LAYER_STRATEGY}}

## 예상 효과

| 지표 | 변경 전 | 변경 후 | 개선율 |
|------|---------|---------|--------|
| 총 토큰 사용량 | {{BEFORE_TOKENS}} | {{AFTER_TOKENS}} | {{IMPROVEMENT}}% |
| 평균 응답 시간 | {{BEFORE_TIME}} | {{AFTER_TIME}} | {{TIME_IMPROVEMENT}}% |
| 읽는 파일 수 | {{BEFORE_FILES}} | {{AFTER_FILES}} | {{FILE_IMPROVEMENT}}% |
```

## 품질 기준

- [ ] 컨텍스트 사용량이 정량적으로 분석되었는가?
- [ ] 병목 지점이 구체적으로 식별되었는가?
- [ ] 최적화 방안이 2개 이상 제시되었는가?
- [ ] 리소스 분할 시 정보 손실이 없는가?
- [ ] 지연 로딩으로 인한 워크플로우 복잡도 증가가 수용 가능한가?
- [ ] 예상 효과가 정량적으로 제시되었는가?
- [ ] 최적화 후에도 Skill의 핵심 기능이 보장되는가?
