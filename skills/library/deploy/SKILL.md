---
name: deploy
description: 배포 파이프라인을 실행하고 환경별 배포 및 롤백을 지원합니다.
---

# Deploy Skill

프로젝트의 배포 환경을 자동 감지하고, 빌드 → 테스트 → 배포 파이프라인을 실행하는 Skill입니다. Docker, Kubernetes, 클라우드(AWS/GCP/Azure) 배포를 지원하며, 환경별(dev/staging/prod) 배포와 롤백 기능을 제공합니다.

## 핵심 기능

- 배포 환경 자동 감지 (Docker, Kubernetes, AWS, GCP, Azure, Vercel, Netlify 등)
- 환경별 배포 실행 (dev / staging / prod)
- 빌드 → 테스트 → 배포 파이프라인 순차 실행
- 배포 전 헬스체크 및 스모크 테스트
- 롤백 지원 (이전 버전으로 즉시 복구)
- 배포 이력 관리 및 변경 사항 요약

## 워크플로우

### 1. 배포 환경 감지

프로젝트의 배포 설정 파일을 분석하여 배포 방식을 결정합니다.

```bash
# 배포 관련 설정 파일 감지
ls Dockerfile docker-compose.yml k8s/ kubernetes/ \
   serverless.yml vercel.json netlify.toml \
   .github/workflows/ .gitlab-ci.yml \
   Procfile app.yaml 2>/dev/null

# package.json 배포 스크립트 확인
cat package.json | grep -A 10 '"scripts"' 2>/dev/null | grep -E "(deploy|build|start)"
```

### 2. 빌드

감지된 환경에 맞는 빌드를 실행합니다.

```bash
# Node.js 프로젝트
npm run build

# Docker 빌드
docker build -t {{PROJECT_NAME}}:{{VERSION}} .

# Go 프로젝트
go build -o bin/app ./cmd/server
```

### 3. 테스트 검증

배포 전 테스트를 실행하여 안정성을 확인합니다.

```bash
# 단위 테스트 실행
npm test

# 통합 테스트 실행
npm run test:integration

# Docker 이미지 테스트
docker run --rm {{PROJECT_NAME}}:{{VERSION}} npm test
```

### 4. 배포 실행

환경별 배포를 수행합니다.

```bash
# Docker 배포
docker push {{REGISTRY}}/{{PROJECT_NAME}}:{{VERSION}}

# Kubernetes 배포
kubectl set image deployment/{{DEPLOYMENT}} app={{REGISTRY}}/{{PROJECT_NAME}}:{{VERSION}} -n {{NAMESPACE}}
kubectl rollout status deployment/{{DEPLOYMENT}} -n {{NAMESPACE}}

# AWS ECS 배포
aws ecs update-service --cluster {{CLUSTER}} --service {{SERVICE}} --force-new-deployment

# Vercel 배포
vercel --prod

# Cloud Run 배포
gcloud run deploy {{SERVICE}} --image {{IMAGE}} --region {{REGION}}
```

### 5. 헬스체크 및 검증

배포 후 서비스 상태를 확인합니다.

```bash
# 헬스체크 엔드포인트 확인
curl -sf https://{{DEPLOY_URL}}/health || echo "헬스체크 실패"

# Kubernetes 파드 상태 확인
kubectl get pods -n {{NAMESPACE}} -l app={{APP_NAME}}

# 스모크 테스트 실행
npm run test:smoke -- --url={{DEPLOY_URL}}
```

### 6. 롤백 (필요 시)

배포 실패 또는 문제 발생 시 이전 버전으로 롤백합니다.

```bash
# Kubernetes 롤백
kubectl rollout undo deployment/{{DEPLOYMENT}} -n {{NAMESPACE}}

# Docker 이전 태그로 복원
docker pull {{REGISTRY}}/{{PROJECT_NAME}}:{{PREVIOUS_VERSION}}

# AWS ECS 이전 태스크 정의로 롤백
aws ecs update-service --cluster {{CLUSTER}} --service {{SERVICE}} --task-definition {{PREVIOUS_TASK_DEF}}
```

## 에러 처리

| 에러 | 원인 | 해결 |
|------|------|------|
| 빌드 실패 | 의존성 누락 또는 컴파일 오류 | 빌드 로그 확인 후 의존성 설치 또는 코드 수정 |
| 이미지 푸시 실패 | 레지스트리 인증 오류 | `docker login` 또는 클라우드 인증 갱신 |
| 배포 타임아웃 | 파드 시작 실패 또는 헬스체크 미통과 | 파드 로그 확인, 리소스 제한 조정, 헬스체크 경로 검증 |
| 롤백 실패 | 이전 버전 이미지 없음 | 이미지 태그 확인 후 수동 복구 |
| 환경 변수 누락 | 시크릿/설정 미등록 | 환경별 `.env` 파일 또는 시크릿 매니저 확인 |
| 포트 충돌 | 동일 포트 사용 중 | 기존 프로세스 종료 또는 포트 변경 |

## 사용 예시

### 예시 1: 스테이징 환경 배포

```
사용자: "스테이징에 배포해줘"

→ Skill이 환경 감지 후:
  "Docker + Kubernetes 환경을 감지했습니다.

  배포 파이프라인 실행:
  - 빌드 완료 (my-app:v1.2.3)
  - 테스트 통과 (48/48)
  - 이미지 푸시 완료
  - staging 네임스페이스에 배포 완료
  - 헬스체크 통과

  배포 URL: https://staging.example.com
  배포 시간: 2분 34초"
```

### 예시 2: 프로덕션 배포 (승인 포함)

```
사용자: "프로덕션 배포 진행해줘"

→ Skill이 프로덕션 배포 전 확인:
  "프로덕션 배포를 준비합니다.

  변경 사항 요약:
  - feat: 사용자 프로필 이미지 업로드 (v1.2.3)
  - fix: 장바구니 수량 계산 오류 수정 (v1.2.2)

  스테이징 검증 상태: 통과

  ⚠️ 프로덕션 배포를 진행하시겠습니까? (yes/no)"
```

### 예시 3: 롤백 실행

```
사용자: "배포 롤백해줘"

→ Skill이 배포 이력 확인 후:
  "현재 버전: v1.2.3 (30분 전 배포)
  이전 버전: v1.2.2

  롤백 실행 중...
  - v1.2.2로 롤백 완료
  - 헬스체크 통과

  롤백 완료. 서비스가 v1.2.2로 복원되었습니다."
```

## 리소스

- [Kubernetes 배포 전략](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) - 롤링 업데이트, 블루/그린 배포
- [Docker 공식 문서](https://docs.docker.com/) - 컨테이너 빌드 및 배포
- [AWS ECS 배포 가이드](https://docs.aws.amazon.com/ecs/) - AWS 컨테이너 서비스
- [Vercel 배포 문서](https://vercel.com/docs) - 프론트엔드 배포 플랫폼
