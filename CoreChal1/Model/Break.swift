//
//  Stats.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 07/04/25.
//

import Foundation
import SwiftData

@Model
class Break {
    var date = Date()
    private var stepCounter : Int = 0
    private var breakCounter : Int = 0
    private var breakDuration : Int = 0
    private var workDuration : Int = 0
    
    init(date: Date = Date(), stepCounter: Int, breakCounter: Int) {
        let time =  UserDefaults.standard.integer(forKey: "breakTimeRemaining") > 0 ? UserDefaults.standard.integer(forKey: "breakTimeRemaining") : 15
        let workHours = 8*60 //Change to userdefault
        
        self.date = Calendar.current.startOfDay(for: date)
        self.stepCounter = stepCounter
        self.breakCounter = breakCounter
        self.breakDuration = breakCounter * time
        self.workDuration = workHours - breakCounter * time
    }
    
    func recordBreak() {
        let breakTimePerSession = UserDefaults.standard.integer(forKey: "breakTimeRemaining") > 0 ? UserDefaults.standard.integer(forKey: "breakTimeRemaining") : 15
        breakCounter += 1
        breakDuration = breakCounter * breakTimePerSession
        workDuration = (8 * 60) - breakDuration
    }
    
    // Function to add steps
    func addSteps(_ steps: Int) {
        stepCounter += steps
    }
    
    //gets
    func getStepCounter() -> Int {
        return stepCounter
    }
    func getBreakDuration() -> Int {
        return breakDuration
    }
    func getWorkDuration() -> Int {
        return workDuration
    }
    func getBreakCounter() -> Int {
        return breakCounter
    }
    func getDate() -> Date {
        return date
    }
}
