//
//  SelectionDropdown.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 27/08/2022.
//

import SwiftUI

struct SelectionDropdown: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var selection: String
    var dataWithImagesToChoose: [String: String?]
    
    init(selection: Binding<String>,
         dataWithImagesToChoose: [String: String?]) {
        self._selection = selection
        self.dataWithImagesToChoose = dataWithImagesToChoose
    }
    
    var elementsNames: [String] {
        Array(dataWithImagesToChoose.keys).sorted(by: >)
    }
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack {
            buildSelectedElementRow()
            
            if isExpanded {
                VStack(spacing: 0) {
                    Divider()
                    buildElementsList()
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 1)
                .foregroundColor(.gray)
        }
    }
    
    @ViewBuilder func buildSelectedElementRow() -> some View {
        HStack {
            HStack(spacing: 20) {
                if !elementsNames.isEmpty {
                    if let dataImage = dataWithImagesToChoose[selection], let imageName = dataImage {
                        Image(imageName)
                    }
                }
                Text(selection)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(colorScheme == .light ? .black : .white)
            }
            
            Spacer()
            
            if dataWithImagesToChoose.count > 1 {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        isExpanded.toggle()
                    }
            }
        }
        .padding()
        .frame(minWidth: 200, maxWidth: .infinity)
    }
    
    @ViewBuilder func buildElementsList() -> some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                ForEach(elementsNames, id: \.self) { elementName in
                    HStack {
                        HStack(spacing: 20) {
                            if !elementsNames.isEmpty {
                                if let dataImage = dataWithImagesToChoose[elementName], let imageName = dataImage {
                                    Image(imageName)
                                }
                            }
                            Text(elementName)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(colorScheme == .light ? .black : .white)
                        }
                        
                        Spacer()
                        
                        if elementName == selection {
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding()
                    .frame(minWidth: 200, maxWidth: .infinity)
                    .if(elementName == selection) {
                        $0
                            .background {
                                Color.accentColor
                            }
                    }
                    .onTapGesture {
                        selection = elementName
                        isExpanded = false
                    }
                    Divider()
                }
            }
        }
    }
}

struct SelectionDropdown_Previews: PreviewProvider {
    @State static var selection: String = Countries.england.rawValue
    
    static var dataWithImagesToChoose: [String: String?] {
        var dataWithImagesToChoose: [String: String?] = [:]
        for country in Countries.allCases {
            if country.rawValue.contains(" ") {
                let countrySubstring = country.rawValue.components(separatedBy: " ")[0]
                dataWithImagesToChoose[country.rawValue] = countrySubstring.lowercased()
            } else {
                dataWithImagesToChoose[country.rawValue] = country.rawValue.lowercased()
            }
        }
        return dataWithImagesToChoose
    }
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SelectionDropdown(selection: $selection,
                                  dataWithImagesToChoose: dataWithImagesToChoose)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
