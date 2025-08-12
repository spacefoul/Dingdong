//
//  AppleSignIn.swift
//  Dingdong
//
//  Created by F_s on 8/11/25.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import SwiftUI

final class AppleSignIn: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
	// 외부에서 로그인 결과를 받을 수 있게 콜백 제공
	var onFirebaseSignedIn: ((AuthDataResult) -> Void)?
	var onError: ((Error) -> Void)?
	
	private var currentNonce: String?
	
	func start() {
		let nonce = AppleSignIn.randomNonce()
		currentNonce = nonce
		
		let req = ASAuthorizationAppleIDProvider().createRequest()
		req.requestedScopes = [.fullName, .email]
		req.nonce = AppleSignIn.sha256(nonce)
		
		let ctrl = ASAuthorizationController(authorizationRequests: [req])
		ctrl.delegate = self
		ctrl.presentationContextProvider = self
		ctrl.performRequests()
	}
	
	// iOS 15+ 안전 anchor
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		UIApplication.shared.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.flatMap { $0.windows }
			.first { $0.isKeyWindow } ?? ASPresentationAnchor()
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization auth: ASAuthorization) {
		guard
			let c = auth.credential as? ASAuthorizationAppleIDCredential,
			let tokenData = c.identityToken,
			let idToken = String(data: tokenData, encoding: .utf8),
			let nonce = currentNonce
		else {
			onError?(NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "identityToken/nonce 추출 실패"]))
			return
		}
		
		let cred = OAuthProvider.appleCredential(withIDToken: idToken, rawNonce: nonce, fullName: c.fullName)
		Auth.auth().signIn(with: cred) { result, error in
			if let error = error as NSError? {
				// 로깅 강화
				print("❌ Firebase sign-in error: \(error.domain) (\(error.code)) – \(error.localizedDescription)")
				print("userInfo:", error.userInfo)
				if let resp = error.userInfo["FIRAuthErrorUserInfoDeserializedResponseKey"] {
					print("↳ deserialized:", resp)
				}
				self.onError?(error)
				return
			}
			if let result = result {
				print("✅ Firebase sign-in 성공: \(result.user.uid)")
				self.onFirebaseSignedIn?(result)
			}
		}
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		print("🍎 Apple Sign-In failed: \(error.localizedDescription)")
		onError?(error)
	}
}

// MARK: - Helpers (여기에만 정의해서 중복 제거)
extension AppleSignIn {
	static func sha256(_ input: String) -> String {
		let hashed = SHA256.hash(data: Data(input.utf8))
		return hashed.map { String(format: "%02x", $0) }.joined()
	}
	
	static func randomNonce(length: Int = 32) -> String {
		let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
		var result = ""
		result.reserveCapacity(length)
		var remaining = length
		while remaining > 0 {
			var random: UInt8 = 0
			_ = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
			// charset 범위로 모듈러
			result.append(charset[Int(random) % charset.count])
			remaining -= 1
		}
		return result
	}
}
