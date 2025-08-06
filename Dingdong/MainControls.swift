//
//  MainControls.swift
//  DingDong
//
//  Created by F_s on 8/4/25.
//

import SwiftUI

struct ToggleView: View {
	@EnvironmentObject var theme: ThemeManager
	@Binding var isTimeLeading: Bool
	
	var body: some View {
		Button(action: {
			withAnimation { isTimeLeading.toggle() }
		}) {
			Image(systemName: isTimeLeading ? "arrow.left.arrow.right.circle.fill" : "arrow.right.arrow.left.circle.fill")
				.foregroundColor(theme.primaryColor)
				.font(.title2)
		}
	}
}

struct AddButton: View {
	@EnvironmentObject var theme: ThemeManager
	@Binding var showingAddAlarm: Bool
	
	var body: some View {
		Button(action: {
			withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
				showingAddAlarm.toggle()
			}
		}) {
			Image(systemName: "plus")
				.font(.system(size: 24, weight: .bold))
				.foregroundColor(.white)
				.padding()
				.background(showingAddAlarm ? theme.borderColor : theme.primaryColor)
				.clipShape(Circle())
				.shadow(radius: 4)
				.rotationEffect(.degrees(showingAddAlarm ? 45 : 0))
				.scaleEffect(showingAddAlarm ? 1.2 : 1.0)
				.padding()
		}
	}
}

struct CalendarPopup: View {
	@EnvironmentObject var theme: ThemeManager
	@Binding var currentDate: Date
	
	var body: some View {
		VStack {
			DatePicker("날짜 선택", selection: $currentDate, displayedComponents: .date)
				.datePickerStyle(GraphicalDatePickerStyle())
				.labelsHidden()
				.tint(theme.primaryColor)
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 16)
						.fill(Color.white)
						.shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
				)
		}
		.padding()
		.position(x: UIScreen.main.bounds.width / 2,
					 y: UIScreen.main.bounds.height / 2)
	}
}
