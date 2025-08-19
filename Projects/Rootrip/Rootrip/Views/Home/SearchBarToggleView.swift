import SwiftUI

// 검색창을 축소해두기 위한 토글
struct SearchBarToggleView: View {
    @Binding var text: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading) {
            if isExpanded {
                SearchBar(text: $text)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width > 50 {
                                    withAnimation {
                                        isExpanded = false
                                    }
                                }
                            }
                    )
            } else {
                Button(action: {
                    withAnimation {
                        isExpanded = true
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.96, green: 0.96, blue: 0.96))

                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary2)
                            .font(Font.custom("SF Pro", size: 20))
                    }
                    .frame(width: 59, height: 48)
                    .shadow(
                        color: .black.opacity(0.25),
                        radius: 5,
                        x: 0,
                        y: 4
                    )
                }
                .transition(.scale)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isExpanded)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var text = ""

        var body: some View {
            SearchBarToggleView(text: $text)
        }
    }

    return PreviewWrapper()
}
