# Rootrip

지도와 펜이 합쳐진 여행 플래너 앱

# OverView
Rootrip은 PencilKit, MapKit을 활용하여 지도위에 그림을 그리거나 영역을 지정해서 검색을 하거나 자동으로 경로를 만들어 주는 여행 계획 경험을 극대화 시켜주는 앱 입니다.

## Core Feature
- 지도 그림 그리기 기능
- 지도 영역 지정 기능
- 지도 경로 지정 기능
- 지도 검색 기능
- 계획중인 지도 동시 접속 기능 (개발 중)

## How It Works
앱은 로그인 기능을 지원해 개인화 된 계획세우는것을 지원하고 FireBase에 계획이 자동으로 저장되기에 다른 기기로 접속하더라도 로그인만 한다면 그대로 이어서 작업을 할 수 있게 돕습니다.

MapKit으로 구현된 지도 위에 PencilKit을 사용하기 위한 배경이 없는 투명한 Canvas를 띄우고 펜입력을 두가지로 나누어 그림만 그릴 수 있는 DrawingPen, 경로검색이나 범위지정 검색을 가능하게 하는 UtilPen 두가지로 나누어 지도위에 그림그리기, 경로 검색하기, 범위 검색하기 기능을 구현합니다.

작성된 그림 데이터는 하나의 선 단위로 펜의 굵기, 펜의 위치, 펜의 색깔이 저장되고 저장된 위치 정보는 위도 경도와 장소이름, 카테고리가 FireBase에 저장됩니다.

저장된 계획의 경우 고유의 Key값이 존재하며 이 값을 공유하여 다른 사용자에게 공유하는것이 가능합니다.

## Key Benefits
물리적인 지도에서만 가능하던 지도위에 그림이나 필기를 하던 경험을 iPad에서도 할 수 있게 하여 여행 계획경험이 향상되도록 돕습니다. 

또한 기존의 물리적인 지도에서는 불가능하던 경로 자동 검색이나 장소 검색, 플래너 공유 기능을 구현하여 물리지도와 지도앱의 장점을 합쳐 극대화된 여행계획 경험을 제공합니다. 

## 프로젝트 구조
우리의 프로젝트는 지도 위에 투명한 캔버스를 씌워서 그림을 그리고
그림을 MapKit의 overlay polygon으로 변환해서 지도위에 저장하는 구조를 가집니다.

---


# Technology
- SwiftUI
- UIKit
- PencilKit
- MapKit
  - CoreLocation
- Combine
- FireBase

#### Design Pattern
- Repository Pattern
- MVVM Pattern
- MVC  Pattern

# Development Enviroment
- Swift: 6.0+
- Xcode: 16.4+
- iPadOS: 18.0+

# Availability
- iPadOS: 18.0+

---
"내 코드를 처음 보는 사람이 이 문서만으로도 기능을 이해하고 사용할 수 있을까?"
클래스/구조체: 역할, 목적, 사용법
