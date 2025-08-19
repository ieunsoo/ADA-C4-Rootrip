import SwiftUI

struct ParticipantsView: View {
    
    @StateObject var viewModel = InviteViewModel()
    let projectID: String
    let sampleParticipants: [(emoji: String, name: String)] = [
        ("🐶", "웨이"),
        ("🐱", "딘"),
        ("🐭", "엘라"),
        ("🐹", "메이"),
        ("🦊", "스티브"),
        ("🐰", "사나")
    ]
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                //MARK: - 초대하기
                Text("초대하기")
                    .font(.presemi24)
                    .foregroundStyle(.secondary1)
                
                Button {
                    // 초대코드 복사
                    Task {
                        await viewModel.copyInviteCode(for: projectID)
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "doc.on.doc.fill")
                            .foregroundColor(.accent3)
                        Text("참여 코드 복사하기")
                            .foregroundColor(.accent3)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.secondary5)
                            .shadow(color: .black.opacity(0.25), radius:4, x:0, y:0)
                        
                    )
                }
                .buttonStyle(.plain)
                .overlay(
                    VStack {
                        Spacer()
                        
                        if viewModel.copiedCode != nil {
                            Text("초대 코드가 복사되었습니다!")
                                .font(.caption)
                                .foregroundColor(.secondary2)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                                .animation(.easeInOut(duration: 0.3), value: viewModel.copiedCode != nil)
                        }
                    }
                        .padding(.top, 60) // 버튼 높이만큼 아래로
                    , alignment: .leading
                )
                
                //MARK: - 참여자
                Text("현재 참여자")
                    .font(.presemi24)
                    .foregroundStyle(.secondary1)
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(sampleParticipants, id: \.name) { participant in
                        HStack(spacing: 12) {
                            // 프로필 이미지 영역
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(participant.emoji)
                                        .font(.system(size: 20))
                                )
                            
                            Text(participant.name)
                                .font(.prereg16)
                                .foregroundStyle(.maintext)
                            
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                    
                )
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
    }
}

//#Preview {
//    ParticipantsView()
//}
