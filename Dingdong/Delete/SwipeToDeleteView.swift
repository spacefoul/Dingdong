////
////  SwipeToDeleteView.swift
////  DingDong
////
////  Created by F_s on 8/4/25.
////
//
//import SwiftUI
//
//struct SwipeToDeleteView<Content: View>: View {
//	let onDelete: () -> Void
//	let content: () -> Content
//	
//	@State private var offset: CGFloat = 0
//	@GestureState private var dragOffset: CGFloat = 0
//	
//	var body: some View {
//		ZStack(alignment: .trailing) {
//			if offset < -10 || dragOffset < -10 {
//				Image(systemName: "trash")
//					.font(.system(size: 20, weight: .bold))
//					.foregroundColor(.cyan)
//					.padding(.trailing, 20)
//			}
//			content()
//				.offset(x: offset + dragOffset)
//				.gesture(
//					DragGesture()
//						.updating($dragOffset) { value, state, _ in
//							if value.translation.width < 0 {
//								state = value.translation.width
//							}
//						}
//						.onEnded { value in
//							if value.translation.width < -120 {
//								onDelete()
//							} else if value.translation.width < -60 {
//								withAnimation { offset = -80 }
//							} else {
//								withAnimation { offset = 0 }
//							}
//						}
//				)
//		}
//		.clipShape(RoundedRectangle(cornerRadius: 15))
//		.frame(height: 60)
//	}
//}
//
//struct SwipeToDeleteView_Previews: PreviewProvider {
//	static var previews: some View {
//		SwipeToDeleteView(onDelete: {}) {
//			Text("오늘의 할 일            오전 8: 40")
//				.padding()
//				.background(Color.white)
//		}
//		.padding()
//		.background(Color.gray.opacity(0.2))
//	}
//}
