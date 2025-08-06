//
//  LoginView.swift
//  DingDong
//
//  Created by F_s on 8/6/25.
//

//import SwiftUI
//import AuthenticationServices
//
//struct LoginView: View {
//	@AppStorage("isLoggedIn") var isLoggedIn: Bool = false
//	
//	var body: some View {
//		VStack(spacing: 32) {
//			Spacer()
//			Image(systemName: "alarm.fill")
//				.font(.system(size: 60))
//				.foregroundColor(.black.opacity(0.8))
//			Text("DingDong에 오신 것을 환영합니다!")
//				.font(.title2.bold())
//				.multilineTextAlignment(.center)
//			
//			SignInWithAppleButton(
//				.signIn,
//				onRequest: { request in
//					request.requestedScopes = [.fullName, .email]
//				},
//				onCompletion: { result in
//					switch result {
//						case .success(let auth):
//							// 실제 앱에서는 여기서 유저 정보 및 토큰 처리!
//							print("로그인 성공: \(auth)")
//							// 예제: 바로 로그인 플래그 변경
//							isLoggedIn = true
//						case .failure(let error):
//							print("로그인 실패: \(error.localizedDescription)")
//					}
//				}
//			)
//			.signInWithAppleButtonStyle(.black)
//			.frame(height: 50)
//			.cornerRadius(12)
//			Spacer()
//		}
//		.padding()
//	}
//}

import SwiftUI
import AuthenticationServices

struct LoginView: View {
	@AppStorage("isLoggedIn") var isLoggedIn: Bool = false
	
	var body: some View {
		VStack(spacing: 32) {
			Spacer()
			Image(systemName: "alarm.fill")
				.font(.system(size: 60))
				.foregroundColor(.black.opacity(0.8))
			Text("DingDong에 오신 것을 환영합니다!")
				.font(.title2.bold())
				.multilineTextAlignment(.center)
			
			SignInWithAppleButton(
				.signIn,
				onRequest: { request in
					request.requestedScopes = [.fullName, .email]
				},
				onCompletion: { _ in
					// 👉 실제 로그인 대신 그냥 성공 처리!
					isLoggedIn = true
				}
			)
			.signInWithAppleButtonStyle(.black)
			.frame(height: 50)
			.cornerRadius(12)
			
			Spacer()
		}
		.padding()
	}
}



#Preview {
    LoginView()
}
