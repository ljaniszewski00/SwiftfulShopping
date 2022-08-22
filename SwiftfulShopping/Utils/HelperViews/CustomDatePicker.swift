//
//  CustomDatePicker.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 22/08/2022.
//

import SwiftUI

struct CustomDatePicker: View {
    @Environment(\.colorScheme) var colorScheme
    
    var includeDayChoosing: Bool = true
    var includeMonthChoosing: Bool = true
    var includeYearChoosing: Bool = true
    
    @Binding var dayPickedNumber: Int
    @Binding var monthPickedNumber: Int
    @Binding var yearPickedNumber: Int
    
    @State private var choosingDate: Bool = false
    @State private var choosingMonth: Bool = false
    @State private var choosingYear: Bool = false
    
    init(includeDayChoosing: Bool = true, dayPickedNumber: Binding<Int> = .constant(1),
         includeMonthChoosing: Bool = true, monthPickedNumber: Binding<Int> = .constant(1),
         includeYearChoosing: Bool = true, yearPickedNumber: Binding<Int> = .constant(Date().get(.year))) {
        self.includeDayChoosing = includeDayChoosing
        self._dayPickedNumber = dayPickedNumber
        self.includeMonthChoosing = includeMonthChoosing
        self._monthPickedNumber = monthPickedNumber
        self.includeYearChoosing = includeYearChoosing
        self._yearPickedNumber = yearPickedNumber
    }
    
    private var monthSymbols = Calendar.current.monthSymbols
    private var shortWeekdaySymbols = Calendar.current.shortWeekdaySymbols
    
    private var monthPickedName: String {
        DateFormatter().monthSymbols[monthPickedNumber - 1]
    }
    
    private var dateToDisplay: String {
        var dateString: String = ""
        
        if includeYearChoosing {
            dateString += String(yearPickedNumber)
        }
        if includeMonthChoosing {
            if includeYearChoosing {
                dateString += "-"
            }
            if dayPickedNumber < 10 {
                dateString += "0\(String(monthPickedNumber))"
            } else {
                dateString += String(monthPickedNumber)
            }
        }
        if includeDayChoosing {
            if includeMonthChoosing {
                dateString += "-"
            }
            if dayPickedNumber < 10 {
                dateString += "0\(String(dayPickedNumber))"
            } else {
                dateString += String(dayPickedNumber)
            }
        }
        
        return dateString
    }
    
    private var yearsRange: [Int] = (1900...Date().get(.year)).reversed()
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 15) {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(choosingDate ? .accentColor : .gray)
                Text(dateToDisplay)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: choosingDate ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding(.all, 15)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: choosingDate ? 2 : 1)
                    .foregroundColor(choosingDate ? .accentColor : .gray)
                    .if(choosingDate) {
                        $0
                            .shadow(radius: 10)
                    }
            }
            .onTapGesture {
                choosingDate.toggle()
            }
            
            if choosingDate {
                VStack(alignment: .leading, spacing: 30) {
                    HStack {
                        if includeYearChoosing {
                            Menu {
                                ForEach(yearsRange, id: \.self) { yearNumber in
                                    Button(String(yearNumber), action: {
                                        yearPickedNumber = yearNumber
                                    })
                                }
                            } label: {
                                HStack(spacing: 15) {
                                    Text(String(yearPickedNumber))
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                    Image(systemName: choosingYear ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding(.all, 10)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.accentColor.opacity(0.5))
                                }
                            }
                        }
                        
                        if includeMonthChoosing {
                            Menu {
                                ForEach(monthSymbols, id: \.self) { monthSymbol in
                                    Button(monthSymbol, action: {
                                        for (index, symbol) in monthSymbols.enumerated() where symbol == monthSymbol {
                                            monthPickedNumber = index + 1
                                        }
                                    })
                                }
                            } label: {
                                HStack(spacing: 15) {
                                    Text(monthPickedName)
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                    Image(systemName: choosingMonth ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding(.all, 10)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.accentColor.opacity(0.5))
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if includeMonthChoosing || includeYearChoosing {
                            HStack(spacing: 15) {
                                Button {
                                    if includeDayChoosing {
                                        decrementDayNumber()
                                    } else {
                                        if includeMonthChoosing {
                                            decrementMonthNumber()
                                        } else {
                                            if includeYearChoosing {
                                                decrementYearNumber()
                                            }
                                        }
                                    }
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.gray)
                                        .padding(.all, 10)
                                        .background {
                                            Circle().foregroundColor(.accentColor.opacity(0.5))
                                        }
                                }
                                
                                Button {
                                    if includeDayChoosing {
                                        incrementDayNumber()
                                    } else {
                                        if includeMonthChoosing {
                                            incrementMonthNumber()
                                        } else {
                                            if includeYearChoosing {
                                                incrementYearNumber()
                                            }
                                        }
                                    }
                                } label: {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .padding(.all, 10)
                                        .background {
                                            Circle().foregroundColor(.accentColor.opacity(0.5))
                                        }
                                }
                            }
                        }
                    }
                    
                    if includeDayChoosing {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                ForEach(shortWeekdaySymbols, id: \.self) { weekdaySymbol in
                                    Text(weekdaySymbol)
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    Spacer()
                                }
                            }
                            
                            HStack {
                                
                            }
                            
                            HStack {
                                
                            }
                            
                            HStack {
                                
                            }
                            
                            HStack {
                                
                            }
                            
                            HStack {
                                
                            }
                        }
                    }
                }
                .padding(.all, 15)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private func incrementDayNumber() {
        dayPickedNumber += 1
    }
    
    private func decrementDayNumber() {
        dayPickedNumber -= 1
    }
    
    private func incrementMonthNumber() {
        monthPickedNumber += 1
    }
    
    private func decrementMonthNumber() {
        monthPickedNumber -= 1
    }
    
    private func incrementYearNumber() {
        yearPickedNumber += 1
    }
    
    private func decrementYearNumber() {
        yearPickedNumber -= 1
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    @State static var dayPicked: Int = 1
    @State static var monthPicked: Int = 1
    @State static var yearPicked: Int = Date().get(.year)
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                CustomDatePicker(dayPickedNumber: $dayPicked,
                                 monthPickedNumber: $monthPicked,
                                 yearPickedNumber: $yearPicked)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
