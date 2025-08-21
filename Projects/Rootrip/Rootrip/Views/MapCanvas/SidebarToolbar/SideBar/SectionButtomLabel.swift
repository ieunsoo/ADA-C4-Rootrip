/// 사이드바의 섹션 버튼에 적용되는 스타일입니다.
import SwiftUI

/**
 섹션버튼 Modifier
*/
struct SectionButtomLabel: ViewModifier {
    let isSelected: Bool

    func body(content: Content) ->  some View {
        content
            .font(.presemi24)
            .foregroundColor(isSelected ? .accent1 : .secondary2)
            .padding(.horizontal, 8)
            .frame(height: 45)
            .background(Color.secondary5)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .overlay(
                    RoundedRectangle(cornerRadius: 32)
                       .stroke(Color.white, lineWidth: 1)
                    )
            .shadow(color: Color.maintext.opacity(0.25), radius: 4)
      
    }
}


