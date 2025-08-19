import Foundation
import SwiftUI

struct PencilBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let thinHeight: CGFloat = 2
        let fatHeight = rect.height
        let radius = fatHeight / 2
        let centerY = rect.midY

        path.move(to: CGPoint(x: 0, y: centerY - thinHeight / 2))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: centerY - fatHeight / 2))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: centerY),
                    radius: radius,
                    startAngle: .degrees(-90),
                    endAngle: .degrees(90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: centerY + thinHeight / 2))
        path.closeSubpath()

        return path
    }
}

#Preview{
    PencilBarShape()
}
