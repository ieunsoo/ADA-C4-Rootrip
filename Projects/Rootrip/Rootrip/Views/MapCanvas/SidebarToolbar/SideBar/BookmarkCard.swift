import SwiftUI

/// 북마크에 저장된 장소 목록을 보여주는 카드 뷰입니다.
struct BookmarkCard: View {
    let projectID: String
    let bookmarkID: String
    
    @State private var poiDataList: [POIData] = []
    @State private var isLoading = true
    @EnvironmentObject var bookmarkManager: BookmarkManager
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                LoadingView()
            } else {
                BookmarkListContent(poiDataList: poiDataList, isEditing: isEditing)
                    .environmentObject(bookmarkManager)
            }
        }
        .padding(.all, 16)
        .frame(width: 216)
        .background(.secondary4)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            Task {
                await loadPOIData()
            }
        }
        .onChange(of: bookmarkManager.mapDetails) { _, _ in
            Task {
                await loadPOIData()
            }
        }
    }
    
    @MainActor
    private func loadPOIData() async {
        isLoading = true
        
        let mapDetails = bookmarkManager.mapDetails(for: bookmarkID)
        
        var loadedPOIDataList: [POIData] = []
        let group = DispatchGroup()

        for detail in mapDetails {
            group.enter()
            bookmarkManager.convertMapDetailToPOIAnnotation(detail) { annotation in
                if let annotation = annotation {
                    let data = POIData(
                        mapDetailID: detail.id ?? "",
                        name: detail.name,
                        keyword: annotation.keyword
                    )
                    loadedPOIDataList.append(data)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.poiDataList = loadedPOIDataList
            self.isLoading = false
        }
    }
}



