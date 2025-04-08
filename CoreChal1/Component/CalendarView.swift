import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate : String
    let days = Array(-7...0) // Range of days relative to today
    // Date formatters for weekday and day
    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // Short weekday, e.g., "Sat"
        return formatter
    }()

    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd" // Two-digit day, e.g., "23"
        return formatter
    }()
    private let queryFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" 
        return formatter
    }()
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in // Add ScrollViewReader
                    HStack(spacing: 5) {
                        ForEach(days, id: \.self) { dayOffset in
                            let currentDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date())!
                            let formattedDate = queryFormatter.string(from: currentDate)
                            let weekdayText = weekdayFormatter.string(from: currentDate)
                            let dayText = dayFormatter.string(from: currentDate)

                            Button(action: {
                                selectedDate = formattedDate
                            }) {
                                VStack(spacing: 1) {
                                    Text(weekdayText)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.tetriaryApp)
                                    Text(dayText)
                                        .font(.system(size: 20, weight: .bold))
                                        .fontWeight(.bold)
                                        .foregroundColor(.accentRed)
                                    Color(selectedDate == formattedDate ? .accentRed: .white.opacity(0)).frame(width: 15, height: 2)
                                }
                                .padding(10)
                            }
                            .id(dayOffset) // Assign an ID to each button
                        }
                    }
                    .onAppear {
                        proxy.scrollTo(0, anchor: .trailing) // Scroll to dayOffset = 0 (rightmost)
                    }
                }
            }
        }
    }
}
