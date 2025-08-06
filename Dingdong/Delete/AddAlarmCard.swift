////
////  AddAlarmCard.swift
////  DingDong
////
////  Created by F_s on 8/4/25.
////
//
//import SwiftUI
//
//struct AddAlarmCard: View {
//	@EnvironmentObject var theme: ThemeManager
//	@ObservedObject private var keyboard = KeyboardResponder()
//
//	@Binding var currentDate: Date
//	@Binding var time: Date
//	@Binding var content: String
//	@Binding var alarms: [Alarm]
//	@Binding var showingAddAlarm: Bool
//	
//	var body: some View {
//		VStack(spacing: 16) {
//			DatePicker("시간 설정", selection: $time, displayedComponents: .hourAndMinute)
//				.datePickerStyle(WheelDatePickerStyle())
//				.labelsHidden()
//			
//			TextField("", text: $content)
//				.placeholder(when: content.isEmpty) {
//					Text("내용을 입력하세요").foregroundColor(.gray)
//				}
//				.padding()
//				.frame(height: 50)
//				.background(Color.white)
//				.overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.4), lineWidth: 1))
//				.shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
//				.cornerRadius(12)
//			
//			Button("저장") {
//				let calendar = Calendar.current
//				var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
//				let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
//				dateComponents.hour = timeComponents.hour
//				dateComponents.minute = timeComponents.minute
//				if let combinedDate = calendar.date(from: dateComponents) {
//					let newAlarm = Alarm(time: combinedDate, content: content)
//					alarms.append(newAlarm)
//					withAnimation {
//						showingAddAlarm = false
//						content = ""
//						time = Date()
//					}
//				}
//			}
//			.fontWeight(.bold)
//			.frame(maxWidth: .infinity)
//			.padding()
//			//.background(Color.blue)
//			.background(theme.primaryColor)
//			.foregroundColor(.white)
//			.cornerRadius(10)
//		}
//		.padding()
//		.background(
//			RoundedRectangle(cornerRadius: 16)
//				.fill(Color.white)
//				.shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
//		)
//		.padding(.horizontal)
////		.position(x: UIScreen.main.bounds.width / 2,
////					 y: UIScreen.main.bounds.height / 2)
//		//.padding(.bottom, keyboard.keyboardHeight) // 👉 키보드 높이만큼 올림
//		//.animation(.easeOut(duration: 0.3), value: keyboard.keyboardHeight)
//	}
//}
