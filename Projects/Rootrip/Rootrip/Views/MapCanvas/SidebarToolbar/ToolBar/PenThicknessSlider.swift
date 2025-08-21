import SwiftUI

/// 펜의 굵기를 조절하는 슬라이더입니다.
struct PenThicknessSlider: View {
    /// 기본(권장) 두께 8.0
    @Binding var thickness: CGFloat
    @Binding var lineWidthTrigger: Bool
    

    let minThickness: CGFloat = 1
    let maxThickness: CGFloat = 20

    let trackWidth: CGFloat = 131
    let trackHeight: CGFloat = 16
    let handleSize: CGFloat = 26

    var body: some View {
        ZStack(alignment: .leading) {
            PencilBarShape()
                .fill(Color.secondary1) //TODO: 색상수정필요
                .frame(width: trackWidth, height: trackHeight)

            Circle()
                .stroke(Color.maintext, lineWidth: 1)
                .background(Circle().fill(Color.secondary4))
                .frame(width: handleSize, height: handleSize)
                .offset(x: handleOffset(for: thickness))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let location = value.location.x
                            let clamped = min(max(0, location), trackWidth)
                            let percent = clamped / trackWidth
                            thickness = minThickness + percent * (maxThickness - minThickness)
                        }
                )
        }
        .frame(width: trackWidth, height: handleSize)
        .onChange(of: thickness, {
            lineWidthTrigger = true
        })
    }

    private func handleOffset(for thickness: CGFloat) -> CGFloat {
        let percent = (thickness - minThickness) / (maxThickness - minThickness)
        return percent * trackWidth - handleSize / 2
    }
}
