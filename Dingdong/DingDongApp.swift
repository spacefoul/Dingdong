//
//  DingDongApp.swift
//  DingDong
//
//  Created by F_s on 8/1/25.
//

//import SwiftUI
//
//@main
//struct DingDongApp: App {
//	@StateObject var theme = ThemeManager()
//	
//    var body: some Scene {
//        WindowGroup {
//            MainView()
//				  .environmentObject(theme)
//        }
//    }
//}

import SwiftUI

@main
struct DingDongApp: App {
	@AppStorage("isLoggedIn") var isLoggedIn: Bool = false
	var body: some Scene {
		WindowGroup {
			if isLoggedIn {
				MainView().environmentObject(ThemeManager())
			} else {
				LoginView()
			}
		}
	}
}

