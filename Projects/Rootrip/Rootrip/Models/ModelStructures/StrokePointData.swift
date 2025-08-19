import Foundation
import FirebaseFirestore


/// 하나의 선을 구성하는 점 단위의 Model
struct StrokePointData: Identifiable, Codable {
    @DocumentID var id: String?
    var x: Double
    var y: Double
    var lineWidth: Double
}
