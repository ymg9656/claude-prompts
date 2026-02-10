# 테스트 작성 패턴 가이드

<!-- 목적: 테스트 코드 작성 시 참고하는 패턴과 안티패턴 정리 -->
<!-- 대상: Test Runner Skill이 테스트 품질 점검 시 참조 -->
<!-- 최종 수정: 2024-06 -->

## 개요

이 문서는 테스트 코드의 품질을 보장하기 위한 패턴과 규칙을 정의합니다. Test Runner Skill의 워크플로우 5단계(품질 점검)에서 참조됩니다.

## 테스트 구조 패턴

### AAA 패턴 (Arrange-Act-Assert)

모든 테스트는 AAA 패턴을 따릅니다.

```typescript
describe('UserService', () => {
  it('유효한 이메일로 사용자를 생성한다', () => {
    // Arrange - 준비
    const userData = { email: 'test@example.com', name: '홍길동' };

    // Act - 실행
    const user = userService.create(userData);

    // Assert - 검증
    expect(user.email).toBe('test@example.com');
    expect(user.name).toBe('홍길동');
    expect(user.id).toBeDefined();
  });
});
```

### Given-When-Then 패턴 (BDD 스타일)

비즈니스 로직 테스트에 권장됩니다.

```typescript
describe('장바구니 할인 계산', () => {
  it('10만원 이상 구매 시 10% 할인이 적용된다', () => {
    // Given - 조건
    const cart = new Cart();
    cart.addItem({ price: 50000, quantity: 3 }); // 150,000원

    // When - 실행
    const total = cart.calculateTotal();

    // Then - 결과
    expect(total).toBe(135000); // 10% 할인 적용
  });
});
```

## 네이밍 규칙

### 테스트 파일명

| 프레임워크 | 파일명 패턴 | 예시 |
|-----------|------------|------|
| Jest/Vitest | `*.test.ts`, `*.spec.ts` | `user.service.test.ts` |
| Pytest | `test_*.py`, `*_test.py` | `test_user_service.py` |
| JUnit | `*Test.java` | `UserServiceTest.java` |
| Go | `*_test.go` | `user_service_test.go` |

### 테스트 케이스 이름

| 규칙 | 좋은 예 | 나쁜 예 |
|------|---------|---------|
| 행동을 서술 | `유효한 이메일로 사용자를 생성한다` | `test1` |
| 조건 명시 | `만료된 토큰으로 요청 시 401을 반환한다` | `토큰 테스트` |
| 기대 결과 포함 | `재고 부족 시 주문이 실패한다` | `재고 확인` |

## 테스트 유형별 가이드

### 단위 테스트 (Unit Test)

- 외부 의존성을 모두 Mock 처리
- 한 테스트에 하나의 행동만 검증
- 실행 시간 50ms 이하 권장

```typescript
// 좋은 예: 의존성 격리
it('비밀번호 해시를 생성한다', () => {
  const hash = passwordService.hash('password123');
  expect(hash).not.toBe('password123');
  expect(hash.length).toBeGreaterThan(50);
});

// 나쁜 예: DB에 의존
it('사용자를 저장한다', async () => {
  const user = await userService.save({ email: 'test@test.com' });
  // DB에 직접 접근 - 단위 테스트에 부적합
  const found = await db.query('SELECT * FROM users WHERE id = ?', user.id);
  expect(found).toBeDefined();
});
```

### 통합 테스트 (Integration Test)

- 실제 의존성(DB, API) 사용
- 주요 유스케이스 흐름 검증
- 테스트 데이터 정리(cleanup) 필수

```typescript
// 좋은 예: 전체 흐름 검증 + 정리
describe('주문 생성 플로우', () => {
  afterEach(async () => {
    await testDb.cleanup();
  });

  it('재고 차감 → 주문 생성 → 결제 처리가 순차적으로 수행된다', async () => {
    const order = await orderService.create(orderData);
    expect(order.status).toBe('PAID');

    const stock = await stockService.getStock(productId);
    expect(stock.quantity).toBe(initialQuantity - orderData.quantity);
  });
});
```

### E2E 테스트 (End-to-End Test)

- 사용자 시나리오 기반
- 최소한의 핵심 경로만 테스트
- 실행 시간이 길므로 CI에서 별도 단계로 실행

## 안티패턴

### 피해야 할 패턴

| 안티패턴 | 문제점 | 개선 방안 |
|---------|--------|-----------|
| 로직이 없는 테스트 | `expect(1+1).toBe(2)` — 의미 없음 | 실제 비즈니스 로직을 검증 |
| 과도한 Mock | 테스트 대상보다 Mock이 더 많음 | Mock은 외부 의존성에만 사용 |
| 테스트 간 의존성 | 테스트 A가 통과해야 B가 동작 | 각 테스트를 독립적으로 설계 |
| Magic Number | `expect(result).toBe(42)` | 상수에 의미 있는 이름 부여 |
| 느린 테스트 | 단위 테스트가 1초 이상 | 비동기/네트워크 의존 제거 |
| 실패 메시지 없음 | `expect(result).toBeTruthy()` | 커스텀 메시지 추가 또는 구체적 matcher 사용 |

## 커버리지 기준

| 영역 | 최소 커버리지 | 권장 커버리지 |
|------|-------------|-------------|
| 비즈니스 로직 (Service) | 80% | 90%+ |
| 컨트롤러/핸들러 | 70% | 80%+ |
| 유틸리티 함수 | 90% | 95%+ |
| 데이터 모델 | 50% | 70%+ |
| 전체 프로젝트 | 70% | 80%+ |

## 체크리스트

테스트 품질 점검 시 아래 항목을 확인합니다:

- [ ] 모든 테스트가 AAA 또는 Given-When-Then 패턴을 따르는가?
- [ ] 테스트 케이스 이름이 행동/조건/결과를 명확히 서술하는가?
- [ ] 외부 의존성이 적절히 Mock 처리되었는가?
- [ ] 각 테스트가 독립적으로 실행 가능한가?
- [ ] 에러/예외 케이스에 대한 테스트가 있는가?
- [ ] 테스트 데이터가 하드코딩 되지 않고 팩토리/빌더를 사용하는가?
- [ ] 커버리지가 영역별 최소 기준을 충족하는가?
