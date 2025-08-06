////
////  CalendarPopup.swift
////  DingDong
////
////  Created by F_s on 8/4/25.
////
//
//import SwiftUI
//
//struct CalendarPopup: View {
//	@Binding var currentDate: Date
//	
//	var body: some View {
//		VStack {
//			DatePicker("날짜 선택", selection: $currentDate, displayedComponents: .date)
//				.datePickerStyle(GraphicalDatePickerStyle())
//				.labelsHidden()
//				.padding()
//				.background(
//					RoundedRectangle(cornerRadius: 16)
//						.fill(Color.white)
//						.shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
//				)
//		}
//		.position(x: UIScreen.main.bounds.width / 2,
//					 y: UIScreen.main.bounds.height / 2)
//	}
//}
