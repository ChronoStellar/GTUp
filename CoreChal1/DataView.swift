//
//  DataView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 24/03/25.
//
import SwiftUI
import Charts

struct DataView: View {
    @State var selectedDate : String = ""
    let breaks : [Break]
    
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
                    CalendarView(selectedDate: $selectedDate)
                    Color.secondaryApp.frame(height: 5)
                }
                .ignoresSafeArea(edges: .top)
                .padding()
                VStack(spacing: 16) {
                    CountView(type: "Work", count: 1)
                    CountView(type: "Break", count: 3)
                    DataSummaryView()
                }
                Spacer()
            }
        }
    }
}
