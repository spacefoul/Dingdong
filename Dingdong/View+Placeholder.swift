//
//  View+Placeholder.swift
//  DingDong
//
//  Created by F_s on 8/4/25.
//

import SwiftUI

extension View {
	func placeholder<Content: View>(
		when shouldShow: Bool,
		alignment: Alignment = .leading,
		@ViewBuilder placeholder: () -> Content
	) -> some View {
		ZStack(alignment: alignment) {
			if shouldShow {
				placeholder()
			}
			self
		}
	}
}
