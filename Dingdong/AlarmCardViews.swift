//
//  AlarmCardViews.swift
//  DingDong
//
//  Created by F_s on 8/4/25.
//

import SwiftUI

struct AlarmView: View {
	@EnvironmentObject var theme: ThemeManager
	var alarm: Alarm
	var isTimeLeading: Bool
	
	var body: some View {
		HStack {
			if isTimeLeading {
				Text(timeFormatted(alarm.time)).bold()
				Spacer()
				Text(alarm.content).foregroundColor(theme.textColor)
			} else {
				Text(alarm.content).foregroundColor(theme.textColor)
				Spacer()
				Text(timeFormatted(alarm.time)).bold()
			}
		}
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 12)
				.fill(theme.cardBackground)
				.shadow(color: theme.cardShadow, radius: 4, x: 0, y: 2)
		)
	}
	
	// time(ISO8601 String) → Date 변환 → 포맷팅
	func timeFormatted(_ isoTime: String) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "a hh:mm"
		formatter.amSymbol = "오전"
		formatter.pmSymbol = "오후"
		formatter.locale = Locale(identifier: "ko_KR")
		
		if let date = ISO8601DateFormatter().date(from: isoTime) {
			return formatter.string(from: date)
		} else {
			return "오류"
		}
	}
}

struct AlarmView_Previews: PreviewProvider {
	static var previews: some View {
		// ISO8601 형식 예시
		let exampleTime = ISO8601DateFormatter().string(from: Date())
		AlarmView(
			alarm: Alarm(id: 1, time: exampleTime, content: "기상"),
			isTimeLeading: true
		)
		.padding()
		.environmentObject(ThemeManager())
	}
}

// -------------------------------------
// 아래는 그대로 사용 (변경 거의 없음)
// -------------------------------------

struct SwipeToDeleteView<Content: View>: View {
	let onDelete: () -> Void
	let content: () -> Content
	
	@State private var offset: CGFloat = 0
	@GestureState private var dragOffset: CGFloat = 0
	
	var body: some View {
		ZStack(alignment: .trailing) {
			if offset < -10 || dragOffset < -10 {
				Image(systemName: "trash")
					.font(.system(size: 20, weight: .bold))
					.foregroundColor(.cyan)
					.padding(.trailing, 20)
			}
			content()
				.offset(x: offset + dragOffset)
				.gesture(
					DragGesture()
						.updating($dragOffset) { value, state, _ in
							if value.translation.width < 0 {
								state = value.translation.width
							}
						}
						.onEnded { value in
							if value.translation.width < -120 {
								onDelete()
							} else if value.translation.width < -60 {
								withAnimation { offset = -80 }
							} else {
								withAnimation { offset = 0 }
							}
						}
				)
		}
		.clipShape(RoundedRectangle(cornerRadius: 15))
		.frame(height: 60)
	}
}

struct SwipeToDeleteView_Previews: PreviewProvider {
	static var previews: some View {
		SwipeToDeleteView(onDelete: {}) {
			Text("오늘의 할 일")
				.padding()
				.background(Color.white)
		}
		.padding()
		.background(Color.gray.opacity(0.2))
	}
}
