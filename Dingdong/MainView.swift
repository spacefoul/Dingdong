//
//  MainView.swift
//  DingDong
//
//  Created by F_s on 8/1/25.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
	@EnvironmentObject var theme: ThemeManager
	@StateObject private var viewModel = AlarmViewModel()
	
	@State private var currentDate = Date()
	@State private var showingAddAlarm = false
	@State private var isTimeLeading = true
	@State private var showingCalendar = false
	
	@State private var uid: String = ""
	
	@State private var time = Date()
	@State private var content = ""
	@FocusState private var isContentFocused: Bool
	
	// 현재 날짜 기준 ±3일
	var weekDates: [Date] {
		let calendar = Calendar.current
		return (-3...3).compactMap { calendar.date(byAdding: .day, value: $0, to: currentDate) }
	}
	
	// 선택한 날짜만 필터링 + 시간순 정렬
	var filteredAlarms: [Alarm] {
		viewModel.alarms
			.filter { Calendar.current.isDate($0.dueAt, inSameDayAs: currentDate) }
			.sorted { $0.dueAt < $1.dueAt }
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
							Task { await viewModel.deleteAlarm(uid: uid, alarmId: alarm.id) }
						}
					)
					.frame(maxHeight: .infinity)
					.layoutPriority(1)
				}
				
				// 달력 오버레이
				if showingCalendar {
					Color.black.opacity(0.18)
						.ignoresSafeArea()
						.transition(.opacity)
						.zIndex(1)
						.onTapGesture { withAnimation { showingCalendar = false } }
					
					CalendarPopup(currentDate: $currentDate)
						.transition(.scale.combined(with: .opacity))
						.zIndex(2)
				}
				
				// 오른쪽 하단 + 버튼
				AddButton(showingAddAlarm: $showingAddAlarm)
					.environmentObject(theme)
					.padding([.bottom, .trailing], 24)
					.zIndex(3)
				
				// 추가 시트
				if showingAddAlarm {
					Color.black.opacity(0.3)
						.ignoresSafeArea()
						.onTapGesture { withAnimation { showingAddAlarm = false } }
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
									guard !uid.isEmpty else {
										print("❌ No UID available"); return
									}
									print("💾 Saving (as passed from sheet):", date, content)
									await viewModel.addAlarm(uid: uid, dueAt: date, content: content)
									
									withAnimation { showingAddAlarm = false }
									self.content = ""
									self.time = Date()
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
		.onAppear {
			// Firebase Auth 상태 확인 및 리스너 시작
			if let user = Auth.auth().currentUser {
				uid = user.uid
				print("🚀 User already authenticated: \(uid)")
				viewModel.startListening(uid: uid)
			} else {
				print("❌ No authenticated user on appear")
			}
			
			// Auth 상태 변화 리스너
			Auth.auth().addStateDidChangeListener { _, user in
				if let user = user {
					uid = user.uid
					print("👤 Auth state changed - user logged in: \(uid)")
					viewModel.startListening(uid: uid)
				} else {
					uid = ""
					print("👤 Auth state changed - user logged out")
				}
			}
		}
	}
}

struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		MainView()
			.environmentObject(ThemeManager())
	}
}
