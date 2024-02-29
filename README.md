<img width="1570" alt="스크린샷 2024-02-28 오후 3 23 23" src="https://github.com/umaKim/GithubUserSearchApp/assets/85341050/d907b691-a6f2-4851-a274-156c4403ecde">

<img width="1570" alt="스크린샷 2024-02-28 오후 3 23 14" src="https://github.com/umaKim/GithubUserSearchApp/assets/85341050/dab71191-bb0f-42d5-8352-bd4ea0b50de2">

Architecture: MVVM-C

### 문제 해결 1. 확장 가능한 기능 설계
화면 추가의 유연성을 고려하여 직접 제작한 `CellableViewControllerDatasource`를 사용했습니다. `ViewControllerContainerCoordinator` 내 `setChildCoordinators` 메소드를 통해 새로운 기능을 손쉽게 추가할 수 있는 구조를 설계했습니다. 각 기능 간의 직접적인 의존성을 제거하기 위해 Coordinator 패턴을 적용, 화면 간의 라우팅을 가능하게 함으로써 각 기능이 서로를 몰라도 되게 하여 모듈화를 용이하게 했습니다. 또한, Coordinator를 통한 화면 전환 기능을 보여주기 위해 선택된 사용자의 GitHub 페이지를 Safari 서비스를 통해 보여주는 기능을 추가했습니다.

### 문제 해결 2. 효율적인 페이지네이션
API를 통해 데이터를 가져오는 기능의 ViewModel은 페이지네이션 로직을 포함해야 합니다. 이를 위해 `Paginator`를 도입하여 페이지네이션과 관련된 비즈니스 로직을 분리시켜 ViewModel의 부담을 줄였습니다. 이로 인해 ViewModel은 페이지네이션과 관련된 변수를 관리할 필요가 없어지며, Paginator의 재사용성이 향상되었습니다.

### 문제 해결 3. 테스트 용이성 증대
테스트 용이성을 높이기 위해 의존성 역전 원칙(DIP)을 적극 적용했습니다. 결과적으로 모듈 간의 느슨한 결합이 형성되어 테스트 코드 작성 시 Mock 객체를 적극 활용할 수 있게 되었습니다.

핵심 ViewModel들의 Test Code Coverage

<img width="621" alt="스크린샷 2024-02-28 오후 3 30 10" src="https://github.com/umaKim/GithubUserSearchApp/assets/85341050/d6872d2a-33bc-4195-af96-e9e2c9242bb2">
<img width="621" alt="스크린샷 2024-02-28 오후 3 30 27" src="https://github.com/umaKim/GithubUserSearchApp/assets/85341050/d894ac0b-5b72-4329-ab6e-97e42188d436">

### 문제 해결 4. 중복 코드 제거
이 앱은 유사한 기능을 가진 두 개의 기능을 포함하고 있어, 중복 코드가 발생합니다. 이를 해결하기 위해 ViewController에서 View를 따로 분리했고, 두개의 다른 ViewController에서 해당 View를 재활용할수 있게 했습니다. 그리고 Subscript를 적극 활용하여 특정 요소의 인덱스를 찾거나 배열의 인덱스에 값을 할당하는 로직을 Subscript로 분리함으로써 반복되는 코드를 간소화했습니다.

### 개선할 점
중복된 비즈니스 로직의 남아있는 문제: 두 기능의 ViewModel에서 발생하는 중복된 비즈니스 로직을 완전히 제거하지 못했습니다. 상속을 통해 중복 코드를 해결할 수도 있었으나, 이후 변경사항에 대응하기 어려운 코드가 될 수 있다는 판단 하에, 각 기능이 독립적으로 작동할 수 있도록 유지하기로 결정했습니다.

데이터 전달 방식의 한계: 현재 구조에서는 특정 Feature가 다른 Feature에 데이터를 전달할 때 ViewModel 내의 리스너를 통해 델리게이트 패턴을 사용하고 있습니다. 하지만, 이 리스너는 단일 객체로부터의 델리게이션만을 지원하기 때문에, 여러 Feature로부터의 델리게이션을 처리해야 하는 경우 확장성에 제한을 받습니다. 이 문제를 해결하기 위해선 Multicast Delegate Pattern을 적용하는 것이 필요하지만, 시간적 제약으로 인해 이를 구현하지 못했습니다. 
