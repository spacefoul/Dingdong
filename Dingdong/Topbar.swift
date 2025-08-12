//
//  TopBar.swift
//  DingDong
//
//  Created by F_s on 8/4/25.
//

import SwiftUI

struct TopBar: View {
	@EnvironmentObject var theme: ThemeManager
	@Binding var currentDate: Date
	@Binding var isTimeLeading: Bool
	@Binding var showingCalendar: Bool
	
	var body: some View {
		HStack {
			Button(action: {
				withAnimation(.easeInOut(duration: 0.18)) {
					showingCalendar.toggle()
				}
			}) {
				Image(systemName: "calendar")
					.font(.title2)
					.foregroundColor(theme.primaryColor)
					.padding(10)
					.background(theme.primaryColor.opacity(0.1))
					.clipShape(Circle())
			}
			Spacer()
			Text(DateFormatter.koreanFull.string(from: currentDate))
				.font(.headline)
				.multilineTextAlignment(.center)
			Spacer()
			ToggleView(isTimeLeading: $isTimeLeading)
		}
		.padding(.horizontal)
		//.background(theme.backgroundColor)
		.background(Color.clear)
		
	}
}

extension DateFormatter {
	static let koreanFull: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy. MM. dd. (E)"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter
	}()
}
