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
//        VStack {
//            Text("Steps").font(.title)
//            Text("2,6787" + " Steps")
//            Chart(viewModel.salesData) { data in
//                            BarMark(
//                                x: .value("Month", data.month),
//                                y: .value("Sales", data.sales)
//                            )
//                            .foregroundStyle(.blue)
//                        }
//                        .frame(height: 200)
//                        .padding()
//        }
//        .background(Color.gray)
        ZStack{
            Color(uiColor: .secondary)
//                .ignoresSafeArea(.all)
                .cornerRadius(20)
            VStack{
                Text("Steps").foregroundColor(.font)
                Text("2.678" + "Steps").foregroundColor(.font)
                Chart(viewModel.salesData) { data in
                    BarMark(
                        x: .value("Month", data.month),
                        y: .value("Sales", data.sales)
                    )
                    .foregroundStyle(.tertiary)
                }
                .frame(height: 200)
                .padding()
            }
        }
    }
}

#Preview {
    GraphView()
}
