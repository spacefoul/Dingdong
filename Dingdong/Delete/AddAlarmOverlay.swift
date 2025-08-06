////
////  AddAlarmOverlay.swift
////  DingDong
////
////  Created by F_s on 8/4/25.
////
//
//import SwiftUI
//
//struct AddAlarmOverlay: View {
//	// 필요한 바인딩 변수들
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
//		ZStack {
//			// 배경 클릭 시 닫기
//			if showingAddAlarm {
//				Color.black.opacity(0.3)
//					.ignoresSafeArea()
//					.onTapGesture {
//						withAnimation { showingAddAlarm = false }
//					}
//			}
//			
//			// 카드와 버튼 같이 배치
//			VStack(spacing: 20) {
//				AddAlarmCard(
//					currentDate: $currentDate,
//					time: $time,
//					content: $content,
//					alarms: $alarms,
//					showingAddAlarm: $showingAddAlarm
//				)
//				
//				AddButton(showingAddAlarm: $showingAddAlarm)
//			}
//			// 키보드가 뜨면 위로 자연스럽게 이동
//			.offset(y: -keyboardOffset)
//			.animation(.easeOut(duration: 0.3), value: keyboard.keyboardHeight)
//		}
//	}
//	
//	private var keyboardOffset: CGFloat {
//		let safeMargin: CGFloat = 30
//		let maxMove = UIScreen.main.bounds.height / 2
//		return keyboard.keyboardHeight > 0
//		? min(keyboard.keyboardHeight - safeMargin, maxMove)
//		: 0
//	}
//}
