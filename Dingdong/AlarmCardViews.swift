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
				Text(timeFormatted(alarm.dueAt)).bold()
				Spacer()
				Text(alarm.content).foregroundColor(theme.textColor)
			} else {
				Text(alarm.content).foregroundColor(theme.textColor)
				Spacer()
				Text(timeFormatted(alarm.dueAt)).bold()
			}
		}
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 12)
				.fill(theme.cardBackground)
				.shadow(color: theme.cardShadow, radius: 4, x: 0, y: 2)
		)
	}
	
	// Date → "오전 09:30" 포맷
	private func timeFormatted(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "a hh:mm"
		formatter.amSymbol = "오전"
		formatter.pmSymbol = "오후"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter.string(from: date)
	}
}

struct AlarmView_Previews: PreviewProvider {
	static var previews: some View {
		AlarmView(
			alarm: Alarm(id: "preview-1", dueAt: Date(), content: "기상"),
			isTimeLeading: true
		)
		.padding()
		.environmentObject(ThemeManager())
	}
}

// -------------------------------------
// 아래는 그대로 사용 (스와이프 삭제 뷰)
// -------------------------------------

struct SwipeToDeleteView<Content: View>: View {
	let onDelete: () -> Void
	let content: () -> Content
	
	@State private var offset: CGFloat = 0
	@GestureState private var dragOffset: CGFloat = 0
	@State private var isHandlingHorizontal = false
	@State private var decided = false
	
	var body: some View {
		ZStack(alignment: .trailing) {
			if offset < -10 || dragOffset < -10 {
				Image(systemName: "trash")
					.font(.system(size: 20, weight: .bold))
					.foregroundColor(.cyan)
					.padding(.trailing, 20)
			}
			
			content()
				.contentShape(Rectangle()) // 터치 영역 명확히
				.offset(x: offset + dragOffset)
				.gesture(
					DragGesture(minimumDistance: 8)
						.onChanged { value in
							// 최초 판정: 수평/수직 중 어느 쪽인지
							if !decided {
								decided = true
								isHandlingHorizontal = abs(value.translation.width) > abs(value.translation.height)
							}
						}
						.updating($dragOffset) { value, state, _ in
							// 수평 제스처일 때만 내부 offset 갱신
							guard isHandlingHorizontal, value.translation.width < 0 else { return }
							state = value.translation.width
						}
						.onEnded { value in
							defer { decided = false; isHandlingHorizontal = false }
							guard isHandlingHorizontal else { return } // 세로 스크롤이면 패스
							
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
