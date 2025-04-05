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
                Text("Hello, World!")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.fontApp)
                    .padding(.bottom)
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                    .font(.system(size: 16))
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
