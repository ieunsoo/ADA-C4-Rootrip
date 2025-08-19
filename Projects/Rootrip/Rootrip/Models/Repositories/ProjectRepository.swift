import FirebaseFirestore
import Foundation

final class ProjectRepository: ProjectRepositoryProtocol {
    private let db = Firestore.firestore()
    private let projectsCollection = "Rootrip"
    
    let baseTitle = "새 일정"

    private let planRepository: PlanRepositoryProtocol
    private let bookmarkRepository: BookmarkRepositoryProtocol
    private let inviteRepository: ProjectInvitationProtocol

    init(
        planRepository: PlanRepositoryProtocol = PlanRepository(),
        bookmarkRepository: BookmarkRepositoryProtocol = BookmarkRepository(),
        inviteRepository: ProjectInvitationProtocol = ProjectInvitationRepository()
    ) {
        self.planRepository = planRepository
        self.bookmarkRepository = bookmarkRepository
        self.inviteRepository = inviteRepository
    }
    
    func createProject(
        title: String?,
        tripType: TripType,
        startDate: Date,
        endDate: Date?,
        userID: String
    ) async throws -> Project {
        // if no 'endDate' though TripType == .overnightTrip
        guard !(tripType == .overnightTrip && endDate == nil) else {
            print("createProject Error - endDate required")
            throw NSError(domain: "ProjectRepositoryError", code: 1, userInfo: [NSLocalizedDescriptionKey: "1박 이상 여행의 경우 종료일이 필요합니다."])
        } //반환타입이 Project가 되도록 수정
        
        // if no 'title' input, auto generate project title
        let title_ = try await (title != nil ? title! : genTitle(base: baseTitle))

        // newProject를 var로 선언하여 id를 설정할 수 있게 함
        var newProject = Project(
            title: title_,
            tripType: tripType,
            startDate: startDate,
            endDate: endDate,
            memberIDs: [userID]
        )
                    
        let projectReference = try db.collection(projectsCollection)
            .addDocument(from: newProject)
        let projectID = projectReference.documentID
        
        newProject.id = projectID

        // set default Plans
        var cnt = 0
        switch newProject.tripType {
        case .dayTrip:
            for _ in 0..<2 {
                try await planRepository.createPlan(projectID: projectID)
                cnt += 1
            }
        case .overnightTrip:
            guard let endDate = newProject.endDate else {
                throw NSError(domain: "ProjectRepositoryError", code: 2, userInfo: [NSLocalizedDescriptionKey: "1박 이상 여행의 경우 플랜 계산을 위한 종료일이 누락되었습니다."])
            }

            let dayCount =
                Calendar.current.dateComponents(
                    [.day],
                    from: newProject.startDate,
                    to: endDate
                ).day ?? 0
            for _ in 0..<max(dayCount, 1) {
                try await planRepository.createPlan(projectID: projectID)
            }
        }

        // set default Bookmark
        let defaultTitle = "내 보관함"
        try await bookmarkRepository.createBookmark(
            projectID: projectID,
            title: defaultTitle,
            isDefault: true
        )
        
        // 초대 코드 생성 (프로젝트당 하나만 생성되도록 보장)
        do {
            let invitation = try await inviteRepository.createInvitation(for: projectID)
        } catch {
            print("⚠️ 초대 코드 생성 실패: \(error.localizedDescription)")
        }
        
        return newProject
    }
    
    func genTitle(base: String) async throws -> String {
        let snapshot = try await db.collection(projectsCollection).getDocuments()
        let existingTitles = snapshot.documents.compactMap { $0["title"] as? String }

        if !existingTitles.contains(base) {
            return base
        }

        var i = 2
        while existingTitles.contains("\(base) (\(i))") {
            i += 1
        }

        return "\(base) (\(i))"
    }

    func updateProject(_ project: Project) async throws {
        // 1. 이름 수정
        // 2. 날짜 수정 (일자)
        // 2-1. 날짜 수정 (종료일 추가)
        // 2-2. 날짜 수정 (종료일 삭제)
    }
    
    func deleteProject(projectID: String) async throws {
        let projectRef = db.collection("Rootrip").document(projectID)

        // Delete Plans
        let plansSnapshot = try await projectRef.collection("plans").getDocuments()
        for doc in plansSnapshot.documents {
            try await doc.reference.delete()
        }

        // Delete Bookmarks
        let bookmarksSnapshot = try await projectRef.collection("bookmarks").getDocuments()
        for doc in bookmarksSnapshot.documents {
            try await doc.reference.delete()
        }

        // Delete Invitation Code (프로젝트 삭제 시 초대코드도 함께 삭제)
        do {
            let invitationsSnapshot = try await db.collection("ProjectInvitations")
                .whereField("projectID", isEqualTo: projectID)
                .getDocuments()
            
            for doc in invitationsSnapshot.documents {
                try await doc.reference.delete()
                print("🗑️ 초대 코드 삭제 완료: \(doc.documentID)")
            }
        } catch {
            print("⚠️ 초대 코드 삭제 실패: \(error.localizedDescription)")
        }

        // Delete Project
        try await projectRef.delete()
        print("🗑️ 프로젝트 삭제 완료: \(projectID)")
    }

    func saveProject() async throws {

    }
    
//    func fetchAllProjects() async throws -> [Project] {
//        print("🔍 Firestore에서 프로젝트 불러오기 시작...")
//        
//        let snapshot = try await db.collection(projectsCollection).getDocuments()
//        print("🔍 Firestore 문서 개수: \(snapshot.documents.count)")
//        
//        var projects: [Project] = []
//        
//        for document in snapshot.documents {
//            do {
//                print("📄 문서 ID: \(document.documentID)")
//                print("📄 문서 데이터: \(document.data())")
//                
//                let project = try document.data(as: Project.self)
//                projects.append(project)
//                print("✅ 프로젝트 변환 성공: \(project.title)")
//            } catch {
//                print("❌ 문서 변환 실패 (ID: \(document.documentID)): \(error)")
//                continue
//            }
//        }
//        print("🔍 총 변환된 프로젝트 수: \(projects.count)")
//        return projects
//    }
    
    func fetchUserProjects(userID: String) async throws -> [Project] {
        print("📡 fetchUserProjects 호출 - userID = \(userID)")
        let snapshot = try await db.collection(projectsCollection)
            .whereField("memberIDs", arrayContains: userID)
            .getDocuments()
        print("📡 fetchUserProjects Firestore 문서 개수 = \(snapshot.documents.count)")

        var projects: [Project] = []
        for document in snapshot.documents {
            do {
                let project = try document.data(as: Project.self)
                print("  ✅ 가져온 프로젝트: \(project.title), ID: \(document.documentID)")
                projects.append(project)
            } catch {
                print("  ❌ 변환 실패 (ID: \(document.documentID)) - \(error)")
            }
        }
        return projects
    }
    
    
    func addMember(to projectID: String, userID: String) async throws {
           let projectRef = db.collection(projectsCollection).document(projectID)
           try await projectRef.updateData([
               "memberIDs": FieldValue.arrayUnion([userID])
           ])
           print("✅ 사용자 추가 완료: \(userID) -> \(projectID)")
       }
    
}
