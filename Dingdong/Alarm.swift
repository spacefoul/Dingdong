//
//  Alarm.swift
//  DingDong
//
//  Created by F_s on 8/4/25.
//

import Foundation
import FirebaseFirestore

//struct Alarm: Identifiable, Codable {
//	var id: Int
//	var time: String        // 서버에서 받는 ISO8601 string ("2025-08-06T08:00:00Z")
//	var content: String
//	
//	// SwiftUI에서 바로 Date로 쓰고 싶을 때!
//	var timeDate: Date? {
//		ISO8601DateFormatter().date(from: time)
//	}
//}


// Alarm.swift – UI 모델은 그대로 써도 되지만, Date 기반을 권장
struct Alarm: Identifiable, Codable, Equatable {
	var id: String           // Firestore 문서 ID
	var dueAt: Date          // 알람 시간
	var content: String
	
	// 표시용 포맷터
	var timeText: String {
		let f = DateFormatter()
		f.dateFormat = "a hh:mm"
		f.locale = Locale(identifier: "ko_KR")
		return f.string(from: dueAt)
	}
}

// Firestore 전용 모델
private struct AlarmFirestore: Identifiable, Codable {
	@DocumentID var id: String?
	var dueAt: Timestamp
	var content: String
	var isEnabled: Bool
	var createdAt: Timestamp
	var updatedAt: Timestamp
	
	init(from ui: Alarm) {
		self.id        = ui.id
		self.dueAt     = Timestamp(date: ui.dueAt)
		self.content   = ui.content
		self.isEnabled = true
		let now = Timestamp(date: Date())
		self.createdAt = now
		self.updatedAt = now
	}
	
	func toUI() -> Alarm {
		Alarm(id: id ?? UUID().uuidString, dueAt: dueAt.dateValue(), content: content)
	}
}
