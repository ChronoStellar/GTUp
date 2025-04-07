//
//  HealthManager.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 05/04/25.
//

import Foundation
import HealthKit

struct DailyChartData: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Double
    let stand: Double
}

extension Date{
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
    static var startOfWeek: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2
        return calendar.date(from: components)!
    }
    static var oneMonthAgo: Date {
        let calendar = Calendar.current
        let oneMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        return calendar.startOfDay(for: oneMonth)
    }}

class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    // Today's Step
    @Published var activities: [String: Activity] = [:]
    
    // Charts
    @Published var oneMonthChartData = [DailyChartData]()

    @Published var isAuthorized = false
    
    init () {
        let steps = HKQuantityType(.stepCount)
        let standTime = HKQuantityType(.appleStandTime)
        
        let healthType : Set = [steps, standTime]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthType)
                DispatchQueue.main.async {
                    self.isAuthorized = true // Mark as authorized
                }
                //today's steps
                fetchTodayStepCount()
                fetchTodayStandHours()
                //calendar
                fetchOneMonthStepData()
//                fetchOneYearStepData()
            }
            catch {
                print("Error requesting HealthKit authorization")
                DispatchQueue.main.async {
                    self.isAuthorized = false // Mark as authorized
                }
            }
        }
    }
    
    func fetchDailyChartData(startDate: Date, completion: @escaping ([DailyChartData]) -> Void) {
            let steps = HKQuantityType(.stepCount)
            let standTime = HKQuantityType(.appleStandTime)
            let interval = DateComponents(day: 1)
            
            let stepsQuery = HKStatisticsCollectionQuery(
                quantityType: steps,
                quantitySamplePredicate: nil,
                anchorDate: startDate,
                intervalComponents: interval
            )
            
            let standQuery = HKStatisticsCollectionQuery(
                quantityType: standTime,
                quantitySamplePredicate: nil,
                anchorDate: startDate,
                intervalComponents: interval
            )
            
            var dailyChartData: [DailyChartData] = []
            let group = DispatchGroup()
            
            // Steps handler
            group.enter()
            stepsQuery.initialResultsHandler = { query, results, error in
                guard let results = results else {
                    print("No step results for range starting: \(startDate)")
                    group.leave()
                    return
                }
                
                dailyChartData = results.statistics().map { stats in
                    DailyChartData(
                        date: stats.startDate,
                        steps: stats.sumQuantity()?.doubleValue(for: .count()) ?? 0.0,
                        stand: 0.0  // Temporary placeholder
                    )
                }
                print("Steps fetched for \(dailyChartData.count) days starting \(startDate)")
                group.leave()
            }
            
            // Stand hours handler
            group.enter()
            standQuery.initialResultsHandler = { query, results, error in
                guard let results = results else {
                    print("No stand results for range starting: \(startDate)")
                    group.leave()
                    return
                }
                
                let standData = results.statistics()
                for (index, stats) in standData.enumerated() where index < dailyChartData.count {
                    let standMinutes = stats.sumQuantity()?.doubleValue(for: .minute()) ?? 0.0
                    dailyChartData[index] = DailyChartData(
                        date: dailyChartData[index].date,
                        steps: dailyChartData[index].steps,
                        stand: standMinutes / 60.0  // Convert minutes to hours
                    )
                }
                print("Stand hours fetched for \(standData.count) days starting \(startDate)")
                group.leave()
            }
            
            group.notify(queue: .main) {
                print("Completed fetch for range starting \(startDate): \(dailyChartData.count) days")
                dailyChartData.forEach { data in
                    print("Date: \(data.date), Steps: \(data.steps), Stand: \(data.stand)")
                }
                completion(dailyChartData)
            }
            
            healthStore.execute(stepsQuery)
            healthStore.execute(standQuery)
        }
    //////////

    func fetchTodayStepCount() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            let stepsCount: Int
            if let quantity = result?.sumQuantity(), error == nil {
                stepsCount = Int(quantity.doubleValue(for: .count()))
            } else {
                stepsCount = 0
                print("Error fetching step count or no data available")
            }
            
            let activity = Activity(id: 0, title: "Steps", ammount: stepsCount.formatted(), metric: "steps")
            DispatchQueue.main.async {
                self.activities["todaySteps"] = activity
            }
            print("Today steps: \(stepsCount)")
        }
        healthStore.execute(query)
    }

    func fetchTodayStandHours() {
        let stand = HKQuantityType(.appleStandTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: stand, quantitySamplePredicate: predicate) { _, result, error in
            let standTimeCount: Int
            if let quantity = result?.sumQuantity(), error == nil {
                standTimeCount = Int(quantity.doubleValue(for: .hour()))
            } else {
                standTimeCount = 0
                print("Error fetching stand hours or no data available")
            }
            
            let activity = Activity(id: 1, title: "Stand Hours", ammount: standTimeCount.formatted(), metric: "hours")
            DispatchQueue.main.async {
                self.activities["todayStand"] = activity
            }
            print("Today stand: \(standTimeCount)")
        }
        healthStore.execute(query)
    }
}

extension Double {
    func formatted() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension HealthKitManager {
    func fetchOneMonthStepData(){
        fetchDailyChartData(startDate: .oneMonthAgo){ dailyData in
            DispatchQueue.main.async {
                self.oneMonthChartData = dailyData
            }
        }
    }
}
