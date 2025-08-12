//
//  AlarmListView.swift
//  DingDong
//
//  Created by F_s on 8/4/25.
//

import SwiftUI

struct AlarmListView: View {
	var filteredAlarms: [Alarm]
	var isTimeLeading: Bool
	var onDelete: (Alarm) -> Void
	
	var body: some View {
		if filteredAlarms.isEmpty {
			VStack(spacing: 12) { /* 빈 상태 UI */ }
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		} else {
			List {
				ForEach(filteredAlarms) { alarm in
					AlarmView(alarm: alarm, isTimeLeading: isTimeLeading)
						.listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
						.listRowBackground(Color.clear)
						.listRowSeparator(.hidden) // 🔹 행 구분선 숨김
				}
				.onDelete { indexSet in
					indexSet.compactMap { filteredAlarms[$0] }.forEach(onDelete)
				}
			}
			.listStyle(.plain)
			.scrollIndicators(.visible)
			.scrollContentBackground(.hidden) // 선택: 리스트 기본 배경 제거
			.modifier(HideSectionSeparatorIfAvailable()) // 🔹 섹션 구분선도 가능하면 숨김(iOS16+)
		}
	}
}

/// iOS 16+에서만 섹션 구분선 숨김 가능
private struct HideSectionSeparatorIfAvailable: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 16.0, *) {
			content
				.listSectionSeparator(.hidden)
		} else {
			content
		}
	}
}
