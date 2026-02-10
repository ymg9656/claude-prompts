# conv-structured-output -- 구조화된 출력 요청

## 사용 시기

- Claude의 응답을 JSON, YAML, CSV 등 기계 파싱 가능한 형식으로 받고 싶을 때
- 표, 목록, 카드 등 일정한 시각적 구조를 갖춘 응답이 필요할 때
- 응답을 후속 자동화 파이프라인에 연결해야 할 때
- 여러 항목을 비교하거나 정리해야 할 때

## 프롬프트

```markdown
당신은 {{ROLE}}입니다.
다음 작업을 수행하고, 지정된 형식으로 정확히 출력하세요.

### 작업
{{TASK_DESCRIPTION}}

### 입력 데이터
{{INPUT_DATA}}

### 출력 형식

{{OUTPUT_FORMAT_TYPE}}에 맞춰 응답하세요.
<!-- OUTPUT_FORMAT_TYPE 예시: JSON / Markdown 표 / YAML / CSV / 번호 목록 -->

#### 스키마 정의
```{{FORMAT_LANGUAGE}}
{{OUTPUT_SCHEMA}}
```
<!-- FORMAT_LANGUAGE: json, yaml, typescript 등 스키마 표현 언어 -->
<!-- 예시 (JSON):
{
  "summary": "string - 전체 요약 (1-2문장)",
  "items": [
    {
      "name": "string - 항목 이름",
      "category": "string - 카테고리 (enum: critical, warning, info)",
      "description": "string - 상세 설명",
      "recommendation": "string - 권장 조치"
    }
  ],
  "metadata": {
    "total_count": "number - 총 항목 수",
    "generated_at": "string - ISO 8601 날짜"
  }
}
-->

#### 필드 규칙
<!-- 각 필드의 세부 규칙을 정의합니다 -->
1. {{FIELD_RULE_1}}
<!-- 예: "category는 반드시 critical, warning, info 중 하나여야 합니다" -->
2. {{FIELD_RULE_2}}
<!-- 예: "description은 50자 이내로 작성합니다" -->
3. {{FIELD_RULE_3}}
<!-- 예: "items는 category 기준 내림차순 (critical > warning > info)으로 정렬합니다" -->
{{?ADDITIONAL_FIELD_RULES}}

#### 출력 예시
```{{FORMAT_LANGUAGE}}
{{OUTPUT_EXAMPLE}}
```
<!-- 기대하는 출력의 구체적 예시 1개를 제공합니다 -->

### 주의사항
- 출력은 반드시 지정된 형식만 포함하세요 (설명 텍스트 없이 순수 데이터만)
<!-- 또는: "출력 전후에 간단한 설명을 추가해도 됩니다" -->
- {{?VALIDATION_RULE}}
<!-- 예: "JSON은 유효한 형식이어야 합니다 (파싱 가능)" -->
- {{?ENCODING_RULE}}
<!-- 예: "특수 문자는 이스케이프 처리하세요" -->
{{?ADDITIONAL_NOTES}}
```

## 품질 기준

- [ ] 스키마가 명확하게 정의되어 있어 모호함이 없는가?
- [ ] 출력 예시가 스키마를 정확히 따르는가?
- [ ] 필드 규칙(enum 값, 길이 제한, 정렬 순서 등)이 명시되었는가?
- [ ] 실제 출력이 지정된 형식으로 파싱 가능한가? (유효한 JSON/YAML/CSV)
- [ ] 응답에 불필요한 부가 텍스트가 섞여 있지 않은가?
- [ ] 엣지 케이스(빈 배열, null 값, 특수 문자)에 대한 처리가 정의되었는가?
- [ ] 출력 크기가 사용 목적에 적합한가? (너무 크거나 너무 작지 않은가?)
