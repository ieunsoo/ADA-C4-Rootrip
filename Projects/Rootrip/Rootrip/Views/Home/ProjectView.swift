import CoreLocation
import MapKit
import SwiftUI

/**
 우리의 프로젝트는 지도 위에 투명한 캔버스를 씌워서 그림을 그리고
 그림을 MapKit의 overlay polygon으로 변환해서 지도위에 저장하는 구조를 가집니다.<br>
 ProjectView안에서 지도와 canvas, 상단 툴바, 사이드 바를 합치는 구조입니다.
 */
struct ProjectView: View {
    let project: Project
    @EnvironmentObject  var mapState: LocationManager
    @EnvironmentObject var planManager: PlanManager

    @StateObject private var viewModel = MapViewModel()

    @State private var hasLoadedPlans = false
    @State private var shouldCenterOnUser = false
    @State var isUtilPen = false
    @State var isCanvasActive = false
    /// 동시접속을 대비해서 만들어둔 프로퍼티, 모두가 펜 사용을 못하게 만든다.
    @State var isPageLocked: Bool = false
    @State var undoTrigger: Bool = false
    @State var redoTrigger: Bool = false
    /// 펜굵기 지정 슬라이더를 조작하고 있을 때의 여부를 확인하기 위한 상태 변수
    @State var lineWidthTrigger: Bool = false
    @State var lineWidth:CGFloat = 8.0

    var body: some View {
        //TODO: MapCanvasView안에 SideBarToggleView넣기
        ZStack {
            MapCanvasView(
                viewModel: viewModel,
                shouldCenterOnUser: $shouldCenterOnUser,
                isUtilPen: $isUtilPen,
                isCanvasActive: $isCanvasActive,
                isPageLocked: $isPageLocked,
                undoTrigger: $undoTrigger,
                redoTrigger: $redoTrigger,
                lineWidth: $lineWidth,
                lineWidthTrigger: $lineWidthTrigger
            )

            SidebarToggleView(
                project: project,
                lineWidth: $lineWidth,
                isUtilPen: $isUtilPen,
                isCanvasActive: $isCanvasActive,
                isPageLocked: $isPageLocked,
                undoTrigger: $undoTrigger,
                redoTrigger: $redoTrigger,
                lineWidthTrigger: $lineWidthTrigger
            )
//            .environmentObject(mapState)
        }
        .onAppear {
            guard !hasLoadedPlans else { return }
            hasLoadedPlans = true

            guard let projectID = project.id else { return }

            Task {
                await planManager.loadPlans(for: projectID)
            }
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}
