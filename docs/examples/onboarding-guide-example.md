# 온보딩 가이드 예시: DataPipe 팀 신규 개발자 온보딩

> 이 문서는 `doc-user-guide.md` 템플릿을 사용하여 생성된 완성 예시입니다.

---

# DataPipe 팀 신규 개발자 온보딩 가이드

## 소개

DataPipe 팀에 오신 것을 환영합니다. 이 가이드는 신규 개발자가 첫 주 안에 개발 환경을 설정하고, 코드베이스를 이해하며, 첫 번째 PR(Pull Request)을 제출할 수 있도록 안내합니다.

### 이 가이드에서 배울 수 있는 것

- DataPipe 프로젝트의 구조와 핵심 개념
- 로컬 개발 환경 설정
- 코드 작성, 테스트, 배포 워크플로우
- 팀의 협업 규칙과 문화

### 예상 소요 시간

| 단계 | 소요 시간 |
|------|-----------|
| 환경 설정 | 2~3시간 |
| 코드베이스 이해 | 3~4시간 |
| 첫 PR 제출 | 2~3시간 |
| **총 예상 시간** | **1~2일** |

### 사전 요구사항 체크리스트

시작하기 전에 다음을 확인하세요:

- [ ] 회사 이메일 계정이 활성화되었는가?
- [ ] GitHub 계정이 `datapipe-org` Organization에 초대되었는가?
- [ ] Slack `#datapipe-dev` 채널에 참여했는가?
- [ ] Jira 프로젝트(DPIPE) 접근 권한이 있는가?
- [ ] AWS SSO 계정이 생성되었는가?
- [ ] macOS 또는 Linux 개발 머신이 있는가?

> **참고:** 권한 관련 문제는 팀 리드(@이재현) 또는 DevOps 담당(@송민수)에게 문의하세요.

---

## 빠른 시작 (Quick Start)

5분 만에 로컬에서 DataPipe를 실행해 봅시다.

### 1단계: 저장소 클론

```bash
git clone git@github.com:datapipe-org/datapipe.git
cd datapipe
```

### 2단계: 도구 설치

```bash
# Homebrew (macOS)
brew install python@3.12 node@20 docker docker-compose

# pyenv로 Python 버전 관리 (권장)
brew install pyenv
pyenv install 3.12.2
pyenv local 3.12.2
```

### 3단계: 의존성 설치 및 실행

```bash
# Python 가상환경 생성 및 활성화
python -m venv .venv
source .venv/bin/activate

# 의존성 설치
pip install -r requirements.txt
pip install -r requirements-dev.txt

# 로컬 인프라 실행 (PostgreSQL, Redis, Kafka)
docker-compose up -d

# 데이터베이스 마이그레이션
python manage.py migrate

# 개발 서버 실행
python manage.py runserver
```

### 4단계: 동작 확인

```bash
# 헬스 체크
curl http://localhost:8000/health
# 예상 출력: {"status": "ok", "version": "2.4.1"}

# 파이프라인 목록 조회
curl http://localhost:8000/api/v1/pipelines
# 예상 출력: {"data": [], "pagination": {"total_count": 0}}
```

축하합니다. DataPipe가 로컬에서 실행되고 있습니다.

---

## 핵심 개념

DataPipe를 이해하기 위한 핵심 용어와 개념입니다.

### 파이프라인 (Pipeline)

데이터가 소스에서 목적지로 이동하는 전체 경로입니다. 하나의 파이프라인은 여러 개의 스텝으로 구성됩니다.

### 스텝 (Step)

파이프라인 내에서 데이터를 처리하는 개별 단위입니다. 추출(Extract), 변환(Transform), 적재(Load) 중 하나의 역할을 합니다.

### 커넥터 (Connector)

외부 데이터 소스/목적지와의 연결을 추상화합니다. PostgreSQL 커넥터, S3 커넥터, Kafka 커넥터 등이 있습니다.

### 스케줄 (Schedule)

파이프라인의 실행 주기를 정의합니다. Cron 표현식 또는 이벤트 기반 트리거를 지원합니다.

### 런 (Run)

파이프라인의 한 번 실행 인스턴스입니다. 성공, 실패, 진행 중 등의 상태를 가집니다.

### 개념 간 관계

```mermaid
graph LR
    P[Pipeline] --> S1[Step 1: Extract]
    P --> S2[Step 2: Transform]
    P --> S3[Step 3: Load]
    S1 --> C1[Connector: PostgreSQL]
    S3 --> C2[Connector: S3]
    P --> SCH[Schedule: 매일 02:00]
    SCH --> R1[Run #1: 성공]
    SCH --> R2[Run #2: 실패]
    SCH --> R3[Run #3: 진행 중]
```

---

## 프로젝트 구조

```
datapipe/
├── src/
│   ├── api/              # REST API 엔드포인트 (Django REST Framework)
│   │   ├── pipelines/    # 파이프라인 CRUD API
│   │   ├── connectors/   # 커넥터 관리 API
│   │   └── runs/         # 실행 이력 API
│   ├── core/             # 핵심 비즈니스 로직
│   │   ├── engine/       # 파이프라인 실행 엔진
│   │   ├── scheduler/    # 스케줄러
│   │   └── models/       # 도메인 모델
│   ├── connectors/       # 커넥터 구현체
│   │   ├── postgresql/
│   │   ├── s3/
│   │   ├── kafka/
│   │   └── base.py       # 커넥터 인터페이스
│   └── workers/          # Celery 워커 태스크
├── tests/
│   ├── unit/             # 단위 테스트
│   ├── integration/      # 통합 테스트
│   └── e2e/              # E2E 테스트
├── infra/
│   ├── docker/           # Docker 설정
│   ├── k8s/              # Kubernetes 매니페스트
│   └── terraform/        # 인프라 코드
├── docs/                 # 프로젝트 문서
├── scripts/              # 유틸리티 스크립트
├── manage.py
├── requirements.txt
├── requirements-dev.txt
├── pyproject.toml
└── docker-compose.yml
```

### 주요 파일 안내

| 파일/디렉토리 | 설명 | 언제 수정하는가? |
|-------------|------|----------------|
| `src/api/` | API 엔드포인트 | 새로운 API를 추가할 때 |
| `src/core/engine/` | 실행 엔진 | 파이프라인 실행 로직을 변경할 때 |
| `src/connectors/` | 커넥터 구현 | 새로운 데이터 소스를 지원할 때 |
| `src/core/models/` | 도메인 모델 | 데이터 모델을 변경할 때 |
| `tests/` | 테스트 코드 | 항상 (모든 코드 변경 시) |
| `infra/k8s/` | K8s 매니페스트 | 배포 설정을 변경할 때 |

---

## 개발 워크플로우

### 브랜치 전략

```
main (배포 가능 상태)
 └── develop (개발 통합)
      ├── feature/DPIPE-123-add-mysql-connector
      ├── feature/DPIPE-456-improve-scheduler
      └── fix/DPIPE-789-pipeline-timeout
```

**규칙:**
- `main`: 프로덕션 배포 브랜치. 직접 커밋 금지
- `develop`: 개발 통합 브랜치. PR을 통해서만 머지
- `feature/*`: 기능 개발 브랜치. Jira 티켓 번호 포함
- `fix/*`: 버그 수정 브랜치. Jira 티켓 번호 포함

### 코드 작성 -> PR -> 머지 흐름

#### 1. 브랜치 생성

```bash
git checkout develop
git pull origin develop
git checkout -b feature/DPIPE-123-add-mysql-connector
```

#### 2. 코드 작성

```bash
# 코드 작성 후 린팅 확인
ruff check src/
ruff format src/

# 타입 체크
mypy src/

# 테스트 실행
pytest tests/unit/ -v
pytest tests/integration/ -v  # Docker가 실행 중이어야 함
```

#### 3. 커밋

커밋 메시지 규칙 (Conventional Commits):

```
<type>(<scope>): <subject>

[본문]

[푸터]
```

**타입:**
| 타입 | 설명 | 예시 |
|------|------|------|
| `feat` | 새로운 기능 | `feat(connector): MySQL 커넥터 추가` |
| `fix` | 버그 수정 | `fix(scheduler): 크론 파싱 오류 수정` |
| `refactor` | 리팩토링 | `refactor(engine): 실행 엔진 추상화 개선` |
| `test` | 테스트 추가/수정 | `test(connector): PostgreSQL 커넥터 테스트 추가` |
| `docs` | 문서 변경 | `docs: API 레퍼런스 업데이트` |
| `chore` | 빌드/설정 변경 | `chore: Python 3.12.2로 업그레이드` |

```bash
git add src/connectors/mysql/
git commit -m "feat(connector): MySQL 커넥터 추가

- MySQL 5.7+ 및 8.x 지원
- 증분 추출(Incremental Extract) 지원
- 연결 풀링(Connection Pooling) 구현

Refs: DPIPE-123"
```

#### 4. PR 생성

```bash
git push origin feature/DPIPE-123-add-mysql-connector
```

GitHub에서 PR을 생성합니다:
- **제목**: `feat(connector): MySQL 커넥터 추가 [DPIPE-123]`
- **Reviewer**: 최소 2명 지정 (팀 리드 1명 포함)
- **Label**: `feature`, `connector`

#### 5. 코드 리뷰 대응

- 리뷰어 피드백에 대해 commit으로 수정 (force-push 금지)
- 논의가 필요한 부분은 PR 코멘트에서 토론
- 모든 리뷰 코멘트를 resolve한 후 다시 리뷰 요청

#### 6. 머지

- 리뷰 승인 2개 이상 + CI 통과 시 머지 가능
- Squash Merge 사용 (커밋 히스토리 정리)

---

## 테스트 가이드

### 테스트 실행 명령어

```bash
# 전체 테스트
pytest

# 단위 테스트만
pytest tests/unit/ -v

# 특정 모듈 테스트
pytest tests/unit/connectors/test_mysql.py -v

# 커버리지 리포트
pytest --cov=src --cov-report=html
open htmlcov/index.html
```

### 테스트 작성 규칙

- 모든 새 코드에는 단위 테스트 필수 (커버리지 80% 이상)
- 커넥터는 통합 테스트도 필수 (Docker 기반 실제 DB 연동)
- 테스트 파일명: `test_<모듈명>.py`
- 테스트 함수명: `test_<동작>_<조건>_<기대결과>`

```python
# 좋은 예시
def test_extract_returns_all_rows_when_no_filter():
    ...

def test_extract_raises_error_when_connection_fails():
    ...

# 나쁜 예시
def test_extract():  # 무엇을 테스트하는지 불분명
    ...
```

---

## 설정 레퍼런스

### 환경 변수

| 변수명 | 필수 | 기본값 | 설명 |
|--------|------|--------|------|
| `DATABASE_URL` | O | — | PostgreSQL 연결 URL |
| `REDIS_URL` | O | — | Redis 연결 URL |
| `KAFKA_BROKERS` | O | — | Kafka 브로커 주소 (쉼표 구분) |
| `SECRET_KEY` | O | — | Django Secret Key |
| `DEBUG` | X | `false` | 디버그 모드 활성화 |
| `LOG_LEVEL` | X | `INFO` | 로그 레벨 (DEBUG, INFO, WARNING, ERROR) |
| `WORKER_CONCURRENCY` | X | `4` | Celery 워커 동시 처리 수 |
| `AWS_REGION` | X | `ap-northeast-2` | AWS 리전 |
| `SENTRY_DSN` | X | — | Sentry 에러 트래킹 DSN |

### 로컬 개발용 `.env` 파일

```bash
# .env.local (Git에 커밋하지 않습니다)
DATABASE_URL=postgresql://datapipe:datapipe@localhost:5432/datapipe
REDIS_URL=redis://localhost:6379/0
KAFKA_BROKERS=localhost:9092
SECRET_KEY=local-dev-secret-key-change-in-production
DEBUG=true
LOG_LEVEL=DEBUG
```

---

## 문제 해결 (Troubleshooting)

### Docker Compose 실행 실패

**증상:** `docker-compose up -d` 실행 시 포트 충돌 에러

```
Error: Bind for 0.0.0.0:5432 failed: port is already allocated
```

**원인:** 로컬에 이미 PostgreSQL이 실행 중

**해결:**
```bash
# 기존 PostgreSQL 중지
brew services stop postgresql

# 또는 Docker Compose에서 포트 변경
# docker-compose.override.yml 파일 생성
```

```yaml
# docker-compose.override.yml
services:
  postgres:
    ports:
      - "5433:5432"
```

### 마이그레이션 에러

**증상:** `python manage.py migrate` 실행 시 에러

```
django.db.utils.OperationalError: could not connect to server
```

**원인:** PostgreSQL 컨테이너가 아직 준비되지 않음

**해결:**
```bash
# PostgreSQL 컨테이너 상태 확인
docker-compose ps

# 컨테이너가 healthy 상태가 될 때까지 대기 (약 10초)
docker-compose up -d postgres
sleep 10
python manage.py migrate
```

### 테스트 실행 시 Kafka 연결 에러

**증상:** 통합 테스트에서 Kafka 관련 에러

```
kafka.errors.NoBrokersAvailable: NoBrokersAvailable
```

**원인:** Kafka 컨테이너 시작에 시간이 필요 (약 30초)

**해결:**
```bash
# Kafka 브로커 상태 확인
docker-compose logs kafka | tail -20

# "started" 로그가 보이면 정상
# 안 보이면 재시작
docker-compose restart kafka
sleep 30
pytest tests/integration/ -v
```

### Python 버전 불일치

**증상:** 의존성 설치 시 호환성 에러

**원인:** Python 3.12가 아닌 다른 버전 사용 중

**해결:**
```bash
# 현재 Python 버전 확인
python --version

# pyenv로 올바른 버전 설정
pyenv install 3.12.2
pyenv local 3.12.2

# 가상환경 재생성
rm -rf .venv
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

---

## 유용한 명령어 모음

```bash
# 로컬 인프라 시작/중지
docker-compose up -d
docker-compose down

# DB 초기화 (개발용 시드 데이터 포함)
python manage.py flush
python manage.py loaddata fixtures/dev-seed.json

# Celery 워커 실행 (별도 터미널)
celery -A datapipe worker --loglevel=info

# Celery Beat (스케줄러) 실행 (별도 터미널)
celery -A datapipe beat --loglevel=info

# API 문서 확인 (Swagger)
open http://localhost:8000/docs/

# 코드 품질 검사 (CI와 동일)
ruff check src/ && ruff format --check src/ && mypy src/ && pytest
```

---

## 다음 단계

### 첫 주 목표

1. 이 온보딩 가이드를 완료하고 로컬 환경에서 DataPipe 실행
2. `good-first-issue` 라벨이 붙은 Jira 티켓 하나를 선택하여 PR 제출
3. 다른 팀원의 PR을 1개 이상 리뷰

### 첫 달 목표

1. 담당 도메인의 코드를 깊이 이해
2. 독립적으로 기능 개발 및 배포 수행
3. 온콜 로테이션에 참여 준비

### 추가 학습 리소스

| 리소스 | 설명 |
|--------|------|
| [DataPipe 아키텍처 문서](../examples/architecture-doc-example.md) | 전체 시스템 아키텍처 이해 |
| [API 레퍼런스](../examples/api-doc-example.md) | API 엔드포인트 상세 |
| [팀 위키 (Confluence)](https://wiki.example.com/datapipe) | 회의록, 설계 문서, ADR |
| [운영 런북](https://runbook.example.com/datapipe) | 장애 대응 매뉴얼 |

### 도움을 받을 수 있는 곳

| 채널 | 용도 |
|------|------|
| Slack `#datapipe-dev` | 기술 질문, 코드 리뷰 요청 |
| Slack `#datapipe-ops` | 배포, 인프라 관련 |
| 1:1 미팅 (팀 리드) | 매주 월요일 30분, 고민/어려움 상담 |
| 페어 프로그래밍 | 언제든 요청 가능 (Slack DM) |

> **참고:** 질문은 많을수록 좋습니다. "이런 것도 물어봐도 되나?"라는 생각이 든다면, 반드시 물어보세요. 팀 전체의 지식 공유에 기여하는 것이므로 적극 권장합니다.
