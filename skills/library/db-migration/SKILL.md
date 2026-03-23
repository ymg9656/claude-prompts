---
name: db-migration
description: DB 스키마 변경 마이그레이션 파일을 생성하고 실행하며 롤백 안전성을 검증합니다.
---

# DB Migration Skill

데이터베이스 스키마 변경을 위한 마이그레이션 파일을 생성하고 실행하는 Skill입니다. 프로젝트에서 사용 중인 ORM/마이그레이션 도구를 자동 감지하고, 변경사항을 안전하게 적용하며 롤백 가능 여부를 검증합니다.

## 핵심 기능

- ORM/마이그레이션 도구 자동 감지 (Prisma, TypeORM, Sequelize, Alembic, Flyway, Liquibase, Knex 등)
- 스키마 변경 기반 마이그레이션 파일 자동 생성
- 마이그레이션 실행 및 상태 관리
- 롤백 안전성 검증 (되돌릴 수 없는 변경 경고)
- 마이그레이션 충돌 감지 및 해결
- 데이터 손실 가능성 사전 경고

## 워크플로우

### 1. ORM/도구 감지

프로젝트에서 사용 중인 마이그레이션 도구를 자동으로 감지합니다.

```bash
# ORM/마이그레이션 도구 설정 파일 감지
ls prisma/schema.prisma \
   ormconfig.ts ormconfig.json \
   alembic.ini alembic/ \
   flyway.conf \
   liquibase.properties \
   knexfile.js knexfile.ts \
   sequelize.config.js \
   2>/dev/null

# 의존성에서 ORM 확인 (Node.js)
cat package.json | grep -E "(prisma|typeorm|sequelize|knex)" 2>/dev/null

# Python ORM 확인
cat requirements.txt | grep -E "(alembic|sqlalchemy|django)" 2>/dev/null
```

### 2. 현재 마이그레이션 상태 확인

적용된 마이그레이션과 대기 중인 마이그레이션을 확인합니다.

```bash
# Prisma
npx prisma migrate status

# TypeORM
npx typeorm migration:show

# Alembic
alembic current
alembic history

# Flyway
flyway info

# Knex
npx knex migrate:status
```

### 3. 마이그레이션 파일 생성

스키마 변경사항을 기반으로 마이그레이션 파일을 생성합니다.

```bash
# Prisma (schema.prisma 수정 후)
npx prisma migrate dev --name {{MIGRATION_NAME}}

# TypeORM
npx typeorm migration:generate -n {{MIGRATION_NAME}}

# Alembic
alembic revision --autogenerate -m "{{MIGRATION_NAME}}"

# Flyway (SQL 파일 직접 생성)
touch sql/V{{VERSION}}__{{MIGRATION_NAME}}.sql

# Knex
npx knex migrate:make {{MIGRATION_NAME}}
```

### 4. 롤백 안전성 검증

생성된 마이그레이션의 롤백 가능 여부를 검증합니다.

```bash
# 마이그레이션 파일 내용 확인
cat migrations/{{MIGRATION_FILE}}

# 위험한 변경사항 검출
# - DROP TABLE / DROP COLUMN → 데이터 손실
# - 컬럼 타입 변경 → 데이터 변환 실패 가능
# - NOT NULL 추가 (기본값 없음) → 기존 데이터 오류
```

#### 롤백 안전성 체크리스트

| 변경 유형 | 위험도 | 롤백 가능 | 주의사항 |
|-----------|--------|-----------|----------|
| CREATE TABLE | 낮음 | 가능 | DROP TABLE로 롤백 |
| ADD COLUMN (nullable) | 낮음 | 가능 | DROP COLUMN으로 롤백 |
| ADD COLUMN (NOT NULL) | 중간 | 주의 | 기본값 필수, 기존 데이터 확인 |
| DROP COLUMN | 높음 | 불가 | 데이터 백업 필수 |
| DROP TABLE | 높음 | 불가 | 데이터 백업 필수 |
| RENAME COLUMN | 중간 | 가능 | 애플리케이션 코드 동기화 필요 |
| ALTER TYPE | 중간 | 주의 | 데이터 변환 실패 가능성 |

### 5. 마이그레이션 실행

검증이 완료된 마이그레이션을 실행합니다.

```bash
# Prisma
npx prisma migrate deploy

# TypeORM
npx typeorm migration:run

# Alembic
alembic upgrade head

# Flyway
flyway migrate

# Knex
npx knex migrate:latest
```

### 6. 롤백 실행 (필요 시)

문제 발생 시 마이그레이션을 롤백합니다.

```bash
# Prisma (수동 SQL 롤백 필요)
npx prisma migrate resolve --rolled-back {{MIGRATION_NAME}}

# TypeORM
npx typeorm migration:revert

# Alembic
alembic downgrade -1

# Flyway
flyway undo

# Knex
npx knex migrate:rollback
```

## 에러 처리

| 에러 | 원인 | 해결 |
|------|------|------|
| 마이그레이션 충돌 | 여러 브랜치에서 동시에 마이그레이션 생성 | 마이그레이션 순서 조정 후 재생성 |
| 롤백 불가 | `down` 함수 미정의 또는 데이터 손실 변경 | 수동 롤백 SQL 작성 |
| 스키마 동기화 오류 | 마이그레이션과 실제 DB 스키마 불일치 | `prisma db pull` 또는 스키마 재동기화 |
| 데이터 손실 경고 | DROP 또는 타입 변경 포함 | 데이터 백업 후 진행 또는 안전한 대안 사용 |
| 연결 오류 | DB 접속 정보 오류 | `.env`의 DATABASE_URL 확인 |
| 타임아웃 | 대용량 테이블 마이그레이션 | 배치 처리 또는 온라인 DDL 사용 |

## 사용 예시

### 예시 1: 새 테이블 마이그레이션 생성

```
사용자: "주문(Order) 테이블 추가하는 마이그레이션 만들어줘"

→ Skill이 ORM 감지 후:
  "Prisma ORM을 감지했습니다.

  schema.prisma에 Order 모델을 추가합니다:
  - id (UUID, PK)
  - userId (FK → User)
  - totalAmount (Decimal)
  - status (Enum: PENDING, CONFIRMED, SHIPPED, DELIVERED)
  - createdAt, updatedAt

  마이그레이션 생성 완료:
  prisma/migrations/20260323_add_order_table/migration.sql

  롤백 안전성: 안전 (CREATE TABLE → DROP TABLE로 롤백 가능)"
```

### 예시 2: 위험한 변경 경고

```
사용자: "User 테이블에서 email 컬럼 삭제해줘"

→ Skill이 변경사항 분석 후:
  "위험한 변경이 감지되었습니다.

  DROP COLUMN: users.email
  - 위험도: 높음
  - 롤백: 불가능 (데이터 손실)
  - 영향 범위: 23개 파일에서 email 필드 참조 중

  권장 절차:
  1. email 데이터 백업
  2. 참조하는 코드 먼저 수정
  3. email 컬럼을 nullable로 변경 (중간 단계)
  4. 충분한 검증 후 컬럼 삭제

  진행하시겠습니까?"
```

### 예시 3: 마이그레이션 상태 확인

```
사용자: "마이그레이션 상태 확인해줘"

→ Skill이 상태 조회 후:
  "Alembic 마이그레이션 상태:

  적용 완료: 12개
  대기 중: 2개
  - a3f2b1c: add_order_table (대기)
  - d7e4a9f: add_payment_columns (대기)

  마지막 적용: 2026-03-20 14:30 (add_user_profile)

  대기 중인 마이그레이션을 실행하시겠습니까?"
```

## 리소스

- [Prisma Migrate](https://www.prisma.io/docs/concepts/components/prisma-migrate) - Prisma 마이그레이션 가이드
- [Alembic Tutorial](https://alembic.sqlalchemy.org/en/latest/tutorial.html) - Alembic 마이그레이션 튜토리얼
- [Flyway 공식 문서](https://flywaydb.org/documentation/) - Flyway 마이그레이션 도구
- [TypeORM Migrations](https://typeorm.io/migrations) - TypeORM 마이그레이션 가이드
