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
    
    var time =  UserDefaults.standard.integer(forKey: "breakTimeRemaining") > 0 ? UserDefaults.standard.integer(forKey: "breakTimeRemaining") : 15
    var workHours = 8*60 //Change to userdefault
    
    init(date: Date = Date(), stepCounter: Int, breakCounter: Int) {
        self.date = Calendar.current.startOfDay(for: date)
        self.stepCounter = stepCounter
        self.breakCounter = breakCounter
    }
    
    func recordBreak() {
        let breakTimePerSession = UserDefaults.standard.integer(forKey: "breakTimeRemaining") > 0 ? UserDefaults.standard.integer(forKey: "breakTimeRemaining") : 15
        breakCounter += 1
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
        return self.breakCounter * time
    }
    func getWorkDuration() -> Int {
        return self.workHours - self.breakCounter * time
    }
    func getBreakCounter() -> Int {
        return breakCounter
    }
    func getDate() -> Date {
        return date
    }
}
