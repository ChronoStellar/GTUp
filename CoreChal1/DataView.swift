//
//  DataView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 24/03/25.
//

import SwiftUI
import Charts

enum ChartRange: String, CaseIterable, Identifiable {
    case oneWeek = "1W"
    case twoMonth = "2W"
    case threeWeek = "3W"
    case fourWeek = "4W"
    case oneMonth = "1M"
    
    var id: String { rawValue }
}

struct DataView: View {
    @EnvironmentObject var manager: HealthKitManager
    @State private var selectedRange: ChartRange = .oneWeek
    
    var displayedChartData: [DailyChartData] {
        let data: [DailyChartData]
        switch selectedRange {
        case .oneWeek:
            data = Array(manager.oneMonthChartData.suffix(7))
        case .twoMonth:
            data = Array(manager.oneMonthChartData.suffix(14))
        case .threeWeek:
            data = Array(manager.oneMonthChartData.suffix(21))
        case .fourWeek:
            data = Array(manager.oneMonthChartData.suffix(28))
        case .oneMonth:
            data = manager.oneMonthChartData
        }
        print("Selected Range: \(selectedRange.rawValue), Data Count: \(data.count), Data: \(data.map { "\($0.date): \($0.steps) steps, \($0.stand) stand" })")
        return data
    }
    private func startDate(for range: ChartRange) -> Date {
        let calendar = Calendar.current
        switch range {
        case .oneWeek:
            return calendar.date(byAdding: .day, value: -7, to: Date())!
        case .twoMonth:
            return calendar.date(byAdding: .day, value: -14, to: Date())!
        case .threeWeek:
            return calendar.date(byAdding: .day, value: -21, to: Date())!
        case .fourWeek:
            return calendar.date(byAdding: .day, value: -28, to: Date())!
        case .oneMonth:
            return calendar.date(byAdding: .month, value: -1, to: Date())!
        }
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .primaryApp)
                .ignoresSafeArea()
            VStack {
                if !manager.isAuthorized {
                    Text("Please authorize HealthKit access to view data.")
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                        .padding()
                } else if manager.activities.isEmpty || manager.oneMonthChartData.isEmpty {
                    ProgressView("Loading health data...")
                        .padding()
                } else {
                    VStack {
                        Text("Health Data")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.fontApp)
                        CustomSegmentedPicker(
                            selection: $selectedRange,
                            options: ChartRange.allCases,
                            content: { range in
                                Text(range.rawValue)
                                    .font(.system(size: 16))
                            },
                            backgroundColor: .white, // Unselected background
                            selectedColor: Color.accentRed,                // Selected segment
                            textColor: Color.black,                   // Unselected text
                            selectedTextColor: Color.white            // Selected text
                        )
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.secondary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100), spacing: -10), count: 2)) {
                        ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                            VStack {
                                CountView(activity: item.value)
                                if item.key == "todaySteps" {
                                    Chart {
                                        ForEach(displayedChartData) { daily in
                                            BarMark(
                                                x: .value("Date", daily.date, unit: .day),
                                                y: .value("Steps", daily.steps)
                                            )
                                            .foregroundStyle(.tetriaryApp)
                                        }
                                    }
                                    .chartXScale(domain: [startDate(for: selectedRange), Date()])
                                    .chartXAxis { AxisMarks { _ in } }
                                    .chartYAxis { AxisMarks { _ in } }
                                    .frame(width: 150, height: 200)
                                    .padding(10)
                                } else if item.key == "todayStand" {
                                    Chart {
                                        ForEach(displayedChartData) { daily in
                                            BarMark(
                                                x: .value("Date", daily.date, unit: .day),
                                                y: .value("Steps", daily.stand)
                                            )
                                            .foregroundStyle(.tetriaryApp)
                                        }
                                    }
                                    .chartXScale(domain: [startDate(for: selectedRange), Date()])
                                    .chartXAxis { AxisMarks { _ in } }
                                    .chartYAxis { AxisMarks { _ in } }
                                    .frame(width: 150, height: 200)
                                    .padding(10)
                                }
                            }
                            .background(.secondaryApp)
                            .cornerRadius(10)
                            
                        }
                    }
                    DataSummaryView()
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    DataView()
}
