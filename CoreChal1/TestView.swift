import SwiftUI
import SwiftData

struct TestView: View {
    @EnvironmentObject var manager: HealthKitManager
    
    var body: some View {
        VStack(spacing: 20) {
//            if let todayBreak = breaks.first {
//                
//                Text("Breaks: \(todayBreak.getBreakCounter())")
//                Text("Break Duration: \(todayBreak.getBreakDuration()) min")
//                Text("Work Duration: \(todayBreak.getWorkDuration()) min")
//            } else {
//                Text("No data for today yet")
//            }
            Button("Start") {
                self.manager.getTodayStep()
                
            }
            Text("\(manager.activity)")
        }.background(.white)
    }
}

