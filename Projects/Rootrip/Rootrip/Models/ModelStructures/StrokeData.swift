import Foundation
import FirebaseFirestore

/// 하나의 선을 저장하는 Model
struct StrokeData: Identifiable, Codable {
    @DocumentID var id: String?
    var isUtilPen: Bool
    var isDeleted: Bool
    var inkColor: Double
    var points: [StrokePointData]
}
