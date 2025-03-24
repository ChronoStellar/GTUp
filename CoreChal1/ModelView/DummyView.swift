//
//  DummyView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 24/03/25.
//

import Foundation

class DummyViewModel: ObservableObject {
    @Published var salesData: [SalesData] = [
        SalesData(month: "Jan", sales: 120),
        SalesData(month: "Feb", sales: 90),
        SalesData(month: "Mar", sales: 150),
        SalesData(month: "Apr", sales: 170),
        SalesData(month: "May", sales: 140)
    ]
}
