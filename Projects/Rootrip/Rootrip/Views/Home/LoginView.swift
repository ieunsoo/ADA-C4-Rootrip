import SwiftUI

/**
 무조건 로그인 해야만 ProjectView로 갈 수 있음
 여기서 ProjectView를 연결하는 구조
 */
// TODO: 로그인 기능 구현필요
struct LoginView: View {
    @State var isLoggedIn: Bool = false
    
    var body: some View {
        if !isLoggedIn{
            ZStack{
                Color.primary1
                Image("loginbackground")
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    
                VStack {
                    Spacer()
                        Image("R")
                        .frame(width: 127.27194, height: 97.66528)
                        .padding(17)

                        Text("ROOTRIP")
                            .font(.suereg24)
                            .foregroundColor(.primary1)
                            .padding(.bottom, 310)
                }
                // MARK: 로그인 버튼
                VStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut){
                            isLoggedIn.toggle()
                        }
                    }) {
                        Image("applebutton")
                    }
                    .padding(.bottom, 196)
                }
            }
            .ignoresSafeArea(.all)
        }
        else{
            BlockView()
                .environmentObject(PlanManager())
                .environmentObject(LocationManager())
                .environmentObject(BookmarkManager())
        }
    }
}

#Preview(traits: .landscapeLeft){
    LoginView()
}
