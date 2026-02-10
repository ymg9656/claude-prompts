# 플레이스홀더 규칙

템플릿에서 사용하는 플레이스홀더 작성 표준입니다.

---

## 기본 규칙

### 필수 입력
```
{{FIELD_NAME}}
```
- 반드시 채워야 하는 항목
- 대문자 스네이크 케이스
- 비워두면 프롬프트가 동작하지 않음

### 선택 입력
```
{{?FIELD_NAME}}
```
- 물음표(`?`) 접두사
- 생략 가능한 항목
- 생략 시 해당 섹션 전체를 제거

### 작성 가이드 주석
```html
<!-- 이 항목에 대한 작성 가이드를 여기에 적습니다 -->
```
- HTML 주석 형식
- 플레이스홀더 바로 위 또는 아래에 배치
- 사용자가 채운 후에는 삭제

---

## 네이밍 컨벤션

### 일반 규칙
| 규칙 | 올바른 예 | 잘못된 예 |
|------|-----------|-----------|
| 대문자 스네이크 케이스 | `{{PROJECT_NAME}}` | `{{projectName}}` |
| 영어만 사용 | `{{TECH_STACK}}` | `{{기술스택}}` |
| 축약어 지양 | `{{DESCRIPTION}}` | `{{DESC}}` |
| 의미가 명확해야 함 | `{{TARGET_LANGUAGE}}` | `{{LANG}}` |

### 접두사 규칙
| 접두사 | 용도 | 예시 |
|--------|------|------|
| (없음) | 일반 필수 | `{{PROJECT_NAME}}` |
| `?` | 선택 | `{{?ADDITIONAL_CONTEXT}}` |
| `LIST_` | 목록형 입력 | `{{LIST_REQUIREMENTS}}` |
| `CODE_` | 코드 블록 | `{{CODE_EXAMPLE}}` |
| `FILE_` | 파일 내용 | `{{FILE_CONFIG}}` |

---

## 카테고리별 표준 플레이스홀더

### 공통
| 플레이스홀더 | 설명 | 예시 값 |
|-------------|------|---------|
| `{{PROJECT_NAME}}` | 프로젝트 이름 | `kandle-auth` |
| `{{TECH_STACK}}` | 기술 스택 | `Spring Boot, Keycloak, PostgreSQL` |
| `{{ROLE}}` | 수행 역할 | `시니어 백엔드 개발자` |
| `{{?ADDITIONAL_CONTEXT}}` | 추가 컨텍스트 | 프로젝트 특이사항 |

### Agent 전용
| 플레이스홀더 | 설명 |
|-------------|------|
| `{{AGENT_NAME}}` | Agent 이름 |
| `{{AGENT_ROLE}}` | Agent 역할 정의 |
| `{{AGENT_TOOLS}}` | 사용 가능한 도구 목록 |
| `{{AGENT_CONSTRAINTS}}` | Agent 행동 제약 |

### Skill 전용
| 플레이스홀더 | 설명 |
|-------------|------|
| `{{SKILL_NAME}}` | Skill 이름 |
| `{{SKILL_TRIGGERS}}` | 트리거 문구 목록 |
| `{{SKILL_WORKFLOW}}` | 워크플로우 단계 |
| `{{?SKILL_SCRIPTS}}` | 포함 스크립트 |

### Team 전용
| 플레이스홀더 | 설명 |
|-------------|------|
| `{{TEAM_NAME}}` | Team 이름 |
| `{{TEAM_DESCRIPTION}}` | Team 설명 |
| `{{TEAM_MEMBERS}}` | 멤버 구성 |
| `{{TEAM_WORKFLOW}}` | 팀 워크플로우 |

---

## 사용 예시

### 템플릿 원본
```markdown
당신은 {{ROLE}}입니다.
{{PROJECT_NAME}} 프로젝트의 {{?ADDITIONAL_CONTEXT}}를 고려하여
다음 작업을 수행하세요:

{{TASK_DESCRIPTION}}
```

### 채운 결과
```markdown
당신은 시니어 백엔드 개발자입니다.
kandle-auth 프로젝트의 Keycloak SPI 커스터마이징 요구사항을 고려하여
다음 작업을 수행하세요:

사용자 인증 플로우를 분석하고 개선점을 제안하세요.
```
