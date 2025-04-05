//
//  CounteView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 05/04/25.
//

import SwiftUI

struct Activity{
    let id: Int
    let title: String
    let ammount: String
    let metric: String
}

struct CountView: View {
    @State var activity: Activity
    
    var body: some View {
        VStack(alignment : .leading) {
            Text(activity.title)
                .font(.system(size: 22, weight: .bold, design: .default))
                .foregroundColor(.fontApp)
                .lineLimit(1)
            Text("\(activity.ammount) \(activity.metric)")
                .font(.system(size: 28, weight: .regular, design: .default))
                .foregroundColor(.fontApp)
                .lineLimit(2)
        }
        .frame(width: 150, height: 100)
    }
}

#Preview {
    CountView(activity: Activity(id: 0, title: "STEPS", ammount: "12", metric: "step"))
}
