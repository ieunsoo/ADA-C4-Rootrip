import FirebaseFirestore
import Foundation

/// 당일치기 여행인지 n박 여행인지 구분하기 위한 열거형
enum TripType: String, Codable, CaseIterable {
    case dayTrip
    case overnightTrip
}
