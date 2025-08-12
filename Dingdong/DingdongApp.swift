//
//  DingdongApp.swift
//  Dingdong
//
//  Created by F_s on 8/8/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		FirebaseApp.configure()
		
		
		print("projectID:", FirebaseApp.app()?.options.projectID ?? "nil")
		print("apiKey:", FirebaseApp.app()?.options.apiKey ?? "nil")
		print("bundleID(options):", FirebaseApp.app()?.options.bundleID ?? "nil")
		print("bundleID(app):", Bundle.main.bundleIdentifier ?? "nil")
		
		
		
		Task {
			// 로컬 알림 권한 요청
			_ = try? await UNUserNotificationCenter.current()
				.requestAuthorization(options: [.alert, .sound, .badge])
		}
		return true
	}
}

@main
struct DingdongApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	
	var body: some Scene {
		WindowGroup {
			RootView() // 최상위 뷰
		}
	}
}

struct RootView: View {
	@AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
	@StateObject private var theme = ThemeManager()
	@State private var authListener: AuthStateDidChangeListenerHandle?
	
	var body: some View {
		Group {
			if isLoggedIn {
				MainView()
					.environmentObject(theme)
			} else {
				LoginView()
			}
		}
		.task {
			// Firebase Auth 상태 리스너 등록
			authListener = Auth.auth().addStateDidChangeListener { _, user in
				let wasLoggedIn = isLoggedIn
				isLoggedIn = (user != nil)
				
				print("🔐 Auth state changed:")
				print("  - User: \(user?.uid ?? "nil")")
				print("  - Was logged in: \(wasLoggedIn)")
				print("  - Is logged in: \(isLoggedIn)")
			}
		}
		.onDisappear {
			// (선택) 뷰가 내려갈 때 리스너 해제
			if let handle = authListener {
				Auth.auth().removeStateDidChangeListener(handle)
				authListener = nil
			}
		}
	}
}
