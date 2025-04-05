//
//  CustomPickerView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 05/04/25.
//

import SwiftUI

struct CustomSegmentedPicker<SelectionValue: Hashable, Content: View>: View {
    @Binding var selection: SelectionValue
    let options: [SelectionValue]
    let content: (SelectionValue) -> Content
    
    // Customizable colors
    let backgroundColor: Color
    let selectedColor: Color
    let textColor: Color
    let selectedTextColor: Color
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    withAnimation(.easeInOut) {
                        selection = option
                    }
                }) {
                    content(option)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundColor(selection == option ? selectedTextColor : textColor)
                        .background(selection == option ? selectedColor : backgroundColor)
                }
                .buttonStyle(PlainButtonStyle()) // Remove default button styling
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8)) // Rounded edges like segmented picker
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1) // Optional border
        )
        .padding(.vertical, 10) // Match padding from your original Picker
    }
}
