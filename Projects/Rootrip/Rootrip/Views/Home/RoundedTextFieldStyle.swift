import SwiftUI

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
