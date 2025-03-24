//
//  GraphView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 24/03/25.
//

import SwiftUI
import Charts

struct GraphView: View {
    @StateObject private var viewModel = DummyViewModel()
    var body: some View {
        VStack {
            Text("Steps").font(.title)
//            Spacer()
            Text("2,6787" + " Steps")
            Chart(viewModel.salesData) { data in
                            BarMark(
                                x: .value("Month", data.month),
                                y: .value("Sales", data.sales)
                            )
                            .foregroundStyle(.blue)
                        }
                        .frame(height: 200)
                        .padding()
        }
//        .frame(width: 150, height: 220)
        .background(Color.gray)
    }
}

#Preview {
    GraphView()
}
