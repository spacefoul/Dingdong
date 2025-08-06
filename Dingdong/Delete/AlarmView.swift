////
////  AlarmView.swift
////  DingDong
////
////  Created by F_s on 8/4/25.
////
//
//import SwiftUI
//
//struct AlarmView: View {
//	var alarm: Alarm
//	var isTimeLeading: Bool
//	
//	var body: some View {
//		HStack {
//			if isTimeLeading {
//				Text(timeFormatted(alarm.time)).bold()
//				Spacer()
//				Text(alarm.content).foregroundColor(.gray)
//			} else {
//				Text(alarm.content).foregroundColor(.gray)
//				Spacer()
//				Text(timeFormatted(alarm.time)).bold()
//			}
//		}
//		.padding()
//		.background(
//			RoundedRectangle(cornerRadius: 12)
//				.fill(Color.white)
//				.shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
//		)
//	}
//	
//	func timeFormatted(_ date: Date) -> String {
//		let formatter = DateFormatter()
//		formatter.dateFormat = "a hh:mm"
//		formatter.amSymbol = "오전"
//		formatter.pmSymbol = "오후"
//		formatter.locale = Locale(identifier: "ko_KR")
//		return formatter.string(from: date)
//	}
//}
//
////
////#Preview {
////    AlarmView()
////}
