//
//  POIAnnotation.swift
//  Rootrip
//
//  Created by Ella's Mac on 7/29/25.
//

import Foundation
import MapKit

///지도에 나타나는 마커를 지정하기 위한 Model
struct POIData: Identifiable {
    let id = UUID()
    let mapDetailID: String
    let name: String
    let keyword: String
    
    
    var imageName: String {
        switch keyword {
        case "cafe": return "graycafe"
        case "restaurant": return "grayrestaurant"
        default: return "graymap"
        }
    }
    
    var selectedImageName: String {
        switch keyword {
        case "cafe": return "greencafe"
        case "restaurant": return "greenrestaurant"
        default: return "greenmap"
        }
    }
}
