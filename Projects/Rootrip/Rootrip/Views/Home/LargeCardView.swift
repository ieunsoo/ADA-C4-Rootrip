import Foundation
import SwiftUI

/// 가장 최근 프로젝트를 표시하는 큰 카드 뷰입니다.
struct LargeCardView: View {
    let project: Project
    var isEditing: Bool
    var isSelected: Bool
    var toggleSelection: () -> Void

    var body: some View {
        if isEditing {
            Button(action: toggleSelection) {
                ProjectCard(
                    project: project,
                    isHighlighted: true,
                    isEditing: true,
                    isSelected: isSelected
                )
            }
            .buttonStyle(.plain)
        } else {
            NavigationLink(destination:ProjectView(project: project)
//                .navigationBarHidden(true)
            ) {
                    ProjectCard(
                        project: project,
                        isHighlighted: true,
                        isEditing: false,
                        isSelected: false
                    )
                }
                .buttonStyle(.plain)
        }
    }
}

