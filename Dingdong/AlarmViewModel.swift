//
//  AlarmViewModel.swift
//  DingDong
//
//  Created by F_s on 8/6/25.
//

//import Foundation
//
//@MainActor
//class AlarmViewModel: ObservableObject {
//	@Published var alarms: [Alarm] = []
//	//let baseURL = "http://127.0.0.1:8000/api/alarms/"
//	let baseURL = "https://port-0-dingdong-backend-mdzj7ny9b8377a6d.sel5.cloudtype.app/api/alarms/"
//	
//	
//	
//	func fetchAlarms() async {
//		guard let url = URL(string: baseURL) else { return }
//		do {
//			let (data, _) = try await URLSession.shared.data(from: url)
//			let decoded = try JSONDecoder().decode([Alarm].self, from: data)
//			self.alarms = decoded
//		} catch {
//			print("알람 불러오기 실패: \(error)")
//		}
//	}
//	
//	func addAlarm(time: Date, content: String) async {
//		guard let url = URL(string: baseURL) else { return }
//		var request = URLRequest(url: url)
//		request.httpMethod = "POST"
//		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//		
//		let isoTime = ISO8601DateFormatter().string(from: time)
//		let alarm = Alarm(id: 0, time: isoTime, content: content)
//		
//		request.httpBody = try? JSONEncoder().encode(alarm)
//		
//		do {
//			let (data, _) = try await URLSession.shared.data(for: request)
//			let newAlarm = try JSONDecoder().decode(Alarm.self, from: data)
//			self.alarms.append(newAlarm)
//		} catch {
//			print("알람 추가 실패: \(error)")
//		}
//	}
//	
//	func deleteAlarm(alarmID: Int) async {
//		guard let url = URL(string: "\(baseURL)\(alarmID)") else { return }
//		var request = URLRequest(url: url)
//		request.httpMethod = "DELETE"
//		do {
//			_ = try await URLSession.shared.data(for: request)
//			self.alarms.removeAll { $0.id == alarmID }
//		} catch {
//			print("알람 삭제 실패: \(error)")
//		}
//	}
//}


//위에는 클라우드 타입 이용해서 했던 거


//
//  AlarmViewModel.swift
//  DingDong
//
//
//import Foundation
//import FirebaseFirestore
////import FirebaseFirestoreSwift
//
//// Firestore 전송/수신용 모델
//private struct AlarmFS: Codable {
//	@DocumentID var id: String?
//	var dueAt: Timestamp
//	var content: String
//	var createdAt: Timestamp?
//	var updatedAt: Timestamp?
//	var enabled: Bool?
//	
//	init(from a: Alarm) {
//		self.id = a.id
//		self.dueAt = Timestamp(date: a.dueAt)
//		self.content = a.content
//		self.createdAt = Timestamp(date: Date())
//		self.updatedAt = Timestamp(date: Date())
//		self.enabled = true
//	}
//	
//	func toUI() -> Alarm {
//		Alarm(id: id ?? UUID().uuidString, dueAt: dueAt.dateValue(), content: content)
//	}
//}
//
//@MainActor
//final class AlarmViewModel: ObservableObject {
//	@Published var alarms: [Alarm] = []
//	
//	private let db = Firestore.firestore()
//	private var listener: ListenerRegistration?
//	
//	private func col(uid: String) -> CollectionReference {
//		db.collection("users").document(uid).collection("alarms")
//	}
//	
//	// 실시간 구독
//	func startListening(uid: String) {
//		listener?.remove()
//		listener = col(uid: uid)
//			.order(by: "dueAt")
//			.addSnapshotListener { [weak self] snap, err in
//				if let err = err { print("listen error:", err); return }
//				let items: [Alarm] = snap?.documents.compactMap { try? $0.data(as: AlarmFS.self).toUI() } ?? []
//				print("👂 snapshot count:", items.count)            // ✅
//				Task { @MainActor in self?.alarms = items }
//			}
//
//	}
//	
//	// 추가
//	func addAlarm(uid: String, dueAt: Date, content: String) async {
//		let id = UUID().uuidString
//		let fs = AlarmFS(from: Alarm(id: id, dueAt: dueAt, content: content))
//		do {
//			try col(uid: uid).document(id).setData(from: fs)   // ✅ try? → try + do/catch
//			print("✅ saved:", id, dueAt, content)
//			await LocalNotification.schedule(id: id, title: "할 일 알림", body: content, fireDate: dueAt)
//		} catch {
//			print("❌ addAlarm error:", error)                  // ✅ 실패 이유 로그로 확인
//		}
//	}
//
//	// 삭제
//	func deleteAlarm(uid: String, alarmId: String) async {
//		do {
//			try await col(uid: uid).document(alarmId).delete()
//			await LocalNotification.cancel(id: alarmId)
//		} catch { print("delete error:", error) }
//	}
//	
//	deinit { listener?.remove() }
//}


import Foundation
import FirebaseFirestore

// Firestore 전송/수신용 모델
private struct AlarmFS: Codable {
	@DocumentID var id: String?
	var dueAt: Timestamp
	var content: String
	var createdAt: Timestamp?
	var updatedAt: Timestamp?
	var enabled: Bool?
	
	init(from a: Alarm) {
		self.id = a.id
		self.dueAt = Timestamp(date: a.dueAt)
		self.content = a.content
		self.createdAt = Timestamp(date: Date())
		self.updatedAt = Timestamp(date: Date())
		self.enabled = true
	}
	
	func toUI() -> Alarm {
		Alarm(id: id ?? UUID().uuidString, dueAt: dueAt.dateValue(), content: content)
	}
}

@MainActor
final class AlarmViewModel: ObservableObject {
	@Published var alarms: [Alarm] = []
	
	private let db = Firestore.firestore()
	private var listener: ListenerRegistration?
	
	private func col(uid: String) -> CollectionReference {
		db.collection("users").document(uid).collection("alarms")
	}
	
	// 실시간 구독
	func startListening(uid: String) {
		print("🚀 Starting listener for uid: \(uid)")
		listener?.remove()
		listener = col(uid: uid)
			.order(by: "dueAt")
			.addSnapshotListener { [weak self] snap, err in
				if let err = err {
					print("❌ listen error:", err)
					return
				}
				
				guard let documents = snap?.documents else {
					print("⚠️ No documents found")
					return
				}
				
				let items: [Alarm] = documents.compactMap { doc in
					do {
						return try doc.data(as: AlarmFS.self).toUI()
					} catch {
						print("❌ Failed to decode document \(doc.documentID): \(error)")
						return nil
					}
				}
				
				print("👂 snapshot count: \(items.count)")
				Task { @MainActor in
					self?.alarms = items
					print("✅ UI updated with \(items.count) alarms")
				}
			}
	}
	
	// 추가
	func addAlarm(uid: String, dueAt: Date, content: String) async {
		let id = UUID().uuidString
		let alarm = Alarm(id: id, dueAt: dueAt, content: content)
		let fs = AlarmFS(from: alarm)
		
		do {
			// Firestore 작업을 백그라운드에서 실행
			try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
				do {
					try col(uid: uid).document(id).setData(from: fs) { error in
						if let error = error {
							continuation.resume(throwing: error)
						} else {
							continuation.resume()
						}
					}
				} catch {
					continuation.resume(throwing: error)
				}
			}
			
			print("✅ saved: \(id), \(dueAt), \(content)")
			
			// 로컬 알림 스케줄링 (LocalNotification 클래스가 있는 경우에만)
			 await LocalNotification.schedule(id: id, title: "딩동", body: content, fireDate: dueAt)
			
		} catch {
			print("❌ addAlarm error: \(error)")
		}
	}
	
	// 삭제
	func deleteAlarm(uid: String, alarmId: String) async {
		do {
			try await col(uid: uid).document(alarmId).delete()
			print("✅ deleted: \(alarmId)")
			
			// 로컬 알림 취소 (LocalNotification 클래스가 있는 경우에만)
			// await LocalNotification.cancel(id: alarmId)
			
		} catch {
			print("❌ delete error: \(error)")
		}
	}
	
	deinit {
		listener?.remove()
		print("🧹 AlarmViewModel deinitialized")
	}
}
