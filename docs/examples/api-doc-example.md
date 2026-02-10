# API 문서 예시: TaskFlow 작업 관리 API

> 이 문서는 `doc-api-reference.md` 템플릿을 사용하여 생성된 완성 예시입니다.

---

# TaskFlow API Reference v2.1

## 개요

TaskFlow API는 작업(Task) 생성, 조회, 수정, 삭제 및 팀 협업 기능을 제공하는 RESTful API입니다.

- **기본 URL**: `https://api.taskflow.io/v2`
- **프로토콜**: HTTPS만 지원
- **데이터 형식**: JSON (Content-Type: application/json)
- **문자 인코딩**: UTF-8

## 인증 (Authentication)

TaskFlow API는 Bearer Token 방식의 인증을 사용합니다.

### 토큰 발급

```bash
curl -X POST https://api.taskflow.io/v2/auth/token \
  -H "Content-Type: application/json" \
  -d '{
    "client_id": "your_client_id",
    "client_secret": "your_client_secret",
    "grant_type": "client_credentials"
  }'
```

**응답:**
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "dGhpcyBpcyBhIHJlZnJlc2ggdG9rZW4..."
}
```

### 토큰 사용

모든 API 요청의 `Authorization` 헤더에 토큰을 포함합니다:

```
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 토큰 갱신

```bash
curl -X POST https://api.taskflow.io/v2/auth/token \
  -H "Content-Type: application/json" \
  -d '{
    "grant_type": "refresh_token",
    "refresh_token": "dGhpcyBpcyBhIHJlZnJlc2ggdG9rZW4..."
  }'
```

## 공통 사항

### 에러 형식

모든 에러 응답은 다음 형식을 따릅니다:

```json
{
  "error": {
    "code": "TASK_NOT_FOUND",
    "message": "요청한 작업을 찾을 수 없습니다.",
    "details": [
      {
        "field": "task_id",
        "reason": "존재하지 않는 ID입니다."
      }
    ],
    "request_id": "req_abc123def456"
  }
}
```

### 공통 에러 코드

| HTTP 상태 | 에러 코드 | 설명 |
|-----------|----------|------|
| 400 | `INVALID_REQUEST` | 요청 형식이 올바르지 않음 |
| 401 | `UNAUTHORIZED` | 인증 토큰이 없거나 만료됨 |
| 403 | `FORBIDDEN` | 해당 리소스에 대한 권한이 없음 |
| 404 | `NOT_FOUND` | 요청한 리소스를 찾을 수 없음 |
| 409 | `CONFLICT` | 리소스 상태 충돌 (동시 수정 등) |
| 429 | `RATE_LIMITED` | 요청 한도 초과 |
| 500 | `INTERNAL_ERROR` | 서버 내부 오류 |

### Rate Limiting

| 플랜 | 요청 한도 | 윈도우 |
|------|----------|--------|
| Free | 100 요청 | 1분 |
| Pro | 1,000 요청 | 1분 |
| Enterprise | 10,000 요청 | 1분 |

Rate Limit 관련 헤더:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 742
X-RateLimit-Reset: 1709251200
```

### 페이지네이션

목록 API는 커서 기반 페이지네이션을 사용합니다.

**요청 파라미터:**
| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `limit` | integer | 20 | 페이지당 항목 수 (최대 100) |
| `cursor` | string | — | 다음 페이지 커서 |

**응답 형식:**
```json
{
  "data": [...],
  "pagination": {
    "has_more": true,
    "next_cursor": "eyJpZCI6MTAwfQ==",
    "total_count": 247
  }
}
```

---

## 엔드포인트

### 작업 (Tasks)

#### POST /tasks

새로운 작업을 생성합니다.

**인증:** 필수 (Bearer Token)
**권한:** `tasks:write`

**Request Body:**

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| `title` | string | O | 작업 제목 (최대 200자) |
| `description` | string | X | 작업 상세 설명 (최대 5,000자) |
| `assignee_id` | string | X | 담당자 ID |
| `project_id` | string | O | 프로젝트 ID |
| `priority` | string | X | 우선순위: `low`, `medium`, `high`, `critical` (기본값: `medium`) |
| `due_date` | string | X | 마감일 (ISO 8601 형식: `2025-03-15T09:00:00Z`) |
| `labels` | string[] | X | 라벨 목록 (최대 10개) |
| `parent_task_id` | string | X | 상위 작업 ID (하위 작업 생성 시) |

**요청 예시:**
```bash
curl -X POST https://api.taskflow.io/v2/tasks \
  -H "Authorization: Bearer eyJhbGciOi..." \
  -H "Content-Type: application/json" \
  -d '{
    "title": "사용자 인증 모듈 리팩토링",
    "description": "기존 세션 기반 인증을 JWT 기반으로 전환합니다.",
    "assignee_id": "user_k8x9m2n",
    "project_id": "proj_backend_auth",
    "priority": "high",
    "due_date": "2025-04-01T18:00:00Z",
    "labels": ["backend", "security", "refactoring"]
  }'
```

**성공 응답 (201 Created):**
```json
{
  "data": {
    "id": "task_a1b2c3d4",
    "title": "사용자 인증 모듈 리팩토링",
    "description": "기존 세션 기반 인증을 JWT 기반으로 전환합니다.",
    "status": "open",
    "priority": "high",
    "assignee": {
      "id": "user_k8x9m2n",
      "name": "김서연",
      "email": "seoyeon@example.com"
    },
    "project_id": "proj_backend_auth",
    "labels": ["backend", "security", "refactoring"],
    "due_date": "2025-04-01T18:00:00Z",
    "parent_task_id": null,
    "subtask_count": 0,
    "comment_count": 0,
    "created_at": "2025-03-01T10:30:00Z",
    "updated_at": "2025-03-01T10:30:00Z",
    "created_by": {
      "id": "user_p3q4r5s",
      "name": "박지훈"
    }
  }
}
```

**에러 응답:**

400 Bad Request:
```json
{
  "error": {
    "code": "INVALID_REQUEST",
    "message": "요청 본문이 올바르지 않습니다.",
    "details": [
      {
        "field": "title",
        "reason": "title은 필수 항목입니다."
      }
    ],
    "request_id": "req_x1y2z3"
  }
}
```

403 Forbidden:
```json
{
  "error": {
    "code": "FORBIDDEN",
    "message": "해당 프로젝트에 작업을 생성할 권한이 없습니다.",
    "request_id": "req_x1y2z3"
  }
}
```

**JavaScript 예시:**
```javascript
const response = await fetch("https://api.taskflow.io/v2/tasks", {
  method: "POST",
  headers: {
    "Authorization": "Bearer eyJhbGciOi...",
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    title: "사용자 인증 모듈 리팩토링",
    description: "기존 세션 기반 인증을 JWT 기반으로 전환합니다.",
    assignee_id: "user_k8x9m2n",
    project_id: "proj_backend_auth",
    priority: "high",
    due_date: "2025-04-01T18:00:00Z",
    labels: ["backend", "security", "refactoring"],
  }),
});

const result = await response.json();
console.log(result.data.id); // "task_a1b2c3d4"
```

**Python 예시:**
```python
import requests

response = requests.post(
    "https://api.taskflow.io/v2/tasks",
    headers={
        "Authorization": "Bearer eyJhbGciOi...",
        "Content-Type": "application/json",
    },
    json={
        "title": "사용자 인증 모듈 리팩토링",
        "description": "기존 세션 기반 인증을 JWT 기반으로 전환합니다.",
        "assignee_id": "user_k8x9m2n",
        "project_id": "proj_backend_auth",
        "priority": "high",
        "due_date": "2025-04-01T18:00:00Z",
        "labels": ["backend", "security", "refactoring"],
    },
)

result = response.json()
print(result["data"]["id"])  # "task_a1b2c3d4"
```

---

#### GET /tasks

작업 목록을 조회합니다.

**인증:** 필수 (Bearer Token)
**권한:** `tasks:read`

**Query 파라미터:**

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|----------|------|------|--------|------|
| `project_id` | string | O | — | 프로젝트 ID |
| `status` | string | X | — | 상태 필터: `open`, `in_progress`, `done`, `closed` |
| `assignee_id` | string | X | — | 담당자 ID로 필터 |
| `priority` | string | X | — | 우선순위 필터 |
| `label` | string | X | — | 라벨로 필터 (복수 가능: `label=backend&label=security`) |
| `search` | string | X | — | 제목/설명 전문 검색 |
| `sort` | string | X | `created_at` | 정렬 기준: `created_at`, `updated_at`, `due_date`, `priority` |
| `order` | string | X | `desc` | 정렬 방향: `asc`, `desc` |
| `limit` | integer | X | 20 | 페이지 크기 (최대 100) |
| `cursor` | string | X | — | 페이지네이션 커서 |

**요청 예시:**
```bash
curl -X GET "https://api.taskflow.io/v2/tasks?project_id=proj_backend_auth&status=open&priority=high&sort=due_date&order=asc&limit=10" \
  -H "Authorization: Bearer eyJhbGciOi..."
```

**성공 응답 (200 OK):**
```json
{
  "data": [
    {
      "id": "task_a1b2c3d4",
      "title": "사용자 인증 모듈 리팩토링",
      "status": "open",
      "priority": "high",
      "assignee": {
        "id": "user_k8x9m2n",
        "name": "김서연"
      },
      "due_date": "2025-04-01T18:00:00Z",
      "labels": ["backend", "security", "refactoring"],
      "subtask_count": 3,
      "comment_count": 5,
      "created_at": "2025-03-01T10:30:00Z",
      "updated_at": "2025-03-10T14:20:00Z"
    }
  ],
  "pagination": {
    "has_more": true,
    "next_cursor": "eyJpZCI6ImRlZiJ9",
    "total_count": 42
  }
}
```

---

#### GET /tasks/{task_id}

특정 작업의 상세 정보를 조회합니다.

**인증:** 필수 (Bearer Token)
**권한:** `tasks:read`

**Path 파라미터:**

| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| `task_id` | string | O | 작업 ID |

**요청 예시:**
```bash
curl -X GET https://api.taskflow.io/v2/tasks/task_a1b2c3d4 \
  -H "Authorization: Bearer eyJhbGciOi..."
```

**성공 응답 (200 OK):**
```json
{
  "data": {
    "id": "task_a1b2c3d4",
    "title": "사용자 인증 모듈 리팩토링",
    "description": "기존 세션 기반 인증을 JWT 기반으로 전환합니다.",
    "status": "open",
    "priority": "high",
    "assignee": {
      "id": "user_k8x9m2n",
      "name": "김서연",
      "email": "seoyeon@example.com"
    },
    "project_id": "proj_backend_auth",
    "labels": ["backend", "security", "refactoring"],
    "due_date": "2025-04-01T18:00:00Z",
    "parent_task_id": null,
    "subtasks": [
      {
        "id": "task_e5f6g7h8",
        "title": "JWT 라이브러리 선정",
        "status": "done"
      },
      {
        "id": "task_i9j0k1l2",
        "title": "토큰 발급/검증 로직 구현",
        "status": "in_progress"
      },
      {
        "id": "task_m3n4o5p6",
        "title": "기존 세션 마이그레이션",
        "status": "open"
      }
    ],
    "comment_count": 5,
    "attachment_count": 2,
    "created_at": "2025-03-01T10:30:00Z",
    "updated_at": "2025-03-10T14:20:00Z",
    "created_by": {
      "id": "user_p3q4r5s",
      "name": "박지훈"
    }
  }
}
```

**에러 응답:**

404 Not Found:
```json
{
  "error": {
    "code": "TASK_NOT_FOUND",
    "message": "요청한 작업을 찾을 수 없습니다.",
    "details": [
      {
        "field": "task_id",
        "reason": "task_a1b2c3d4 ID에 해당하는 작업이 존재하지 않습니다."
      }
    ],
    "request_id": "req_m4n5o6"
  }
}
```

---

#### PATCH /tasks/{task_id}

작업 정보를 수정합니다.

**인증:** 필수 (Bearer Token)
**권한:** `tasks:write`

**Path 파라미터:**

| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| `task_id` | string | O | 작업 ID |

**Request Body (변경할 필드만 포함):**

| 필드 | 타입 | 설명 |
|------|------|------|
| `title` | string | 작업 제목 |
| `description` | string | 작업 설명 |
| `status` | string | 상태: `open`, `in_progress`, `done`, `closed` |
| `priority` | string | 우선순위: `low`, `medium`, `high`, `critical` |
| `assignee_id` | string | 담당자 ID (null로 설정하면 담당자 해제) |
| `due_date` | string | 마감일 (ISO 8601) |
| `labels` | string[] | 라벨 목록 (전체 교체) |

**요청 예시:**
```bash
curl -X PATCH https://api.taskflow.io/v2/tasks/task_a1b2c3d4 \
  -H "Authorization: Bearer eyJhbGciOi..." \
  -H "Content-Type: application/json" \
  -d '{
    "status": "in_progress",
    "priority": "critical"
  }'
```

**성공 응답 (200 OK):**
```json
{
  "data": {
    "id": "task_a1b2c3d4",
    "title": "사용자 인증 모듈 리팩토링",
    "status": "in_progress",
    "priority": "critical",
    "updated_at": "2025-03-11T09:15:00Z"
  }
}
```

---

#### DELETE /tasks/{task_id}

작업을 삭제합니다. 하위 작업이 있는 경우 함께 삭제됩니다.

**인증:** 필수 (Bearer Token)
**권한:** `tasks:delete`

**Path 파라미터:**

| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| `task_id` | string | O | 작업 ID |

**요청 예시:**
```bash
curl -X DELETE https://api.taskflow.io/v2/tasks/task_a1b2c3d4 \
  -H "Authorization: Bearer eyJhbGciOi..."
```

**성공 응답 (204 No Content):**
응답 본문 없음

**에러 응답:**

404 Not Found:
```json
{
  "error": {
    "code": "TASK_NOT_FOUND",
    "message": "삭제할 작업을 찾을 수 없습니다.",
    "request_id": "req_q7r8s9"
  }
}
```

---

### 댓글 (Comments)

#### POST /tasks/{task_id}/comments

작업에 댓글을 추가합니다.

**인증:** 필수 (Bearer Token)
**권한:** `comments:write`

**Path 파라미터:**

| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| `task_id` | string | O | 작업 ID |

**Request Body:**

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| `content` | string | O | 댓글 내용 (Markdown 지원, 최대 10,000자) |
| `mentions` | string[] | X | 멘션할 사용자 ID 목록 |

**요청 예시:**
```bash
curl -X POST https://api.taskflow.io/v2/tasks/task_a1b2c3d4/comments \
  -H "Authorization: Bearer eyJhbGciOi..." \
  -H "Content-Type: application/json" \
  -d '{
    "content": "JWT 라이브러리 비교 결과 `jose` 라이브러리가 가장 적합합니다.\n\n- 번들 크기: 8KB\n- TypeScript 지원\n- 활발한 유지보수",
    "mentions": ["user_k8x9m2n"]
  }'
```

**성공 응답 (201 Created):**
```json
{
  "data": {
    "id": "comment_t1u2v3w4",
    "content": "JWT 라이브러리 비교 결과 `jose` 라이브러리가 가장 적합합니다.\n\n- 번들 크기: 8KB\n- TypeScript 지원\n- 활발한 유지보수",
    "author": {
      "id": "user_p3q4r5s",
      "name": "박지훈"
    },
    "mentions": [
      {
        "id": "user_k8x9m2n",
        "name": "김서연"
      }
    ],
    "created_at": "2025-03-11T10:00:00Z",
    "updated_at": "2025-03-11T10:00:00Z"
  }
}
```

---

## 변경 이력 (Changelog)

| 버전 | 날짜 | 변경 내용 |
|------|------|-----------|
| v2.1 | 2025-03-01 | 댓글 API에 `mentions` 필드 추가 |
| v2.0 | 2025-01-15 | 커서 기반 페이지네이션으로 전환, 에러 응답 형식 통일 |
| v1.0 | 2024-09-01 | 최초 릴리스 |
