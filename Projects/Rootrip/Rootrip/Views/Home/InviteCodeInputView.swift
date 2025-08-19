import SwiftUI

struct InviteCodeInputView: View {
    @State var code: String = ""
    @Binding var isShowingCodeSheet: Bool
    @StateObject private var viewModel = InviteViewModel()
    @State private var isProcessing = false
    
    /// BlockViewModel을 받아서 프로젝트 리스트 업데이트
    @EnvironmentObject var blockViewModel: BlockViewModel
    
    @AppStorage("currentUserID") private var currentUserID: String = ""  // 공유 ID 사용

    var body: some View {
        ZStack {
            Color.maintext.opacity(0.4).ignoresSafeArea()
            
            Rectangle()
                .frame(width: 562, height: 316)
                .foregroundStyle(.mainbackground)
                .cornerRadius(16)
                .overlay(
                    VStack {
                        headerView
                        
                        Spacer()
                        HStack {
                            Text("초대받은 참여코드를 입력하세요.")
                                .foregroundStyle(.secondary2)
                                .font(.prereg14)
                            Spacer()
                        }
                        .padding(.horizontal, 36)
                        
                        VStack(spacing: 28) {
                            TextField("", text: $code)
                                .textFieldStyle(RoundedTextFieldStyle())
                                .padding(.horizontal, 33)
                                .foregroundStyle(.secondary1)
                            
                            Button {
                                if !isProcessing {
                                    Task { await joinProject() }
                                }
                            } label: {
                                HStack {
                                    if isProcessing {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .foregroundColor(.white)
                                    }
                                    Text(isProcessing ? "참여 중..." : "플랜 참가")
                                        .font(.presemi20)
                                        .foregroundStyle(code.isEmpty || isProcessing ? Color.secondary2 : Color.secondary4)
                                }
                                .padding(.horizontal, 209)
                                .padding(.vertical, 23)
                                .background(code.isEmpty || isProcessing ? Color.secondary3 : Color.primary1)
                                .cornerRadius(16)
                            }
                            .disabled(code.isEmpty || isProcessing)
                            
                            // 에러 메시지 표시
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.prereg14)
                                    .padding(.horizontal, 33)
                            }
                        }
                        
                        Spacer()
                    }
                )
        }
    }
    
    // MARK: - 프로젝트 참여 로직
    private func joinProject() async {
        isProcessing = true
        await viewModel.joinProject(with: code, userID: currentUserID)
        
        print("🔍 joinProject 완료:")
        print("   - errorMessage: \(viewModel.errorMessage ?? "nil")")
        print("   - joinedProject: \(viewModel.joinedProject?.title ?? "nil")")
        
        if viewModel.errorMessage == nil,
           let joinedProject = viewModel.joinedProject {
            print("✅ 프로젝트 참여 성공, UI 업데이트 시작")
            
            await MainActor.run {
                // UI에 즉시 반영
                if !blockViewModel.projects.contains(where: { $0.id == joinedProject.id }) {
                    blockViewModel.projects.append(joinedProject)
                    blockViewModel.projects = blockViewModel.projects
                }
                isShowingCodeSheet = false
            }
            
            // Firebase 데이터와 동기화
            await blockViewModel.fetchProjects()
            print("🔄 Firebase와 동기화 완료")
            
            // BlockView에서 네비게이션 트리거
            blockViewModel.newProjectForNavigation = joinedProject
            print("📱 UI 업데이트 완료")
            
        } else if let error = viewModel.errorMessage {
            print("❌ 프로젝트 참여 실패: \(error)")
        }
        
        isProcessing = false
    }
    
    //MARK: - headerView
    private var headerView: some View {
        ZStack {
            Rectangle()
                .frame(width: 562, height: 62)
                .foregroundStyle(.mainbackground)
                .clipShape(
                    RoundedCorner(radius: 16, corners: [.topLeft, .topRight])
                )
                .shadow(color: .secondary2.opacity(0.1), radius: 4, x: 0, y: 4)
                .overlay(
                    HStack {
                        Button {
                            isShowingCodeSheet = false
                        } label: {
                            Text("취소")
                                .font(.prereg16)
                                .foregroundStyle(.primary1)
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                        
                        Text("코드로 참여하기")
                            .foregroundStyle(.secondary1)
                            .font(.presemi20)
                        
                        Spacer()
                    }
                        .padding(.horizontal)
                )
        }
    }
}
