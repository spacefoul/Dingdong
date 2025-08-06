//
//  AlarmViewModel.swift
//  DingDong
//
//  Created by F_s on 8/6/25.
//

import Foundation

@MainActor
class AlarmViewModel: ObservableObject {
	@Published var alarms: [Alarm] = []
	let baseURL = "http://127.0.0.1:8000/api/alarms/"
	
	func fetchAlarms() async {
		guard let url = URL(string: baseURL) else { return }
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			let decoded = try JSONDecoder().decode([Alarm].self, from: data)
			self.alarms = decoded
		} catch {
			print("알람 불러오기 실패: \(error)")
		}
	}
	
	func addAlarm(time: Date, content: String) async {
		guard let url = URL(string: baseURL) else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let isoTime = ISO8601DateFormatter().string(from: time)
		let alarm = Alarm(id: 0, time: isoTime, content: content)
		
		request.httpBody = try? JSONEncoder().encode(alarm)
		
		do {
			let (data, _) = try await URLSession.shared.data(for: request)
			let newAlarm = try JSONDecoder().decode(Alarm.self, from: data)
			self.alarms.append(newAlarm)
		} catch {
			print("알람 추가 실패: \(error)")
		}
	}
	
	func deleteAlarm(alarmID: Int) async {
		guard let url = URL(string: "\(baseURL)\(alarmID)") else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "DELETE"
		do {
			_ = try await URLSession.shared.data(for: request)
			self.alarms.removeAll { $0.id == alarmID }
		} catch {
			print("알람 삭제 실패: \(error)")
		}
	}
}
