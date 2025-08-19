import SwiftUI

/// 실행취소, 지도잠금, 저장, 홈으로 돌아가기 등 프로젝트의 동작에 연관된 동작을 수행하는 ToolBar
struct MapCanvasToolBar: View {
    let project: Project
    @Binding var isSidebarOpen: Bool
    @Binding var isCanvasActive: Bool
    @Binding var isPageLocked: Bool
    @Binding var undoTrigger: Bool
    @Binding var redoTrigger: Bool

    @Environment(\.dismiss) var dismiss //홈화면으로 돌아가기 위한 환경변수

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                HStack(spacing: 20) {
                    Button(action: {
                        withAnimation {
                            isSidebarOpen.toggle()
                        }
                    }) {
                        Image(systemName: "sidebar.left")
                            .padding(.leading, 20)
                    }
                    Spacer()

                    Button(action: {
                        undoTrigger.toggle()
                    }) {
                        Image(systemName: "arrow.uturn.backward")
                    }

                    Button(action: {
                        redoTrigger.toggle()
                    }) {
                        Image(systemName: "arrow.uturn.forward")
                    }
                    
                    Button(action: {
                        withAnimation(.linear) {
                            isPageLocked.toggle()
                            isCanvasActive = false
                        }
                    }) {
                        Image(
                            systemName: isPageLocked
                                ? "lock.fill" : "lock.open.fill"
                        )
                    }

                    Button(action: {
                        //저장 로직 여기에 입력
                    }) {
                        Text("저장")
                    }

                    Button(action: {
                        dismiss()
                    }) {
                        Text("홈")
                    }
                    .padding(.trailing, 30)
                }
                .foregroundStyle(.secondary4)

                //MARK: 프로젝트 title
                HStack {
                    Spacer()
                    Button(action: {
                        // TODO: 날짜, 이름 수정기능 구현 필요
                    }) {
                        Text("\(project.title)")
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10)
                    }
                    Spacer()
                }
                .foregroundStyle(.white)
                .fontWeight(.bold)
            }
            .frame(height: 50)
            .background(
                Color.primary1
                    .ignoresSafeArea(.container, edges: .top)
            )
        }
    }
}

//#Preview {
//    MapCanvasToolBar(isSidebarOpen: .constant(true))
//        .environmentObject(PlanManager())
//        .environmentObject(RouteManager())
//}
