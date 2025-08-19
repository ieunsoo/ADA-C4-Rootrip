import Foundation
import FirebaseFirestore

struct ProjectInvitation: Identifiable, Codable {
    /// 초대 코드
    @DocumentID var id: String?
    /// 프로젝트 ID
    var projectID: String
    /// 생성 날짜
    var createdAt: Date

    init(id: String? = nil, projectID: String, createdAt: Date = Date()) {
        self.id = id
        self.projectID = projectID
        self.createdAt = createdAt
    }
}
