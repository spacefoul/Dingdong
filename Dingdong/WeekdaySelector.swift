//
//  WeekdaySelector.swift
//  DingDong
//
//  Created by F_s on 8/4/25.
//

import SwiftUI

struct WeekdaySelector: View {
	@EnvironmentObject var theme: ThemeManager
	@Binding var currentDate: Date
	var weekDates: [Date]
	
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 14) {
				ForEach(weekDates, id: \.self) { date in
					let isSelected = Calendar.current.isDate(date, inSameDayAs: currentDate)
					VStack(spacing: 4) {
						Text(DateFormatter.koreanShort.string(from: date))
							.font(.caption)
							.foregroundColor(.gray)
						Text("\(Calendar.current.component(.day, from: date))")
							.fontWeight(isSelected ? .bold : .regular)
							.foregroundColor(isSelected ? theme.secondaryColor : theme.textColor)
					}
					.frame(width: 40, height: 60)
					.overlay(
						RoundedRectangle(cornerRadius: 10)
							.stroke(isSelected ? Color.white : Color.white.opacity(0.8), lineWidth: 3)
					)
					.background(isSelected ? Color.white : Color.white.opacity(0.6))
					.cornerRadius(10)
					.onTapGesture { currentDate = date }
					.animation(.easeInOut(duration: 0.16), value: isSelected)
				}
			}
			.padding(.horizontal)
		}
		.background(Color.clear)
	}
}

extension DateFormatter {
	static let koreanShort: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ko_KR")
		formatter.dateFormat = "E"
		return formatter
	}()
}
