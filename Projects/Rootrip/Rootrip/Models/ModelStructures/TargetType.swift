import Foundation

enum TargetType: String, CaseIterable, Identifiable {
    case bookmark = "북마크"
    case plan = "플랜"
    var id: String { rawValue }
}
