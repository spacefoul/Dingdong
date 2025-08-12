//
//  ThemeSettingsView.swift
//  DingDong
//
//  Created by F_s on 8/4/25.
//

import SwiftUI

struct ThemeColorOption: Identifiable {
	let id = UUID()
	let name: String
	let primaryColor: Color
	let secondaryColor: Color
	let backgroundColor: Color
	let textColor: Color
	let cardBackground: Color
	let cardShadow: Color
	let inactiveBackground: Color
	let borderColor: Color
}

let availableThemes: [ThemeColorOption] = [
	.init(name: "Blue", primaryColor: .blue.opacity(0.8), secondaryColor: .cyan, backgroundColor: Color.blue.opacity(0.05), textColor: .primary, cardBackground: Color.blue.opacity(0.1), cardShadow: Color.black.opacity(0.1), inactiveBackground: Color.gray.opacity(0.1), borderColor: Color.gray.opacity(0.4)),
	.init(name: "Red", primaryColor: .red.opacity(0.8), secondaryColor: .pink, backgroundColor: Color.red.opacity(0.05), textColor: .black, cardBackground: Color.red.opacity(0.1), cardShadow: .clear, inactiveBackground: Color.red.opacity(0.2), borderColor: Color.brown.opacity(0.4)),
	.init(name: "Green", primaryColor: .green.opacity(0.8), secondaryColor: .mint, backgroundColor: Color.green.opacity(0.05), textColor: .black, cardBackground: Color.green.opacity(0.1), cardShadow: Color.black.opacity(0.05), inactiveBackground: Color.green.opacity(0.1), borderColor: Color.green.opacity(0.4)),
	.init(name: "Purple", primaryColor: .purple.opacity(0.8), secondaryColor: .indigo, backgroundColor: Color.purple.opacity(0.05), textColor: .primary, cardBackground: Color.purple.opacity(0.1), cardShadow: .clear, inactiveBackground: Color.purple.opacity(0.1), borderColor: Color.purple.opacity(0.4)),
	.init(name: "Orange", primaryColor: .orange.opacity(0.8), secondaryColor: .yellow, backgroundColor: Color.orange.opacity(0.05), textColor: .black, cardBackground: Color.orange.opacity(0.1), cardShadow: Color.black.opacity(0.1), inactiveBackground: Color.orange.opacity(0.1), borderColor: Color.orange.opacity(0.4)),
	.init(name: "Black", primaryColor: .black.opacity(0.8), secondaryColor: .gray, backgroundColor: Color.secondary.opacity(0.05), textColor: .primary, cardBackground: Color.gray.opacity(0.1), cardShadow: Color.black.opacity(0.1), inactiveBackground: Color.gray.opacity(0.1), borderColor: Color.gray.opacity(0.4))
	
]


struct ThemeSettingsView: View {
	@EnvironmentObject var theme: ThemeManager
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(alignment: .leading, spacing: 24) {
					Text("기본 테마 선택")
						.font(.headline)
						.padding(.horizontal)
					
					LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 28) {
						ForEach(availableThemes) { option in
							VStack(spacing: 10) {
								ZStack {
									// 선택된 원만 Glow 효과
									if theme.primaryColor == option.primaryColor {
										Circle()
											.fill(option.primaryColor.opacity(0.28))
											.frame(width: 48, height: 48)
											.blur(radius: 1.5)
											.offset(y: 2)
									}
									// 컬러 원(고정 크기)
									Circle()
										.fill(option.primaryColor)
										.frame(width: 48, height: 48)
										.overlay(
											Circle()
												.strokeBorder(theme.primaryColor == option.primaryColor ? Color.white : Color.clear, lineWidth: 4)
										)
									
									// 선택된 원 오른쪽 위에 작은 체크
									if theme.primaryColor == option.primaryColor {
										Circle()
											.fill(Color.white)
											.frame(width: 18, height: 18)
											.overlay(
												Image(systemName: "checkmark")
													.font(.system(size: 11, weight: .bold))
													.foregroundColor(option.primaryColor)
											)
											.offset(x: 15, y: -15)
									}
								}
								.onTapGesture {
									theme.applyTheme(option)
								}
								// 아래에 테마명
								Text(option.name)
									.font(.caption)
									.fontWeight(theme.primaryColor == option.primaryColor ? .bold : .regular)
									.foregroundColor(theme.primaryColor == option.primaryColor ? .primary : .gray)
							}
							.padding(.vertical, 2)
						}
					}
					.padding(.horizontal, 8)
					
					
					
					
					
					Spacer()
					
					Text("테마 모드 설정")
						.font(.headline)
						.padding(.horizontal)
					
					HStack(spacing: 16) {
						ThemeModeCard(
							icon: "sun.max.fill",
							title: "라이트",
							selected: theme.userPreferredColorScheme == .light,
							action: {
								withAnimation {
									theme.userPreferredColorScheme = .light
								}
							}
						)
						ThemeModeCard(
							icon: "moon.fill",
							title: "다크",
							selected: theme.userPreferredColorScheme == .dark,
							action: {
								withAnimation {
									theme.userPreferredColorScheme = .dark
								}
							}
						)
					}
					.padding(.horizontal)
					
					
				}
				.padding(.top)
			}
			.background(Color(.systemBackground)) // ✅ 시스템 배경색 적용
			.ignoresSafeArea(edges: .bottom)     // ✅ 스크롤뷰 하단까지 채움
			.navigationTitle("테마 설정")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Button("완료") {
						dismiss()
					}
				}
			}
		}
	}
}


struct ThemeModeCard: View {
	let icon: String
	let title: String
	let selected: Bool
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			ZStack(alignment: .topTrailing) {
				// ✨ 선택된 카드만 Glow 효과 (밝은 빛)
				if selected {
					RoundedRectangle(cornerRadius: 16)
						.fill(Color.white)
						.frame(maxWidth: .infinity)
						.blur(radius: 7)
						.opacity(0.23)
						.padding(-7)
				}
				VStack(spacing: 8) {
					Image(systemName: icon)
						.font(.title)
						.foregroundColor(selected ? .white : .gray.opacity(0.75))
					Text(title)
						.font(.subheadline)
						.foregroundColor(selected ? .white : .gray.opacity(0.85))
				}
				.padding(.vertical, 16)
				.frame(maxWidth: .infinity)
				.background(
					RoundedRectangle(cornerRadius: 16)
						.fill(selected ? Color.gray.opacity(0.7) : Color.white)
						.shadow(
							color: Color.black.opacity(selected ? 0.10 : 0.06), // ✅ 입체감!
							radius: selected ? 8 : 3,
							x: 0, y: selected ? 6 : 2
						)
				)
				.overlay(
					RoundedRectangle(cornerRadius: 16)
						.stroke(
							selected
							? Color.gray.opacity(0.6)
							: Color.gray.opacity(0.16),
							lineWidth: 1.7
						)
				)
				
				// ✅ 우측 상단 체크 표시
				if selected {
					Circle()
						.fill(Color.white)
						.frame(width: 20, height: 20)
						.overlay(
							Image(systemName: "checkmark")
								.font(.system(size: 13, weight: .bold))
								.foregroundColor(Color.gray.opacity(0.7))
						)
						.offset(x: -10, y: 10)
				}
			}
		}
		.buttonStyle(.plain)
	}
}



struct ThemeSettingsView_Previews: PreviewProvider {
	static var previews: some View {
		ThemeSettingsView()
			.environmentObject(ThemeManager())
	}
}
