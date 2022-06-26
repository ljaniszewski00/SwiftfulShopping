//
//  StepsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 26/06/2022.
//

import SwiftUI

struct StepsView: View {
    var stepsNumber: Int = 3
    var activeStep: Int = 2
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            
            ForEach(1...stepsNumber, id: \.self) { stepNumber in
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.accentColor)
                        .if(stepNumber != activeStep) {
                            $0
                                .opacity(0.5)
                        }
                    if activeStep > stepNumber {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    } else {
                        Text("\(stepNumber)")
                            .bold()
                    }
                }
                if stepNumber != stepsNumber {
                    Rectangle()
                        .foregroundColor(.accentColor)
                        .frame(width: 50, height: 5)
                        .if(stepNumber != activeStep) {
                            $0
                                .opacity(0.5)
                        }
                }
            }
            
            Spacer()
        }
    }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView()
    }
}
