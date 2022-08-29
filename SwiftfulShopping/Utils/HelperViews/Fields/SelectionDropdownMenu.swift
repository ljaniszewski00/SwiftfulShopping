//
//  SelectionDropdownMenu.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 27/08/2022.
//

import SwiftUI

struct SelectionDropdownMenu: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding private var selection: String
    private var dataWithImagesToChoose: [String: String?]
    private var includeSearchField: Bool
    
    init(selection: Binding<String>,
         dataWithImagesToChoose: [String: String?],
         includeSearchField: Bool = true) {
        self._selection = selection
        self.dataWithImagesToChoose = dataWithImagesToChoose
        self.includeSearchField = includeSearchField
    }
    
    var elementsNames: [String] {
        if searchText.isEmpty {
            return Array(dataWithImagesToChoose.keys).sorted(by: >)
        } else {
            return Array(dataWithImagesToChoose.keys).sorted(by: >).filter {
                $0.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    @State private var isExpanded: Bool = false
    @State private var searchText: String = ""
    @State private var isSearchTextFieldFocused: Bool = false
    
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
                .foregroundColor(.ssGray)
        }
    }
    
    @ViewBuilder func buildSelectedElementRow() -> some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack {
                HStack(spacing: 20) {
                    if !elementsNames.isEmpty {
                        if let dataImage = dataWithImagesToChoose[selection], let imageName = dataImage {
                            Image(imageName)
                        }
                    }
                    Text(selection)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if dataWithImagesToChoose.count > 1 {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.ssGray)
                }
            }
            .padding()
        }
        .frame(minWidth: 200, maxWidth: .infinity)
    }
    
    @ViewBuilder func buildElementsList() -> some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                if includeSearchField {
                    RectangleCustomTextField(textFieldProperty: "Search",
                                             text: $searchText,
                                             isFocusedParentView: $isSearchTextFieldFocused)
                        .padding()
                }
                
                ForEach(elementsNames, id: \.self) { elementName in
                    Button {
                        selection = elementName
                        isExpanded = false
                    } label: {
                        HStack {
                            HStack(spacing: 20) {
                                if !elementsNames.isEmpty {
                                    if let dataImage = dataWithImagesToChoose[elementName], let imageName = dataImage {
                                        Image(imageName)
                                    }
                                }
                                Text(elementName)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                            }
                            
                            Spacer()
                            
                            if elementName == selection {
                                Image(systemName: "checkmark")
                                    .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
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
                SelectionDropdownMenu(selection: $selection,
                                  dataWithImagesToChoose: dataWithImagesToChoose)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
