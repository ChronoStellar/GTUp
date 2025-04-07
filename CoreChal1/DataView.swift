//
//  DataView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 24/03/25.
//
import SwiftUI
import Charts

struct DataView: View {
    var body: some View {
        ZStack {
            Color(uiColor: .primaryApp)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack {
                    Text("Health Data")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.fontApp)
                    Text("Calendar")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.fontApp)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.secondary)
                VStack(spacing: 16) {
                    CountView(image: "Work", type: "Work")
                    CountView(image: "Break", type: "Break")
                    DataSummaryView()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    DataView()
}
