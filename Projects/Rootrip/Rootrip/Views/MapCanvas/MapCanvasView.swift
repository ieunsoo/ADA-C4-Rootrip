import MapKit
import PencilKit
import SwiftUI

/**
 MapView와 CanvasView, CompositeSidebarView를 합쳐서 보여주는 View
 
지도와 그림을 그리는 canvas, 툴바, 사이드바가 합쳐지는 뷰
 */
struct MapCanvasView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var planManager: PlanManager
    @EnvironmentObject var bookmarkManager: BookmarkManager
    
    @ObservedObject var viewModel: MapViewModel
    
    var project: Project
    
    @Binding var shouldCenterOnUser: Bool
    @Binding var isUtilPen: Bool
    @Binding var isCanvasActive: Bool
    @Binding var isPageLocked: Bool
    @Binding var undoTrigger: Bool
    @Binding var redoTrigger: Bool
    @Binding var lineWidth: CGFloat
    @Binding var lineWidthTrigger: Bool
    
    @State var mapView = MKMapView()
    @State var drawing = PKDrawing()

    var body: some View {
        ZStack {
            
            MapView(
                viewModel: viewModel,
                shouldCenterOnUser: $shouldCenterOnUser,
                mapView: $mapView
            )
            .ignoresSafeArea()

            if isCanvasActive {
                CanvasView(
                    drawing: $drawing,
                    isUtilPen: $isUtilPen,
                    isCanvasActive: $isCanvasActive,
                    mapView: $mapView,
                    undoTrigger: $undoTrigger,
                    redoTrigger: $redoTrigger,
                    lineWidth: $lineWidth,
                    lineWidthTrigger: $lineWidthTrigger
                )
                .background(Color.clear)
                .ignoresSafeArea()
            }
            
            CompositeSidebarView(
                project: project,
                lineWidth: $lineWidth,
                isUtilPen: $isUtilPen,
                isCanvasActive: $isCanvasActive,
                isPageLocked: $isPageLocked,
                undoTrigger: $undoTrigger,
                redoTrigger: $redoTrigger,
                lineWidthTrigger: $lineWidthTrigger
            )
        }
        .overlay(
            VStack(spacing: -7) {
                /// 유틸펜 사용 토글 버튼
                Button(action: {
                    guard !isPageLocked else {
                        return
                    }

                    switch (isCanvasActive, isUtilPen) {
                    case (true, true):
                        isCanvasActive = false
                        isUtilPen = false
                        drawing = PKDrawing()
                    case (true, false):
                        isUtilPen = true
                    case (false, false):
                        isCanvasActive = true
                        isUtilPen = true
                        drawing = PKDrawing()
                    default:
                        break  // logic error
                    }
                }) {
                    Image(isUtilPen ? "utilOn" : "utilOff")
                }
                /// 내위치로 가기 버튼
                Button(action: {
                    shouldCenterOnUser = true
                }) {
                    Image("myLocation")
                }
            }
            .padding(),
            alignment: .bottomTrailing
        )
        .onAppear {
            mapView.delegate = MapDelegate.shared
            locationManager.setMapView(mapView)
            planManager.configure(with: locationManager)
            bookmarkManager.configure(with: locationManager)
        }
    }
}

// TODO: pencil Toolbar의 값을 반영할 수 있도록 연동
class MapDelegate: NSObject, MKMapViewDelegate {
    static let shared = MapDelegate()
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay)
        -> MKOverlayRenderer
    {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            if let hex = polyline.title, let color = UIColor(hexString: hex) {
                renderer.strokeColor = color
            } else {
                renderer.strokeColor = .accent1  // 유틸펜의 기본색상 삽입
            }
            renderer.lineWidth = 4  // 선굵기값 받아오기
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

