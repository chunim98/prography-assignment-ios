## 프로젝트 테스트에 대한 안내
![Image](https://github.com/user-attachments/assets/9ae12975-3e5a-43dd-afea-2a062781b7e0)

프로젝트의 테스트에 관해 안내드립니다. 

해당 프로젝트는 TMDB의 API 키를 필요로 하지만, 해당 레포지토리에는 TMDB의 API 키가 포함되어 있지 않습니다.

때문에 개인적으로 발급받으신 TMDB의 API 키를 위 이미지의 안내에 따라 적용한 후 테스트 진행 부탁드립니다.

만약, 위 이미지가 보이지 않거나 테스트에 관해 도움이 필요하시면 jjingeo1230@gmail.com 혹은 개인 연락처로 연락 부탁드립니다.

감사합니다.

<br/>

## 개요
프로그라피 10기 iOS 과제입니다.

**개발 기간: 2024.02.13 ~ 2024.02.21**

<br/>

## 사용 기술
**디자인 패턴은 MVVM을 사용했습니다.**

| 이름 | 목적 |
| --- | --- |
| RxSwift | UIKit 환경에서 반응형 프로그래밍과 추적이 쉬운 데이터 흐름을 구현합니다. |
| RxDataSources | RxCocoa로 TableView 바인딩 시 애니메이션을 적용합니다. |
| SnapKit | AutoLayout 제약조건 코드의 가독성을 개선합니다. |
| Kingfisher | 이미지를 캐싱하여 API의 중복 호출을 줄입니다. |

<br/>

## 코드 컨벤션
> **기본적으로 https://github.com/StyleShare/swift-style-guide.git 의 컨벤션을 따릅니다.**

### 들여쓰기
- 들여쓰기에는 탭(tab)을 사용합니다.
- 한 줄은 최대 100자 이내를 지향합니다.

### 네이밍
- Rx 프로퍼티의 이름은 전달하고 있는 이벤트가 아닌, 데이터를 기준으로 작성합니다.
    - 나쁜 예) indexUpdate: Obserbable<Int>
    - 좋은 예) updatedIndex: Obserbable<Int>
- Rx 프로퍼티가 순수히 이벤트(Void)만을 전달하는 경우, 이벤트 이름 뒤에 Event를 붙입니다.
    - 예시) buttonTapEvent, dismissEvent…
- Rx 프로퍼티가 Bool 타입 데이터를 전달하는 경우, 기존의 수동태 이름을 사용합니다.
    - 예시) isHidden, isUpdated…
- 이하의 타입은 약어로 사용할 수 있습니다.
    - ViewController → VC
    - ViewModel → VM
    - TableView → TV
    - CollectionView → CV

### 프로그래밍 권장사항
- 더 이상 상속되지 않는 클래스는 final 키워드를 사용합니다.
- 같은 로직이 3번 이상 반복될 경우 중복을 제거해야 합니다.

<br/>

## 구현 내용
[🔗 구현 내용](https://axiomatic-mambo-9a8.notion.site/1a1b946392fe80ceb073c0b585854636?pvs=4)

<br/>
