//
//  AddAlarmSheet.swift
//  DingDong
//
//  Created by F_s on 8/4/25.
//

import SwiftUI
import FirebaseAuth

struct RoundedCorner: Shape {
	var radius: CGFloat = .infinity
	var corners: UIRectCorner = .allCorners
	
	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(
			roundedRect: rect,
			byRoundingCorners: corners,
			cornerRadii: CGSize(width: radius, height: radius)
		)
		return Path(path.cgPath)
	}
}

extension View {
	func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
		clipShape(RoundedCorner(radius: radius, corners: corners))
	}
}

struct AddAlarmSheet: View {
	@EnvironmentObject var theme: ThemeManager
	
	@Binding var currentDate: Date
	@Binding var time: Date
	@Binding var content: String
	@Binding var showingAddAlarm: Bool
	@FocusState.Binding var isContentFocused: Bool
	
	var onAdd: (Date, String) -> Void
	
	var body: some View {
		VStack(spacing: 0) {
			HStack {
				Spacer()
				Button("취소") {
					withAnimation {
						showingAddAlarm = false
						content = ""
						time = Date()
					}
				}
				.font(.body)
				.fontWeight(.semibold)
				.foregroundColor(.blue)
			}
			.padding()
			ScrollView {
				VStack(spacing: 16) {
					TextField("", text: $content)
						.placeholder(when: content.isEmpty) {
							Text("내용을 입력하세요").foregroundColor(.gray)
						}
						.padding()
						.frame(height: 50)
						.background(Color.white)
						.overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.4), lineWidth: 1))
						.shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
						.cornerRadius(12)
						.padding(.horizontal)
						.focused($isContentFocused)
					DatePicker("시간 설정", selection: $time, displayedComponents: .hourAndMinute)
						.datePickerStyle(WheelDatePickerStyle())
						.labelsHidden()
						.padding(.horizontal)
						.environment(\.locale, Locale(identifier: "ko_KR"))
//					Button(action: {
//						let calendar = Calendar.current
//						var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
//						let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
//						dateComponents.hour = timeComponents.hour
//						dateComponents.minute = timeComponents.minute
//						if let combinedDate = calendar.date(from: dateComponents) {
//							onAdd(combinedDate, content)
//							withAnimation {
//								showingAddAlarm = false
//								content = ""
//								time = Date()
//							}
//						}
//					}) {
//						Text("저장")
//							.fontWeight(.bold)
//							.frame(maxWidth: .infinity)
//							.padding()
//							.background(theme.primaryColor)
//							.foregroundColor(.white)
//							.cornerRadius(10)
//							.padding(.horizontal)
//					}
//					.buttonStyle(PlainButtonStyle())
					
					Button(action: {
						let calendar = Calendar.current
						var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
						let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
						dateComponents.hour = timeComponents.hour
						dateComponents.minute = timeComponents.minute
						
						if let combinedDate = calendar.date(from: dateComponents) {
							print("💾 About to save alarm:")
							print("  - Date: \(combinedDate)")
							print("  - Content: \(content)")
							print("  - UID: \(Auth.auth().currentUser?.uid ?? "nil")")
							
							onAdd(combinedDate, content)
							withAnimation {
								showingAddAlarm = false
								content = ""
								time = Date()
							}
						}
					}) {
						// ... 버튼 UI
						
												Text("저장")
													.fontWeight(.bold)
													.frame(maxWidth: .infinity)
													.padding()
													.background(theme.primaryColor)
													.foregroundColor(.white)
													.cornerRadius(10)
													.padding(.horizontal)
					}
					.buttonStyle(PlainButtonStyle())
				}
				.padding(.top)
			}
			.padding(.bottom, 20)
		}
		.background(Color(UIColor.systemBackground))
		.cornerRadius(20, corners: [.topLeft, .topRight])
		.shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -4)
		.transition(.move(edge: .bottom))
		.ignoresSafeArea(edges: .bottom)
		.onAppear {
			isContentFocused = true
		}
	}
}
