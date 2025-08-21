import Foundation
import SwiftUI

// MARK: - BookmarkListRow
/// 북마크 리스트의 각 행을 나타내는 뷰입니다.
struct BookmarkListRow: View {
    let poi: POIData
    let isEditing: Bool
    @EnvironmentObject var bookmarkManager: BookmarkManager
    
    var body: some View {
        let isSelected = bookmarkManager.selectedBookmarkID == poi.mapDetailID ||
        bookmarkManager.selectedBookmarkID?.contains(poi.mapDetailID) == true
        
        let isDeleteSelected = bookmarkManager.selectedForDeletionPlaceIDs.contains(poi.mapDetailID)
        
        HStack(spacing: 8) {
            // 앞쪽 원 아이콘
            if isEditing {
                Image(isDeleteSelected ? "purplemini" : "graymini")
                    .onTapGesture {
                        bookmarkManager.togglePlaceForDeletion(poi.mapDetailID)
                    }
            }
            
            // 아이콘
            Image(isSelected ? poi.selectedImageName : poi.imageName)
            
            // 텍스트
            Text(poi.name)
                .font(.prereg16)
                .foregroundColor(isSelected ? .accent1 : .maintext)
                .lineLimit(1)
            
            Spacer()
            
            // 오른쪽 햄버거 아이콘
            if isEditing {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.secondary2)
                    .font(.prereg16)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !isEditing {
                if let detail = bookmarkManager.mapDetails.first(where: { $0.id == poi.mapDetailID }) {
                    bookmarkManager.toggleBookmark(detail)
                }
            }
        }
    }
}

