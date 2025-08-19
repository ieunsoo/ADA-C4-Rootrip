//
//  RootripApp.swift
//  Rootrip
//
//  Created by eunsoo on 7/17/25.
//

import FirebaseCore
import SwiftUI

/// firebase를 사용하기 위해서 만든 클래스, delegate로서 app실행시점에 프로젝트 초기에 적용된다.
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

/// 앱의 시작점, 앱 실행 후 LoginView가 제일 먼저 출력된다.
@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var locationManager = LocationManager()
    @StateObject var planManager = PlanManager()
    @StateObject var bookmarkManager = BookmarkManager()
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(locationManager)
                .environmentObject(planManager)
                .environmentObject(bookmarkManager)
        }
    }
}
