---
name: api-generator
description: OpenAPI 스펙을 기반으로 REST API 엔드포인트 코드를 자동 생성합니다.
---

# API Generator Skill

OpenAPI(Swagger) 스펙 또는 자연어 요구사항을 기반으로 REST API 엔드포인트의 컨트롤러, 서비스, DTO, 테스트 코드를 자동 생성하는 Skill입니다.

## 핵심 기능

- OpenAPI YAML/JSON 스펙 파싱 및 코드 생성
- 자연어 요구사항에서 API 스펙 자동 추출
- 컨트롤러, 서비스, DTO, 유효성 검증 코드 일괄 생성
- 기존 프로젝트의 코딩 컨벤션 자동 감지 및 적용
- 생성된 API에 대한 기본 테스트 코드 자동 생성

## 워크플로우

### 1. 프로젝트 구조 분석

기존 프로젝트의 구조와 컨벤션을 분석합니다.

```bash
# 프로젝트 디렉토리 구조 확인
find src -type f -name "*.ts" | head -30

# 기존 컨트롤러 패턴 확인
ls src/controllers/ 2>/dev/null || ls src/**/controller* 2>/dev/null
```

### 2. API 스펙 확인

OpenAPI 스펙 파일이 있으면 로드하고, 없으면 요구사항에서 생성합니다.

```bash
# 기존 API 스펙 확인
ls assets/api-template.yaml 2>/dev/null
cat assets/api-template.yaml 2>/dev/null
```

### 3. 코드 생성

API 스펙을 기반으로 필요한 파일들을 생성합니다.

```bash
# 생성할 파일 목록 확인
echo "생성 예정 파일:"
echo "  - src/controllers/{resource}.controller.ts"
echo "  - src/services/{resource}.service.ts"
echo "  - src/dto/{resource}.dto.ts"
echo "  - src/validators/{resource}.validator.ts"
echo "  - src/__tests__/{resource}.controller.test.ts"
```

### 4. 유효성 검증

생성된 코드의 타입 검사와 린트를 실행합니다.

```bash
# TypeScript 타입 검사
npx tsc --noEmit

# ESLint 검사
npx eslint src/controllers/ src/services/ src/dto/
```

### 5. 테스트 실행

생성된 API의 기본 테스트를 실행합니다.

```bash
# 생성된 테스트 실행
npm test -- --testPathPattern="__tests__/{resource}"
```

## 에러 처리

| 에러 | 원인 | 해결 |
|------|------|------|
| OpenAPI 스펙 파싱 실패 | YAML/JSON 문법 오류 | 스펙 파일의 문법을 검증하고 수정 |
| 타입 생성 실패 | 지원하지 않는 스키마 형식 | `$ref`, `allOf`, `oneOf` 등을 단순한 형태로 변환 |
| 파일 충돌 | 동일한 이름의 파일이 이미 존재 | `--overwrite` 플래그 사용 또는 파일명 변경 |
| 의존성 누락 | 필요한 라이브러리 미설치 | `npm install` 또는 필요 패키지 개별 설치 |
| 린트 오류 | 생성 코드가 프로젝트 린트 규칙 미준수 | 프로젝트 ESLint 설정에 맞춰 코드 스타일 조정 |

## 사용 예시

### 예시 1: 자연어에서 API 생성

```
사용자: "상품(Product) CRUD API 만들어줘. 이름, 가격, 카테고리 필드가 필요해."

→ Skill이 프로젝트 분석 후 다음 파일을 생성:

  1. src/dto/product.dto.ts
     - CreateProductDto { name: string, price: number, categoryId: string }
     - UpdateProductDto (Partial<CreateProductDto>)
     - ProductResponseDto

  2. src/controllers/product.controller.ts
     - GET    /products       → 목록 조회
     - GET    /products/:id   → 단건 조회
     - POST   /products       → 생성
     - PUT    /products/:id   → 수정
     - DELETE /products/:id   → 삭제

  3. src/services/product.service.ts
     - findAll(), findById(), create(), update(), delete()

  4. src/__tests__/product.controller.test.ts
     - 각 엔드포인트별 성공/실패 테스트
```

### 예시 2: OpenAPI 스펙에서 생성

```
사용자: "assets/api-template.yaml 기반으로 API 코드 생성해줘"

→ Skill이 YAML 파싱 후:
  "OpenAPI 3.0 스펙을 분석했습니다.

  감지된 리소스: 3개 (User, Product, Order)
  감지된 엔드포인트: 12개

  생성된 파일: 15개
  - 컨트롤러: 3개
  - 서비스: 3개
  - DTO: 6개
  - 테스트: 3개

  모든 파일 타입 검사 통과. 린트 오류 0건."
```

### 예시 3: 단일 엔드포인트 추가

```
사용자: "Product에 검색 API 추가해줘. 이름과 가격 범위로 필터링 가능하게."

→ Skill이 기존 코드 분석 후:
  "기존 ProductController에 검색 엔드포인트를 추가합니다.

  GET /products/search?name=키워드&minPrice=1000&maxPrice=50000

  변경 파일:
  - src/controllers/product.controller.ts (엔드포인트 추가)
  - src/dto/product.dto.ts (SearchProductDto 추가)
  - src/services/product.service.ts (search() 메서드 추가)
  - src/__tests__/product.controller.test.ts (검색 테스트 추가)"
```

## 리소스

- `assets/api-template.yaml` - OpenAPI 템플릿 파일
- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html) - OpenAPI 공식 스펙
- [Swagger Editor](https://editor.swagger.io/) - API 스펙 편집/검증 도구
