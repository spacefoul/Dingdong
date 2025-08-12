//
//  LoginView.swift
//  DingDong
//
//  Created by F_s on 8/6/25.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth

struct LoginView: View {
	@AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
	@State private var isSigningIn = false
	@State private var nonce = ""
	@Namespace private var ns
	
	var body: some View {
		ZStack {
			// Gradient 배경
			LinearGradient(
				gradient: Gradient(colors: [
					Color(.systemBackground),
					Color(.secondarySystemBackground)
				]),
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()
			
			// 은은한 원형 빛(배경 데코)
			Circle()
				.fill(Color.accentColor.opacity(0.18))
				.frame(width: 360, height: 360)
				.blur(radius: 60)
				.offset(x: -140, y: -220)
			
			Circle()
				.fill(Color.blue.opacity(0.15))
				.frame(width: 320, height: 320)
				.blur(radius: 50)
				.offset(x: 160, y: 220)
			
			// 글래스 카드
			VStack(spacing: 24) {
				// 로고 + 타이틀
				VStack(spacing: 12) {
					ZStack {
						RoundedRectangle(cornerRadius: 24, style: .continuous)
							.fill(.ultraThinMaterial)
							.overlay(
								RoundedRectangle(cornerRadius: 24, style: .continuous)
									.strokeBorder(Color.white.opacity(0.35), lineWidth: 0.8)
							)
							.frame(width: 88, height: 88)
							.shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)
						
						Image(systemName: "bell.fill")
							.font(.system(size: 36, weight: .semibold))
							.foregroundStyle(.primary)
							.matchedGeometryEffect(id: "logo", in: ns)
					}
					
					Text("DingDong")
						.font(.system(size: 32, weight: .bold))
						.kerning(0.5)
					
					Text("하루의 약속을 가볍게 시작해요")
						.font(.subheadline)
						.foregroundStyle(.secondary)
						.multilineTextAlignment(.center)
				}
				.padding(.top, 6)
				
				// Sign in with Apple
				VStack(spacing: 14) {
					SignInWithAppleButton(.signIn,
												 onRequest: { request in
						isSigningIn = true
						let n = randomNonce()
						nonce = n
						request.requestedScopes = [.fullName, .email]
						request.nonce = sha256(n)
						UIImpactFeedbackGenerator(style: .light).impactOccurred()
					},
												 onCompletion: { result in
						isSigningIn = false
						switch result {
							case .success(let authorization):
								handleApple(auth: authorization, rawNonce: nonce)
							case .failure(let error):
								print("❌ Apple Sign-In failed: \(error.localizedDescription)")
						}
					}
					)
					.signInWithAppleButtonStyle(colorSchemeAdaptiveStyle) // 라이트/다크 자동
					.frame(height: 54)
					.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
					.shadow(color: .black.opacity(0.10), radius: 10, x: 0, y: 6)
					.animation(.spring(response: 0.35, dampingFraction: 0.85), value: isSigningIn)
					
					if isSigningIn {
						HStack(spacing: 8) {
							ProgressView()
							Text("로그인 중…")
								.font(.footnote)
								.foregroundStyle(.secondary)
						}
						.transition(.opacity.combined(with: .scale))
					}
				}
				
				// 약관 문구
				Text("로그인하면 서비스 이용약관 및 개인정보 처리방침에 동의한 것으로 간주됩니다.")
					.font(.caption2)
					.foregroundStyle(.secondary)
					.multilineTextAlignment(.center)
					.padding(.horizontal, 16)
				
				// 바닥 여백
				Spacer(minLength: 0)
			}
			.padding(.horizontal, 24)
			.frame(maxWidth: 520)
			.padding(.vertical, 36)
			.background(
				RoundedRectangle(cornerRadius: 28, style: .continuous)
					.fill(.ultraThinMaterial)
					.overlay(
						RoundedRectangle(cornerRadius: 28, style: .continuous)
							.strokeBorder(Color.white.opacity(0.35), lineWidth: 0.8)
					)
					.shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 14)
			)
			.padding(.horizontal, 20)
		}
		.preferredColorScheme(nil) // 시스템 설정 따름
	}
	
	private var colorSchemeAdaptiveStyle: SignInWithAppleButton.Style {
		// 다크 모드에선 white, 라이트 모드에선 black이 더 대중적
		if UITraitCollection.current.userInterfaceStyle == .dark {
			return .white
		} else {
			return .black
		}
	}
}

// MARK: - Apple → Firebase 처리
private func handleApple(auth: ASAuthorization, rawNonce: String) {
	guard
		let credential = auth.credential as? ASAuthorizationAppleIDCredential,
		let tokenData = credential.identityToken,
		let idToken = String(data: tokenData, encoding: .utf8)
	else {
		print("❌ Failed to get Apple ID credential")
		return
	}
	
	let firebaseCred = OAuthProvider.appleCredential(
		withIDToken: idToken,
		rawNonce: rawNonce,
		fullName: credential.fullName
	)
	
	print("🔐 Creating Firebase credential…")
	Auth.auth().signIn(with: firebaseCred) { result, error in
		if let error = error as NSError? {
			print("❌ Firebase sign-in error: \(error.domain) (\(error.code)) – \(error.localizedDescription)")
			print("userInfo:", error.userInfo)
			if let resp = error.userInfo["FIRAuthErrorUserInfoDeserializedResponseKey"] {
				print("↳ deserialized:", resp)
			}
			return
		}
		if let user = result?.user {
			print("✅ Firebase sign-in: \(user.uid)")
			// 필요 시 @AppStorage("isLoggedIn")를 여기서 true로 바꾸려면
			UserDefaults.standard.set(true, forKey: "isLoggedIn")
		}
	}
}

// MARK: - Helpers
private func sha256(_ input: String) -> String {
	let hashed = SHA256.hash(data: Data(input.utf8))
	return hashed.map { String(format: "%02x", $0) }.joined()
}

private func randomNonce(length: Int = 32) -> String {
	let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
	var result = ""
	result.reserveCapacity(length)
	var remaining = length
	while remaining > 0 {
		var random: UInt8 = 0
		_ = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
		result.append(charset[Int(random) % charset.count])
		remaining -= 1
	}
	return result
}

#Preview {
	LoginView()
}
