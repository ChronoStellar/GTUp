//
//  CalendarView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 24/03/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDates: Set<DateComponents> = []
    @State private var formattedDates: String = ""
    let formatter = DateFormatter()
    
    var body: some View {
        VStack {
            MultiDatePicker("Single/Multiple Date Picker", selection: $selectedDates)

            Button(action: {
                formatSelectedDates()
            }, label: {
                Text("OK")
                    .font(.title3)
            })
        }
    }
    
    private func formatSelectedDates() {
        formatter.dateFormat = "MMM-dd-YY"
        let selectedDates = selectedDates
            .compactMap { date in
                Calendar.current.date(from: date)
            }
            .compactMap { date in
                formatter.string(from: date)
            }
        
        print(selectedDates)
    }
}

#Preview {
    CalendarView()
}
