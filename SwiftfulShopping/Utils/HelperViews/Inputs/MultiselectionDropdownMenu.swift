//
//  MultiselectionDropdownMenu.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/09/2022.
//

import SwiftUI

struct MultiselectionDropdownMenu: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding private var dataSelected: [String]
    private var dataToChoose: [String]
    private var includeSearchField: Bool
    
    init(dataSelected: Binding<[String]>,
         dataToChoose: [String],
         includeSearchField: Bool = true) {
        self._dataSelected = dataSelected
        self.dataToChoose = dataToChoose
        self.includeSearchField = includeSearchField
    }
    
    var elementsNames: [String] {
        if searchText.isEmpty {
            return dataToChoose.sorted(by: >)
        } else {
            return dataToChoose.sorted(by: >).filter {
                $0.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    @State private var isExpanded: Bool = false
    @State private var searchText: String = ""
    @State private var isSearchTextFieldFocused: Bool = false
    
    var body: some View {
        VStack {
            buildSelectedElementsList()
                .frame(height: 54)
            
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
                .foregroundColor(.ssDarkGray)
        }
    }
    
    @ViewBuilder func buildSelectedElementsList() -> some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(dataSelected, id: \.self) { selected in
                            Text(selected)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                                .padding(.all, 8)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.accentColor)
                                        .opacity(0.4)
                                }
                        }
                    }
                }
                
                Spacer()
                
                if dataToChoose.count > 1 {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.ssDarkGray)
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
                        if dataSelected.contains(elementName) {
                            if let index = dataSelected.firstIndex(of: elementName) {
                                dataSelected.remove(at: index)
                            }
                        } else {
                            dataSelected.append(elementName)
                        }
                    } label: {
                        HStack {
                            Text(elementName)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                            
                            Spacer()
                            
                            if dataSelected.contains(elementName) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                            }
                        }
                        .padding()
                        .frame(minWidth: 200, maxWidth: .infinity)
                        .if(dataSelected.contains(elementName)) {
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

struct MultiselectionDropdownMenu_Previews: PreviewProvider {
    @State static var dataSelected: [String] = [Countries.england.rawValue,
                                                Countries.poland.rawValue]
    
    static var dataToChoose: [String] {
        var dataToChoose: [String] = []
        _ = Countries.allCases.map {
            dataToChoose.append($0.rawValue)
        }
        return dataToChoose
    }
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                MultiselectionDropdownMenu(dataSelected: $dataSelected,
                                           dataToChoose: dataToChoose)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
