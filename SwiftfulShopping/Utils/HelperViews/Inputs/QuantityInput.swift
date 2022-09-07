//
//  QuantityInput.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/09/2022.
//

import SwiftUI

struct QuantityInput: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var label: String
    
    var selection: Binding<Int>?
    
    var quantity: Int?
    var minusAction: (() -> Void)?
    var plusAction: (() -> Void)?
    
    init(label: String = "", selection: Binding<Int>) {
        self.label = label
        self.selection = selection
    }
    
    init(label: String = "", quantity: Int, minusAction: @escaping () -> Void, plusAction: @escaping () -> Void) {
        self.label = label
        self.quantity = quantity
        self.minusAction = minusAction
        self.plusAction = plusAction
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if !label.isEmpty {
                Text(label)
                    .font(.ssButton)
                    .foregroundColor(.ssDarkGray)
            }
            
            HStack(spacing: 0) {
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    if selection != nil {
                        selection!.wrappedValue -= 1
                    } else {
                        if let minusAction = minusAction {
                            minusAction()
                        }
                    }
                } label: {
                    Image(systemName: "minus")
                        .foregroundColor(.ssDarkGray)
                }
                .padding()
                .buttonStyle(BorderlessButtonStyle())
                
                Text(String(selection != nil ? selection!.wrappedValue : (quantity != nil ? quantity! : 0)))
                    .font(.ssButton)
                    .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding()
                    .frame(width: 70)
                    .background {
                        Rectangle()
                            .foregroundColor(.accentColor)
                            .opacity(0.4)
                    }
                
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    if selection != nil {
                        selection!.wrappedValue += 1
                    } else {
                        if let plusAction = plusAction {
                            plusAction()
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.ssDarkGray)
                }
                .padding()
                .buttonStyle(BorderlessButtonStyle())
            }
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .stroke()
                    .foregroundColor(.ssDarkGray)
            }
        }
        .fixedSize(horizontal: true, vertical: true)
    }
}

struct QuantityInput_Previews: PreviewProvider {
    @State static var selection: Int = 1
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                QuantityInput(label: "Quantity", selection: $selection)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
