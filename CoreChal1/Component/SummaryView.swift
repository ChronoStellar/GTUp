//
//  DataSummaryView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 26/03/25.
//

import SwiftUI

struct DataSummaryView: View {
    var body: some View {
        ZStack {
            Color(uiColor: .secondaryApp)
            VStack(alignment: .leading) {
                Text("Summary")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.fontApp)
                    .padding(.bottom, 3)
                Text("Great job staying active today! You took 5 micro breaks, each lasting 5 minutes, and walked 100 steps per break, totaling 500 steps—an excellent way to reduce prolonged sitting. Keep up the momentum, and consider adding a few stretches or extra steps to enhance your routine.!")
                    .font(.system(size: 14))
                    .foregroundColor(Color(uiColor: .fontApp))
                
            }.padding()
        }
        .frame(width: 360, height: 200)
        .cornerRadius(20)
    }
}

#Preview {
    DataSummaryView()
}
