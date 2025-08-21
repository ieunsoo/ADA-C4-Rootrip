import Foundation
import SwiftUI

/// 작은 프로젝트 카드들을 가로로 나열하는 뷰입니다.
struct SmallCardRowView: View {
    let projects: [Project]
    let startIndex: Int
    let isEditing: Bool
    @Binding var selectedProjects: Set<String>
    
    var body: some View {
        HStack(spacing: 44) {
            ForEach(0..<3) { offset in
                if startIndex + offset < projects.count {
                    let project = projects[startIndex + offset]
                    if isEditing {
                        Button {
                            toggleSelection(for: project.id)
                        } label: {
                            ProjectCard(
                                project: project,
                                isHighlighted: false,
                                isEditing: true,
                                isSelected: selectedProjects.contains(project.id ?? "")
                            )
                            .frame(width: 325, height: 190)
                        }
                        .buttonStyle(.plain)
                    } else {
                        NavigationLink(destination: ProjectView(project: project)
//                            .navigationBarHidden(true)
                        ) {
                            ProjectCard(
                                project: project,
                                isHighlighted: false,
                                isEditing: false,
                                isSelected: false
                            )
                            .frame(width: 325, height: 190)
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    Spacer().frame(width: 325)
                }
            }
        }
    }
    
    /// Firebase에서 불러온 데이터를 UI에서 사용하기 위한 함수
    private func toggleSelection(for id: String?) {
        guard let id else { return }
        if selectedProjects.contains(id) {
            selectedProjects.remove(id)
        } else {
            selectedProjects.insert(id)
        }
    }
}
