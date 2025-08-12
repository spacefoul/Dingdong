//
//  LocalNotification.swift
//  Dingdong
//
//  Created by F_s on 8/11/25.
//

import Foundation
import UserNotifications

enum LocalNotification {
	static func requestPermissionIfNeeded() async {
		let c = UNUserNotificationCenter.current()
		let s = await c.notificationSettings()
		guard s.authorizationStatus != .authorized else { return }
		_ = try? await c.requestAuthorization(options: [.alert, .sound, .badge])
	}
	static func schedule(id: String, title: String, body: String, fireDate: Date) async {
		let content = UNMutableNotificationContent()
		content.title = title
		content.body  = body
		content.sound = .default
		let comps = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: fireDate)
		let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
		try? await UNUserNotificationCenter.current().add(
			UNNotificationRequest(identifier: id, content: content, trigger: trigger)
		)
	}
	static func cancel(id: String) async {
		await UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
		await UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
	}
	static func rescheduleAll(_ items: [(id:String,title:String,body:String,fireDate:Date)], horizonDays:Int=30) async {
		await UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
		let horizon = Calendar.current.date(byAdding: .day, value: horizonDays, to: Date())!
		for it in items where it.fireDate > Date() && it.fireDate <= horizon {
			await schedule(id: it.id, title: it.title, body: it.body, fireDate: it.fireDate)
		}
	}
	static func enableForegroundPresentation() {
		UNUserNotificationCenter.current().delegate = ForegroundDelegate.shared
	}
	private final class ForegroundDelegate: NSObject, UNUserNotificationCenterDelegate {
		static let shared = ForegroundDelegate()
		func userNotificationCenter(_ c: UNUserNotificationCenter, willPresent n: UNNotification) async
		-> UNNotificationPresentationOptions { [.banner, .sound, .badge] }
	}
}
