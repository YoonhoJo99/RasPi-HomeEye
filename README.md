# RasPi-HomeEye (모바일&amp;스마트시스템 기말 대체 과제)
## 프로젝트 개요 
- RasPi-HomeEye는 라즈베리파이와 iOS 기기를 연동하여 실시간 홈 모니터링 시스템을 구현하는 프로젝트입니다. 다양한 센서(온습도, 조도, 초음파)와 카메라를 활용하여 실시간 환경 모니터링, 영상 스트리밍, 그리고 이상 징후 감지 및 기록 기능을 제공함으로써, 사용자가 실시간으로 집안 상황을 효과적으로 관리할 수 있습니다.

## 개발순서
### 1.  모바일&스마트시스템 전체 복습 
- ... 복습
### 2.  통신 테스트 (라즈베리파이 ↔ iOS)
- 아래 두 개의 프로토콜을 사용할 예정

1. MQTT (센서 데이터)
	- 장점: 작은 센서 데이터 전송에 최적화 (저전력, 적은 대역폭)
	- 단점: 큰 데이터(영상) 전송 시 성능 저하 
2. WebSocket (비디오스트리밍)
	- 장점: 영상같은 대용량 데이터의 실시간 전송에 최적화
	- 단점: 작은 데이터 전송에는 MQTT보다 오버헤드가 큼

- 이 단계에서는 초음파센서, 온습도, 조도 센서까지만 테스트 (MQTT)

### 3. iOS앱 초안 만들기 
1. 프로젝트 기본 설정
	- MQTT, WebSocket 라이브러리 설정
	- Firebase 설정
	- MVVM
2. 기본 UI 구조 구현
	  1. EnvironmentMonitorView ( 환경(온도, 습도, 조도) 모니터링 뷰 )
	  2. LiveStreamView (실시간 카메라 스트리밍 뷰)
	  3. EventGalleryView (초음파 센서가 감지한 이상 징후의 발생 시점과 해당 순간의 현장 사진이 자동으로 기록되어, 사용자가 감지된 이벤트들의 시각 정보와 사진을 갤러리 형태로 보고 관리하는 뷰)
### 4. 기능 구현
1. EnvironmentMonitorView (MQTT)
    - 센서 데이터 수신 구현
    - 실시간 데이터 표시 UI
    - 데이터 시각화 (그래프 등)
2. LiveStreamView (WebSocket)
    - 실시간 영상 스트리밍 구현
    - 스트리밍 최적화
    - 에러 처리
3. EventGalleryView (Firebase - Firestore)
    - Firebase 데이터 모델 설계 
	    - 이미지, 시각 정보 뿐이라 간단
    - 이벤트 데이터 조회/삭제 구현
	    - 클릭시 이벤트를 볼 수 있고, 삭제를 누르면 ...
    - 갤러리 UI 구현
	    - 저장된 이벤트들을 시간순으로 정렬하여 갤러리 형태로 표시
    - 이벤트 관리 기능 구현
	    - 사용자가 각 이벤트 데이터를 확인하고 관리(삭제 등)할 수 있는 기능 제공
### 5. UI 개선
### 6. Test
