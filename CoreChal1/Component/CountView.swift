//
//  CounteView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 05/04/25.
//

import SwiftUI

struct CountView: View {
    let image: String
    let type: String
    
    var body: some View {
        ZStack {
            Color(uiColor: .secondaryApp)
            VStack(alignment: .leading){
                Text(type)
                    .font(.headline)
                    .foregroundColor(.fontApp)
                HStack {
                    Image(image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    Spacer()
                    VStack(alignment: .trailing){
                        Text("You've bla bla bla").foregroundColor(.fontApp)
                        Text("1 hours").foregroundColor(.fontApp)
                    }
                }
            }
            .padding(20)
        }
        .frame(width: 350, height: 150)
        .cornerRadius(20)
    }
}

#Preview {
    CountView(image: "Work", type: "Work")
}
