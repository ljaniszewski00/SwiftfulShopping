//
//  CustomDatePicker.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 22/08/2022.
//

import SwiftUI

struct CustomDatePicker: View {
    @Environment(\.colorScheme) var colorScheme
    
    // Init values
    private var includeDayPicking: Bool
    private var includeMonthPicking: Bool
    private var includeYearPicking: Bool
    private var pickingDatesRange: Bool
    @Binding var firstDatePicked: Date
    @Binding var secondDatePicked: Date
    
    // State variables for detecting picked values
    @State private var pickedDayNumber: Int = Date().get(.day)
    @State private var pickedMonthNumber: Int = Date().get(.month)
    @State private var pickedYearNumber: Int = Date().get(.year)
    
    // State variables for detecting what type of data user is picking at the moment
    @State private var pickingDate: Bool = false
    @State private var pickingYear: Bool = false
    @State private var pickingMonth: Bool = false
    
    // Init for CustomDatePicker with one date choosing
    init(includeDayPicking: Bool,
         includeMonthPicking: Bool,
         includeYearPicking: Bool,
         datePicked: Binding<Date>) {
        self.includeDayPicking = includeDayPicking
        self.includeMonthPicking = includeMonthPicking
        self.includeYearPicking = includeYearPicking
        self.pickingDatesRange = false
        self._firstDatePicked = datePicked
        self._secondDatePicked = .constant(Date())
    }
    
    // Init for CustomDatePicker with two dates choosing and optional range
    init(includeMonthPicking: Bool = true,
         includeYearPicking: Bool = true,
         pickingDatesRange: Bool,
         firstDatePicked: Binding<Date>,
         secondDatePicked: Binding<Date>) {
        self.includeDayPicking = true
        self.includeMonthPicking = includeMonthPicking
        self.includeYearPicking = includeYearPicking
        self.pickingDatesRange = pickingDatesRange
        self._firstDatePicked = firstDatePicked
        self._secondDatePicked = secondDatePicked
    }
    
    private var monthSymbols = Calendar.current.monthSymbols
    private var shortWeekdaySymbols = Calendar.current.shortWeekdaySymbols
    
    private var firstDayOfMonthName: String {
        let dayNameFormatter = DateFormatter()
        dayNameFormatter.locale = .current
        dayNameFormatter.calendar = .current
        dayNameFormatter.dateFormat = "ccc"
        
        let dateComponents = DateComponents(year: pickedYearNumber, month: pickedMonthNumber, day: 1)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        return dayNameFormatter.string(from: date)
    }
    
    private var firstDayOfMonthNumber: Int {
        let calendar = Calendar.current
        let dateComponents = DateComponents(calendar: calendar,
                                            year: pickedYearNumber,
                                            month: pickedMonthNumber,
                                            day: 1)
        let date = calendar.date(from: dateComponents)!
        
        return calendar.component(.weekday, from: date)
    }
    
    private var currentMonthDaysNumber: Int {
        monthDaysNumberFor(yearNumber: pickedYearNumber,
                           monthNumber: pickedMonthNumber)
    }
    
    private var isPickedDayToday: Bool {
        pickedDayNumber == Date().get(.day) &&
        pickedMonthNumber == Date().get(.month) &&
        pickedYearNumber == Date().get(.year)
    }
    
    private func pickToday() {
        pickedDayNumber = Date().get(.day)
        pickedMonthNumber = Date().get(.month)
        pickedYearNumber = Date().get(.year)
    }
    
    private func monthDaysNumberFor(yearNumber: Int, monthNumber: Int) -> Int {
        let dateComponents = DateComponents(year: yearNumber, month: monthNumber)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
    private var yearsRange: [Int] = (1900...Date().get(.year)).reversed()
    
    private var pickedMonthName: String {
        DateFormatter().monthSymbols[pickedMonthNumber - 1]
    }
    
    private var calendarDaysByWeekdays: [String: [CalendarDay]] {
        var calendarDays: [String: [CalendarDay]] = [:]
        for symbol in shortWeekdaySymbols {
            calendarDays[symbol] = rowsForCalendarSection.filter { $0.weekdaySymbol == symbol }
        }
        return calendarDays
    }
    
    private var rowsForCalendarSection: [CalendarDay] {
        var rows: [CalendarDay] = []
        
        let previousMonthDaysNumber = monthDaysNumberFor(yearNumber: pickedMonthNumber == 1 ?
                                                     pickedYearNumber - 1 : pickedYearNumber,
                                                         monthNumber: pickedMonthNumber - 1)
        
        var lastDayNumberFromPreviousRow: Int = 0
        var newMonthAlreadyCreated: Bool = false
        var dayIndex: Int = 0
        for rowNumber in 1...7 {
            if rowNumber == 1 {
                let placesForDaysFromPreviousMonth = (previousMonthDaysNumber - (previousMonthDaysNumber - firstDayOfMonthNumber) - 1)
                let daysFromPreviousMonth = Array(1...previousMonthDaysNumber)
                let daysFromPreviousMonthForARow = Array(daysFromPreviousMonth.suffix(placesForDaysFromPreviousMonth))
                let numberOfDaysFromPreviousMonthForARow = daysFromPreviousMonthForARow.count
                
                var lastIndex: Int = 0
                //Creating days from previous month and assigning it to current calendar days
                for dayFromPreviousMonth in daysFromPreviousMonthForARow {
                    let calendarDay = CalendarDay(id: dayIndex,
                                                  value: dayFromPreviousMonth,
                                                  weekdaySymbol: shortWeekdaySymbols[lastIndex],
                                                  monthType: .previous)
                    dayIndex += 1
                    lastIndex += 1
                    rows.append(calendarDay)
                }
                
                let numberOfRemainingDaysInARow = 7 - numberOfDaysFromPreviousMonthForARow
                
                //Creating days from current month and assigning it to current calendar days
                for dayFromCurrentMonth in Array(1...numberOfRemainingDaysInARow) {
                    let calendarDay = CalendarDay(id: dayIndex,
                                                  value: dayFromCurrentMonth,
                                                  weekdaySymbol: shortWeekdaySymbols[lastIndex],
                                                  monthType: .current)
                    dayIndex += 1
                    lastIndex += 1
                    rows.append(calendarDay)
                }
                
                lastDayNumberFromPreviousRow = rows.last!.value
            }
            
            if [2, 3, 4, 5].contains(rowNumber) {
                let startingDayNumberFromRow = lastDayNumberFromPreviousRow + 1
                var endingDayNumberFromRow = startingDayNumberFromRow + 7 - 1
                if endingDayNumberFromRow > currentMonthDaysNumber {
                    endingDayNumberFromRow = currentMonthDaysNumber
                    
                    //Starting creating new month
                    newMonthAlreadyCreated = true
                    let rowDaysNumbers = Array(startingDayNumberFromRow...endingDayNumberFromRow)
                    
                    var lastIndex: Int = 0
                    //Creating days from current month and assigning it to current calendar days
                    for dayFromCurrentMonth in rowDaysNumbers {
                        let calendarDay = CalendarDay(id: dayIndex,
                                                      value: dayFromCurrentMonth,
                                                      weekdaySymbol: shortWeekdaySymbols[lastIndex],
                                                      monthType: .current)
                        dayIndex += 1
                        lastIndex += 1
                        rows.append(calendarDay)
                    }
                    
                    let placesForNextMonthDaysNumbers = (7 - (currentMonthDaysNumber - startingDayNumberFromRow))
                    let daysFromNextMonthForARow = Array(1...(placesForNextMonthDaysNumbers - 1))
                    endingDayNumberFromRow = daysFromNextMonthForARow.last!
                    
                    //Creating days from next month and assigning it to current calendar days
                    for dayFromNextMonth in daysFromNextMonthForARow {
                        let calendarDay = CalendarDay(id: dayIndex,
                                                      value: dayFromNextMonth,
                                                      weekdaySymbol: shortWeekdaySymbols[lastIndex],
                                                      monthType: .next)
                        dayIndex += 1
                        lastIndex += 1
                        rows.append(calendarDay)
                    }
                } else {
                    let rowDaysNumbers = Array(startingDayNumberFromRow...endingDayNumberFromRow)
                    //Creating days from current month and assigning it to current calendar days
                    for (index, dayFromCurrentMonth) in rowDaysNumbers.enumerated() {
                        let calendarDay = CalendarDay(id: dayIndex,
                                                      value: dayFromCurrentMonth,
                                                      weekdaySymbol: shortWeekdaySymbols[index],
                                                      monthType: .current)
                        dayIndex += 1
                        rows.append(calendarDay)
                    }
                }
                lastDayNumberFromPreviousRow = endingDayNumberFromRow
            }
            
            if rowNumber == 6 {
                let startingDayNumberFromRow = lastDayNumberFromPreviousRow + 1
                if newMonthAlreadyCreated || (startingDayNumberFromRow > currentMonthDaysNumber) {
                    continue
                }
                let currentMonthLastRowDaysNumbers = Array(startingDayNumberFromRow...currentMonthDaysNumber)
                
                var lastIndex: Int = 0
                //Creating days from current month and assigning it to current calendar days
                for dayFromCurrentMonth in currentMonthLastRowDaysNumbers {
                    let calendarDay = CalendarDay(id: dayIndex,
                                                  value: dayFromCurrentMonth,
                                                  weekdaySymbol: shortWeekdaySymbols[lastIndex],
                                                  monthType: .current)
                    dayIndex += 1
                    lastIndex += 1
                    rows.append(calendarDay)
                }
                
                let placesForNextMonthDaysNumbers = (7 - (currentMonthDaysNumber - startingDayNumberFromRow))
                let daysFromNextMonthForARow = Array(1...(placesForNextMonthDaysNumbers - 1))
                
                //Creating days from next month and assigning it to current calendar days
                for dayFromNextMonth in daysFromNextMonthForARow {
                    let calendarDay = CalendarDay(id: dayIndex,
                                                  value: dayFromNextMonth,
                                                  weekdaySymbol: shortWeekdaySymbols[lastIndex],
                                                  monthType: .next)
                    dayIndex += 1
                    lastIndex += 1
                    rows.append(calendarDay)
                }
            }
        }
        
        return rows
    }
    
    private var dateToDisplay: String {
        var dateString: String = ""
        
        if includeYearPicking {
            dateString += String(pickedYearNumber)
        }
        if includeMonthPicking {
            if includeYearPicking {
                dateString += "-"
            }
            if pickedMonthNumber < 10 {
                dateString += "0\(String(pickedMonthNumber))"
            } else {
                dateString += String(pickedMonthNumber)
            }
        }
        if includeDayPicking {
            if includeMonthPicking {
                dateString += "-"
            }
            if pickedDayNumber < 10 {
                dateString += "0\(String(pickedDayNumber))"
            } else {
                dateString += String(pickedDayNumber)
            }
        }
        
        return dateString
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 15) {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(pickingDate ? .accentColor : .gray)
                Text(dateToDisplay)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(colorScheme == .light ? .black : .white)
                
                Spacer()
                
                Image(systemName: pickingDate ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding(.all, 15)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: pickingDate ? 2 : 1)
                    .foregroundColor(pickingDate ? .accentColor : .gray)
                    .if(pickingDate) {
                        $0
                            .shadow(radius: 10)
                    }
            }
            .onTapGesture {
                pickingDate.toggle()
            }
            
            if pickingDate {
                VStack(alignment: .leading, spacing: 30) {
                    HStack {
                        if includeYearPicking {
                            Menu {
                                ForEach(yearsRange, id: \.self) { yearNumber in
                                    Button(String(yearNumber), action: {
                                        pickedYearNumber = yearNumber
                                    })
                                }
                                .onAppear {
                                    pickingYear = true
                                }
                                .onDisappear {
                                    pickingYear = false
                                }
                            } label: {
                                HStack(spacing: 15) {
                                    Text(String(pickedYearNumber))
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                    Image(systemName: pickingYear ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding(.all, 10)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.accentColor.opacity(0.5))
                                }
                            }
                        }
                        
                        if includeMonthPicking {
                            Menu {
                                ForEach(monthSymbols, id: \.self) { monthSymbol in
                                    Button(monthSymbol, action: {
                                        for (index, symbol) in monthSymbols.enumerated() where symbol == monthSymbol {
                                            pickedMonthNumber = index + 1
                                        }
                                    })
                                }
                                .onAppear {
                                    pickingMonth = true
                                }
                                .onDisappear {
                                    pickingMonth = false
                                }
                            } label: {
                                HStack(spacing: 15) {
                                    Text(pickedMonthName)
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                    Image(systemName: pickingMonth ? "chevron.up" : "chevron.down")
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
                        
                        if includeMonthPicking || includeYearPicking {
                            HStack(spacing: 15) {
                                Button {
                                    if includeDayPicking {
                                        decrementDayNumber()
                                    } else {
                                        if includeMonthPicking {
                                            decrementMonthNumber()
                                        } else {
                                            if includeYearPicking {
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
                                    if includeDayPicking {
                                        incrementDayNumber()
                                    } else {
                                        if includeMonthPicking {
                                            incrementMonthNumber()
                                        } else {
                                            if includeYearPicking {
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
                    
                    if includeDayPicking {
                        HStack {
                            ForEach(shortWeekdaySymbols, id: \.self) { weekdaySymbol in
                                VStack(alignment: .center) {
                                    Text(weekdaySymbol)
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                        .padding(.bottom, 15)
                                    VStack(alignment: .center, spacing: 12) {
                                        ForEach(calendarDaysByWeekdays[weekdaySymbol]!, id: \.id) { calendarDay in
                                            Button {
                                                switch calendarDay.monthType {
                                                case .previous:
                                                    decrementMonthNumber()
                                                case .current:
                                                    break
                                                case .next:
                                                    incrementMonthNumber()
                                                }
                                                pickedDayNumber = calendarDay.value
                                            } label: {
                                                ZStack {
                                                    if calendarDay.value == pickedDayNumber && calendarDay.isCurrentMonth {
                                                        Circle()
                                                            .foregroundColor(.accentColor)
                                                            .opacity(0.7)
                                                            .frame(width: 40, height: 40)
                                                    }
                                                    
                                                    Text(String(calendarDay.value))
                                                        .font(.system(size: 18, weight: .regular, design: .rounded))
                                                        .foregroundColor(calendarDay.isCurrentMonth ? (colorScheme == .light ? .black : .white) : .gray)
                                                }
                                            }
                                            .frame(width: 40, height: 30)
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    
                    
                    if !isPickedDayToday {
                        Button {
                            pickToday()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                Text("Pick Today")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                            }
                        }
                        .frame(height: 50)
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
        if (pickedDayNumber + 1) > currentMonthDaysNumber {
            pickedDayNumber = 1
            incrementMonthNumber()
        } else {
            pickedDayNumber += 1
        }
    }
    
    private func decrementDayNumber() {
        if (pickedDayNumber - 1) < 1 {
            let previousMonthDaysNumber = monthDaysNumberFor(yearNumber: pickedMonthNumber == 1 ?
                                                         pickedYearNumber - 1 : pickedYearNumber,
                                                             monthNumber: pickedMonthNumber - 1)
            pickedDayNumber = previousMonthDaysNumber
            decrementMonthNumber()
        } else {
            pickedDayNumber -= 1
        }
    }
    
    private func incrementMonthNumber() {
        if (pickedMonthNumber + 1) > 12 {
            pickedMonthNumber = 1
            incrementYearNumber()
        } else {
            pickedMonthNumber += 1
        }
    }
    
    private func decrementMonthNumber() {
        if (pickedMonthNumber - 1) < 1 {
            pickedMonthNumber = 12
            decrementYearNumber()
        } else {
            pickedMonthNumber -= 1
        }
    }
    
    private func incrementYearNumber() {
        pickedYearNumber += 1
    }
    
    private func decrementYearNumber() {
        pickedYearNumber -= 1
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    @State static var datePicked: Date = Date()
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                CustomDatePicker(includeDayPicking: true,
                                 includeMonthPicking: true,
                                 includeYearPicking: true,
                                 datePicked: $datePicked)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}

fileprivate struct CalendarDay {
    var id: Int
    var value: Int
    var weekdaySymbol: String
    var monthType: MonthType
    
    var isCurrentMonth: Bool {
        monthType == .current
    }
    
    enum MonthType {
        case previous
        case current
        case next
    }
}
