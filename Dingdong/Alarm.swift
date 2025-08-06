//
//  Alarm.swift
//  DingDong
//
//  Created by F_s on 8/4/25.
//

//import Foundation
//
//struct Alarm: Identifiable, Codable {
//	var id = UUID()
//	var time: Date
//	var content: String
//}

import Foundation

struct Alarm: Identifiable, Codable {
	var id: Int
	var time: String        // 서버에서 받는 ISO8601 string ("2025-08-06T08:00:00Z")
	var content: String
	
	// SwiftUI에서 바로 Date로 쓰고 싶을 때!
	var timeDate: Date? {
		ISO8601DateFormatter().date(from: time)
	}
}
