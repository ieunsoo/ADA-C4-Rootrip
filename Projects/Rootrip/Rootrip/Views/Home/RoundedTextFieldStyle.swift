import SwiftUI

/// 둥근 모서리를 가진 텍스트 필드 스타일입니다.
struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 20)
            .padding(.vertical, 23)
            .background(Color.secondary4)
            .cornerRadius(16)
            .font(.presemi20)
    }
}
