import FirebaseFirestore
import Foundation

/// 하나의 여행 프로젝트를 담는 Model
struct Project: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    
    var title: String
    var createdDate: Date
    var startDate: Date
    var endDate: Date?
    /// 당일치기 여행인지 n박 여행인지 구분하기 위한 열거형
    var tripType: TripType
    /// 공동작업자들의 ID 리스트
    var memberIDs: [String]

    init(
        title: String,
        tripType: TripType,
        startDate: Date,
        endDate: Date? = nil,
        memberIDs: [String] = []
    ) {
        self.id = nil
        self.title = title
        self.tripType = tripType
        self.createdDate = Date()
        self.startDate = startDate
        self.endDate = endDate
        self.memberIDs = memberIDs
    }
}
