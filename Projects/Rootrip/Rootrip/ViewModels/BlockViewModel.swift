import Foundation
import SwiftUI

/**
 프로젝트의 CRUD를 담당하는 ViewModel
 - 현재 사용자 ID에 해당하는 프로젝트 가져오기
 - 새로운 프로젝트를 생성하고 내비게이션을 준비하는 함수
 - 프로젝트 새로고침
 - 프로젝트 삭제
 */
@MainActor
final class BlockViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var newProjectForNavigation: Project? = nil
    @Published var newInvitationCode: String? = nil

    private let repository: ProjectRepositoryProtocol
    private let inviteRepository: ProjectInvitationProtocol
    
    @AppStorage("currentUserID") private var currentUserID: String = ""

     init(
          repository: ProjectRepositoryProtocol = ProjectRepository(),
          inviteRepository: ProjectInvitationProtocol = ProjectInvitationRepository()
      ) {
          self.repository = repository
          self.inviteRepository = inviteRepository
          
          // UUID 최초 한 번만 생성
          if currentUserID.isEmpty {
              currentUserID = UUID().uuidString
              print("🔑 최초 currentUserID 생성: \(currentUserID)")
          } else {
              print("🔑 기존 currentUserID 사용: \(currentUserID)")
          }
      }

    /// 현재 사용자 ID에 해당하는 프로젝트 가져오기
    func fetchProjects() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await repository.fetchUserProjects(userID: currentUserID)
            await MainActor.run {
                self.projects = result
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    /// 새로운 프로젝트를 생성하고 내비게이션을 준비하는 함수
    func createNewProject() async {
        isLoading = true
        errorMessage = nil
        
        do {
            var newProject = try await repository.createProject(
                title: nil,         // 제목 자동 생성
                tripType: .dayTrip, // 기본 당일치기
                startDate: Date(),
                endDate: nil,
                userID: currentUserID 
            )
            
            // 생성한 프로젝트에 현재 사용자 ID 추가
            if let projectID = newProject.id {
                try await repository.addMember(to: projectID, userID: currentUserID)
                // 로컬 프로젝트에도 반영
                newProject.memberIDs.append(currentUserID)
            }
            
            self.newProjectForNavigation = newProject
            print("✅ 새 프로젝트 생성 완료: \(newProject.title) (ID: \(newProject.id ?? "N/A"))")
                        
            // 프로젝트 목록 갱신
            await fetchProjects()
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ 프로젝트 생성 실패: \(error.localizedDescription)")
        }
        
        self.isLoading = false
    }
    
    /// 프로젝트 새로고침
    func refreshProjects() {
        Task {
            await fetchProjects()
        }
    }
    
    /// 프로젝트 삭제
    func deleteProjects(projectIDs: [String]) async {
        for id in projectIDs {
            do {
                try await repository.deleteProject(projectID: id)
                print("🗑️ 삭제 완료: \(id)")
            } catch {
                print("❌ 삭제 실패: \(id) - \(error)")
            }
        }
        await fetchProjects()
    }
}
