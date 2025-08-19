import Foundation
import CoreLocation

protocol UtilPenDelegate: AnyObject {
    func utilPenClassify(_ result: UtilPen.InputType)
}
