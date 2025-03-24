//
//  DataView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 24/03/25.
//

import SwiftUI

struct DataView: View {
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Color.yellow
                }
                HStack {
                    GraphView()
                    GraphView()
                }
                VStack {
                    Text("Hello, World!")
                    Spacer()
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.").padding()
                }
                .frame(width: 360, height: 200)
                .background(Color.red)
            }.padding(20)
                .navigationTitle(Text("Data Analytics"))
        }
    }
}

#Preview {
    DataView()
}
