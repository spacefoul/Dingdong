////
////  ToggleView.swift
////  DingDong
////
////  Created by F_s on 8/4/25.
////
//
//import SwiftUI
//
//struct ToggleView: View {
//	@Binding var isTimeLeading: Bool
//	
//	var body: some View {
//		Button(action: {
//			withAnimation { isTimeLeading.toggle() }
//		}) {
//			Image(systemName: isTimeLeading ? "arrow.left.arrow.right.circle.fill" : "arrow.right.arrow.left.circle.fill")
//				.foregroundColor(.blue)
//				.font(.title2)
//		}
//	}
//}
//
//
//struct ToggleView_Previews: PreviewProvider {
//	static var previews: some View {
//		ToggleView(isTimeLeading: .constant(true))
//	}
//}
