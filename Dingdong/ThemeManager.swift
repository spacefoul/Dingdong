//
//  ThemeManager.swift
//  DingDong
//
//  Created by F_s on 8/4/25.
//

import SwiftUI

final class ThemeManager: ObservableObject {
	@AppStorage("selectedThemeName") private var selectedThemeName: String = "Blue"
	
	// 라이트/다크 모드 설정 저장
	@AppStorage("preferredColorScheme") private var preferredSchemeRaw: String = "system"
	
	@Published var userPreferredColorScheme: ColorScheme? {
		didSet {
			switch userPreferredColorScheme {
				case .light: preferredSchemeRaw = "light"
				case .dark: preferredSchemeRaw = "dark"
				default: preferredSchemeRaw = "system"
			}
		}
	}
	
	@Published var primaryColor: Color = .blue
	@Published var secondaryColor: Color = .cyan
	@Published var backgroundColor: Color = Color.gray.opacity(0.03)
	@Published var textColor: Color = .primary
	@Published var cardBackground: Color = .white
	@Published var cardShadow: Color = .black.opacity(0.1)
	@Published var inactiveBackground: Color = Color.gray.opacity(0.1)
	@Published var borderColor: Color = Color.gray.opacity(0.4)
	
	//@Published var userPreferredColorScheme: ColorScheme? = nil
	
	init() {
		if let saved = availableThemes.first(where: { $0.name == selectedThemeName }) {
			applyTheme(saved)
		}
		
		// 모드 적용
		switch preferredSchemeRaw {
			case "light": userPreferredColorScheme = .light
			case "dark": userPreferredColorScheme = .dark
			default: userPreferredColorScheme = nil // system
		}
	}
	
	func applyTheme(_ option: ThemeColorOption) {
		primaryColor = option.primaryColor
		secondaryColor = option.secondaryColor
		backgroundColor = option.backgroundColor
		textColor = option.textColor
		cardBackground = option.cardBackground
		cardShadow = option.cardShadow
		inactiveBackground = option.inactiveBackground
		borderColor = option.borderColor
		
		// 테마 이름 저장
		selectedThemeName = option.name
	}
}

