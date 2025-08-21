import Foundation
import SwiftUI

/// 북마크 리스트의 내용을 구성하는 뷰입니다.
struct BookmarkListContent: View {
    let poiDataList: [POIData]
    let isEditing: Bool
    @EnvironmentObject var bookmarkManager: BookmarkManager
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(poiDataList) { poi in
                BookmarkListRow(poi: poi, isEditing: isEditing)
                    .padding(.vertical, 8)
                    .environmentObject(bookmarkManager)
            }
        }
    }
}
