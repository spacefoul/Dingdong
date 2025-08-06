//
//  AlarmListView.swift
//  DingDong
//
//  Created by F_s on 8/4/25.
//

import SwiftUI

struct AlarmListView: View {
	var filteredAlarms: [Alarm]
	var isTimeLeading: Bool
	var onDelete: (Alarm) -> Void
	
	var body: some View {
		ScrollView {
			VStack(spacing: 12) {
				ForEach(filteredAlarms, id: \.id) { alarm in
					SwipeToDeleteView {
						onDelete(alarm)
					} content: {
						AlarmView(alarm: alarm, isTimeLeading: isTimeLeading)
					}
				}
				Spacer().frame(height: 80)
			}
			.padding(.horizontal)
		}
	}
}



//#Preview {
//    AlarmListView()
//}
