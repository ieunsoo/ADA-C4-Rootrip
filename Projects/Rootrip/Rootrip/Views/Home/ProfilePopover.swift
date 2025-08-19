import SwiftUI

// MARK: - 프로필 팝오버 뷰
struct ProfilePopover: View {
    @Binding var isShowingLogoutAlert: Bool
    @Binding var isShowingPopover: Bool
    @Binding var showDeleteAccountAlert: Bool
    var body: some View {
        VStack {
            Button {
                isShowingPopover = false
                isShowingLogoutAlert = true
            } label: {
                Text("로그아웃")
                    .foregroundStyle(.red)
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
            }
            .buttonStyle(.plain)

            Divider()
                .padding(.horizontal, 12)

            Button {
                isShowingPopover = false
                showDeleteAccountAlert = true
            } label: {
                Text("탈퇴하기")
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
            }
            .buttonStyle(.plain)
        }
    }
}
