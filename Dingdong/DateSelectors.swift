//
//  DateSelectors.swift
//  DingDong
//
//  Created by F_s on 8/4/25.
//

import SwiftUI

struct DateSelectors: View {
	@Binding var currentDate: Date
	@Binding var isTimeLeading: Bool
	@Binding var showingCalendar: Bool
	@EnvironmentObject var theme: ThemeManager
	
	var body: some View {
		VStack(spacing: 0) {
			TopBar(
				currentDate: $currentDate,
				isTimeLeading: $isTimeLeading,
				showingCalendar: $showingCalendar
			)
			.padding(.bottom)
			WeekdaySelector(
				currentDate: $currentDate,
				weekDates: Self.makeWeekDates(from: currentDate)
			)
		}
		//.background(theme.backgroundColor)
		.background(Color.clear)
		// **animation은 MainView 등 상위 ZStack에서 전체로 통제하는 게 더 자연스러움**
	}
	
	static func makeWeekDates(from date: Date) -> [Date] {
		let calendar = Calendar.current
		return (-3...3).compactMap { offset in
			calendar.date(byAdding: .day, value: offset, to: date)
		}
	}
}
