////
////  AddButton.swift
////  DingDong
////
////  Created by F_s on 8/4/25.
////
//
//import SwiftUI
//
//struct AddButton: View {
//	@Binding var showingAddAlarm: Bool
//	
//	var body: some View {
//		Button(action: {
//			withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
//				showingAddAlarm.toggle()
//			}
//		}) {
//			Image(systemName: "plus")
//				.font(.system(size: 24, weight: .bold))
//				.foregroundColor(.white)
//				.padding()
//				.background(showingAddAlarm ? Color.gray : Color.blue)
//				.clipShape(Circle())
//				.shadow(radius: 4)
//				.rotationEffect(.degrees(showingAddAlarm ? 45 : 0))
//				.scaleEffect(showingAddAlarm ? 1.2 : 1.0)
//				.padding()
//		}
//	}
//}
