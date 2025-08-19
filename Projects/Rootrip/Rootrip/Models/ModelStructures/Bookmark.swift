import FirebaseFirestore
import Foundation

/// SideBar에 존재하는 여행 포인트를 저장하기 위한 Model
struct Bookmark: Identifiable, Codable {
    @DocumentID var id: String?
    var projectID: String
    var title: String
    var isDefault: Bool = false

    init(projectID: String, title: String, isDefault: Bool = false) {
        self.id = nil
        self.projectID = projectID
        self.title = title
        self.isDefault = isDefault
    }
}
//테스트용
extension Bookmark {
    init(id: String?, projectID: String, title: String, isDefault: Bool = false) {
        self.id = id
        self.projectID = projectID
        self.title = title
        self.isDefault = isDefault
    }
}
