import SwiftUI

/// 현재 위치를 지도의 중심으로 이동시키는 버튼입니다.
struct CenterLocationButton: View {
    var onTap: () -> Void

    var body: some View {
        Button(action: {
            onTap()
        }) {
            Image(systemName: "location.fill")
                .foregroundStyle(.secondary4)
                .padding()
                .background(Circle().fill(Color.primary1))
                .shadow(radius: 4)
        }
        .padding()
    }
}
