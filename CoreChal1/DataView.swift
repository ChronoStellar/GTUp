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
        switch selectedRange {
        case .oneWeek:
            return Array(manager.oneMonthChartData.suffix(7))
        case .threeWeek:
            return Array(manager.oneMonthChartData.suffix(21))
        case .oneMonth:
            return manager.oneMonthChartData
        case .twoMonth:
            return Array(manager.oneMonthChartData.suffix(14))
        case .fourWeek:
            return Array(manager.oneMonthChartData.suffix(28))
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
                                    .chartXAxis { AxisMarks { _ in } }
                                    .chartYAxis { AxisMarks { _ in } }
                                    .frame(width: 150, height: 200)
//                                    .background(.white)
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
