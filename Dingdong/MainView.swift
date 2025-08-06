//
//  MainView.swift
//  DingDong
//
//  Created by F_s on 8/1/25.
//

import SwiftUI

// MARK: - MainView

struct MainView: View {
	@EnvironmentObject var theme: ThemeManager
	@StateObject private var viewModel = AlarmViewModel()
	
	@State private var currentDate = Date()
	@State private var showingAddAlarm = false
	@State private var isTimeLeading = true
	@State private var showingCalendar = false
	@State private var time = Date()
	@State private var content = ""
	@FocusState private var isContentFocused: Bool
	
	var weekDates: [Date] {
		let calendar = Calendar.current
		return (-3...3).compactMap { offset in
			calendar.date(byAdding: .day, value: offset, to: currentDate)
		}
	}
	
	var filteredAlarms: [Alarm] {
		viewModel.alarms
			.filter {
				guard let alarmDate = $0.timeDate else { return false }
				return Calendar.current.isDate(alarmDate, inSameDayAs: currentDate)
			}
			.sorted {
				($0.timeDate ?? Date()) < ($1.timeDate ?? Date())
			}
	}
	
	var body: some View {
		NavigationView {
			ZStack(alignment: .bottomTrailing) {
				theme.backgroundColor.ignoresSafeArea()
				
				VStack(spacing: 16) {
					Spacer(minLength: 4)
					
					DateSelectors(
						currentDate: $currentDate,
						isTimeLeading: $isTimeLeading,
						showingCalendar: $showingCalendar
					)
					.environmentObject(theme)
					
					AlarmListView(
						filteredAlarms: filteredAlarms,
						isTimeLeading: isTimeLeading,
						onDelete: { alarm in
							Task { await viewModel.deleteAlarm(alarmID: alarm.id) }
						}
					)
				}
				
				// 달력 팝업 오버레이
				if showingCalendar {
					Color.black.opacity(0.18)
						.ignoresSafeArea()
						.transition(.opacity)
						.zIndex(1)
						.onTapGesture {
							withAnimation { showingCalendar = false }
						}
					CalendarPopup(currentDate: $currentDate)
						.transition(.scale.combined(with: .opacity))
						.zIndex(2)
				}
				
				// ✅ 플러스 버튼: "오른쪽 하단" 고정!
				AddButton(showingAddAlarm: $showingAddAlarm)
					.environmentObject(theme)
					.padding([.bottom, .trailing], 24)
					.zIndex(3)
				
				// 알람 추가 시트
				if showingAddAlarm {
					Color.black.opacity(0.3)
						.ignoresSafeArea()
						.onTapGesture {
							withAnimation { showingAddAlarm = false }
						}
						.zIndex(4)
					
					VStack {
						Spacer()
						AddAlarmSheet(
							currentDate: $currentDate,
							time: $time,
							content: $content,
							showingAddAlarm: $showingAddAlarm,
							isContentFocused: $isContentFocused,
							onAdd: { date, content in
								Task {
									await viewModel.addAlarm(time: date, content: content)
								}
							}
						)
						.environmentObject(theme)
					}
					.transition(.move(edge: .bottom))
					.zIndex(5)
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					NavigationLink(destination: ThemeSettingsView()) {
						Image(systemName: "paintpalette")
							.foregroundColor(theme.primaryColor)
					}
				}
			}
		}
		.preferredColorScheme(theme.userPreferredColorScheme)
		.animation(.easeInOut(duration: 0.17), value: showingCalendar)
		.animation(.easeInOut(duration: 0.17), value: showingAddAlarm)
		.animation(.easeInOut(duration: 0.14), value: currentDate)
		.task {
			await viewModel.fetchAlarms()
		}
	}
}

struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		MainView()
			.environmentObject(ThemeManager())
	}
}
