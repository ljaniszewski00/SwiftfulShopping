//
//  CustomDatePicker.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 22/08/2022.
//

import SwiftUI
import texterify_ios_sdk

struct CustomDatePicker: View {
    @Environment(\.colorScheme) var colorScheme
    
    // Init values
    private var includeDayPicking: Bool
    private var pickingDatesMethod: PickingDatesMethod
    @Binding var firstDatePicked: Date
    @Binding var secondDatePicked: Date
    
    // State variables for detecting picked values
    @State private var pickedDayNumber: Int = Date().get(.day)
    @State private var pickedMonthNumber: Int = Date().get(.month)
    @State private var pickedYearNumber: Int = Date().get(.year)
    
    @State private var firstDatePickedDayNumber: Int = Date().get(.day)
    @State private var firstDatePickedMonthNumber: Int = Date().get(.month)
    @State private var firstDatePickedYearNumber: Int = Date().get(.year)
    
    @State private var secondDatePickedDayNumber: Int = Date().get(.day)
    @State private var secondDatePickedMonthNumber: Int = Date().get(.month)
    @State private var secondDatePickedYearNumber: Int = Date().get(.year)
    
    @State private var anyDateComponentChanged: Bool = false
    
    // State variables for detecting what type of data user is picking at the moment
    @State private var pickingDate: Bool = false
    @State private var isFirstDatePicked: Bool = false
    @State private var isSecondDatePicked: Bool = false
    
    // Init for CustomDatePicker with one date choosing
    init(includeDayPicking: Bool,
         datePicked: Binding<Date>) {
        self.includeDayPicking = includeDayPicking
        self.pickingDatesMethod = .pickingOneDate
        self._firstDatePicked = datePicked
        self._secondDatePicked = .constant(Date())
    }
    
    // Init for CustomDatePicker with two dates choosing and optional range
    init(firstDatePicked: Binding<Date>,
         secondDatePicked: Binding<Date>) {
        self.includeDayPicking = true
        self.pickingDatesMethod = .pickingTwoDates
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
        
        // previousMonthDaysNumber used to calculate dates from previous month displayed in calendar
        let previousMonthDaysNumber = monthDaysNumberFor(yearNumber: pickedMonthNumber == 1 ?
                                                     pickedYearNumber - 1 : pickedYearNumber,
                                                         monthNumber: pickedMonthNumber - 1)
        
        // lastDayNumberFromPreviousRow used to determine starting day number for next rows
        var lastDayNumberFromPreviousRow: Int = 0
        // newMonthAlreadyCreated used to check if days from next month in current calendar has already been created
        var newMonthAlreadyCreated: Bool = false
        // dayIndex used to tag different calendar days
        var dayIndex: Int = 0
        // We have max 6 rows as there will max 7 * 6 = 42 days displayed
        for rowNumber in 1...7 {
            // Checking if row number is first because only there will be days from previous month displayed
            if rowNumber == 1 {
                // Calculating places that should be reserved for days from previous month to be displayed in current calendar
                let placesForDaysFromPreviousMonth = (previousMonthDaysNumber - (previousMonthDaysNumber - firstDayOfMonthNumber) - 1)
                // Creating whole previous month numbers
                let daysFromPreviousMonth = Array(1...previousMonthDaysNumber)
                // Getting only n last numbers from previous month where n is places reserved for previous month days
                let daysFromPreviousMonthForARow = Array(daysFromPreviousMonth.suffix(placesForDaysFromPreviousMonth))
                // Setting lastIndex as 0 because no days have been created yet and lastIndex is used to determine weekDaySymbol for a day in a current row
                var lastIndex: Int = 0
                
                // Creating days from previous month and assigning it to current calendar days
                for dayFromPreviousMonth in daysFromPreviousMonthForARow {
                    let calendarDay = CalendarDay(id: dayIndex,
                                                  value: dayFromPreviousMonth,
                                                  weekdaySymbol: shortWeekdaySymbols[lastIndex],
                                                  monthType: .previous)
                    // Incrementing dayIndex and lastIndex as new day has been created
                    dayIndex += 1
                    lastIndex += 1
                    rows.append(calendarDay)
                }
                
                // Calculating remaining places number that will be filled with current month days
                let numberOfRemainingDaysInARow = 7 - placesForDaysFromPreviousMonth
                
                // Creating days from current month and assigning it to current calendar days
                for dayFromCurrentMonth in Array(1...numberOfRemainingDaysInARow) {
                    let calendarDay = CalendarDay(id: dayIndex,
                                                  value: dayFromCurrentMonth,
                                                  weekdaySymbol: shortWeekdaySymbols[lastIndex],
                                                  monthType: .current)
                    dayIndex += 1
                    lastIndex += 1
                    rows.append(calendarDay)
                }
                
                // Setting lastDayNumberFromPreviousRow as the last day number we have created in current row
                lastDayNumberFromPreviousRow = rows.last!.value
            }
            
            // Next row will be in the middle beetwen first and last and will not contain either previous month days and next month days. Only the 5th row may contain nexd month days
            if [2, 3, 4, 5].contains(rowNumber) {
                // Setting startingDayNumberFromRow as the next day after lastDayNumberFromPreviousRow
                let startingDayNumberFromRow = lastDayNumberFromPreviousRow + 1
                // Setting endingDayNumberFromRow as six days after startingDayNumberFromRow
                var endingDayNumberFromRow = startingDayNumberFromRow + 7 - 1
                // If endingDayNumberFromRow is bigger than max current month days number, next month days creation should be started in last row
                if endingDayNumberFromRow > currentMonthDaysNumber {
                    // Setting endingDayNumberFromRow as current month days number because we should first fill current row with current month remaining days
                    endingDayNumberFromRow = currentMonthDaysNumber
                    
                    // Starting creating new month
                    newMonthAlreadyCreated = true
                    
                    // Calculating rowDaysNumbers as pure days from startingDayNumberFromRow to endingDayNumberFromRow
                    let rowDaysNumbers = Array(startingDayNumberFromRow...endingDayNumberFromRow)
                    
                    // Again, lastIndex is set to 0 as new row is being created and weekdays are being set from the beginning
                    var lastIndex: Int = 0
                    
                    // Creating days from current month and assigning it to current calendar days
                    for dayFromCurrentMonth in rowDaysNumbers {
                        let calendarDay = CalendarDay(id: dayIndex,
                                                      value: dayFromCurrentMonth,
                                                      weekdaySymbol: shortWeekdaySymbols[lastIndex],
                                                      monthType: .current)
                        dayIndex += 1
                        lastIndex += 1
                        rows.append(calendarDay)
                    }
                    
                    // Calculating places for next month days as remaining places in a row after putting there current month days
                    let placesForNextMonthDaysNumbers = (7 - (currentMonthDaysNumber - startingDayNumberFromRow))
                    // Creating daysFromNextMonthForARow starting from day 1 up to remaining places reserved for next month
                    let daysFromNextMonthForARow = Array(1...(placesForNextMonthDaysNumbers - 1))
                    
                    endingDayNumberFromRow = daysFromNextMonthForARow.last!
                    
                    // Creating days from next month and assigning it to current calendar days
                    for dayFromNextMonth in daysFromNextMonthForARow {
                        let calendarDay = CalendarDay(id: dayIndex,
                                                      value: dayFromNextMonth,
                                                      weekdaySymbol: shortWeekdaySymbols[lastIndex],
                                                      monthType: .next)
                        dayIndex += 1
                        lastIndex += 1
                        rows.append(calendarDay)
                    }
                // If new month doesn't need to be created in any of middle rows
                } else {
                    // We just create an array as 7 days forward after lastDayNumberFromPreviousRow
                    let rowDaysNumbers = Array(startingDayNumberFromRow...endingDayNumberFromRow)
                    // Creating days from current month and assigning it to current calendar days
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
            
            // Last row that most probably will contain next month days
            if rowNumber == 6 {
                let startingDayNumberFromRow = lastDayNumberFromPreviousRow + 1
                
                // If new month has already been created in the last row or lastDayNumberFromPreviousRow was the last day in the current month
                if newMonthAlreadyCreated || (startingDayNumberFromRow > currentMonthDaysNumber) {
                    // we just skip 6th row as it would only contain days from next month and it is not needed
                    continue
                }
                // We fill current row with remaining days from current month
                let currentMonthLastRowDaysNumbers = Array(startingDayNumberFromRow...currentMonthDaysNumber)
                
                var lastIndex: Int = 0
                // Creating days from current month and assigning it to current calendar days
                for dayFromCurrentMonth in currentMonthLastRowDaysNumbers {
                    let calendarDay = CalendarDay(id: dayIndex,
                                                  value: dayFromCurrentMonth,
                                                  weekdaySymbol: shortWeekdaySymbols[lastIndex],
                                                  monthType: .current)
                    dayIndex += 1
                    lastIndex += 1
                    rows.append(calendarDay)
                }
                
                // Calculating places that should be reserved for the next month days
                let placesForNextMonthDaysNumbers = (7 - (currentMonthDaysNumber - startingDayNumberFromRow))
                let daysFromNextMonthForARow = Array(1...(placesForNextMonthDaysNumbers - 1))
                
                // Creating days from next month and assigning it to current calendar days
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
    
    private var wholeDateToDisplay: String {
        if pickingDatesMethod == .pickingTwoDates {
            return firstDateToDisplay + " - " + secondDateToDisplay
        } else {
            return firstDateToDisplay
        }
    }
    
    private var firstDateToDisplay: String {
        var dateString: String = ""
        
        dateString += String(firstDatePickedYearNumber)
        
        dateString += "-"
        
        if firstDatePickedMonthNumber < 10 {
            dateString += "0\(String(firstDatePickedMonthNumber))"
        } else {
            dateString += String(firstDatePickedMonthNumber)
        }
        
        dateString += "-"
        
        if firstDatePickedDayNumber < 10 {
            dateString += "0\(String(firstDatePickedDayNumber))"
        } else {
            dateString += String(firstDatePickedDayNumber)
        }
        
        return dateString
    }
    
    private var secondDateToDisplay: String {
        var dateString: String = ""
        
        dateString += String(secondDatePickedYearNumber)
        
        dateString += "-"
        
        if secondDatePickedMonthNumber < 10 {
            dateString += "0\(String(secondDatePickedMonthNumber))"
        } else {
            dateString += String(secondDatePickedMonthNumber)
        }
        
        dateString += "-"
        
        if secondDatePickedDayNumber < 10 {
            dateString += "0\(String(secondDatePickedDayNumber))"
        } else {
            dateString += String(secondDatePickedDayNumber)
        }
        
        return dateString
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 15) {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(pickingDate ? .accentColor : .ssGray)
                Text(wholeDateToDisplay)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                
                Spacer()
                
                Image(systemName: pickingDate ? "chevron.up" : "chevron.down")
                    .foregroundColor(.ssGray)
            }
            .padding(.all, 15)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: pickingDate ? 2 : 1)
                    .foregroundColor(pickingDate ? .accentColor : .ssGray)
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
                    buildMonthChanger()
                    
                    if includeDayPicking {
                        buildCalendar()
                    }
                    
                    if !isPickedDayToday && includeDayPicking {
                        Button {
                            pickToday()
                            anyDateComponentChanged = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                Text(TexterifyManager.localisedString(key: .customDatePicker(.pickTodayButton)))
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                            }
                        }
                        .frame(height: 50)
                    }
                }
                .padding(.all, 15)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.ssGray)
                }
            }
        }
        .onChange(of: anyDateComponentChanged) { _ in
            if anyDateComponentChanged {
                if pickingDatesMethod == .pickingTwoDates {
                    if !isFirstDatePicked {
                        firstDatePickedDayNumber = pickedDayNumber
                        firstDatePickedMonthNumber = pickedMonthNumber
                        firstDatePickedYearNumber = pickedYearNumber
                    } else {
                        secondDatePickedDayNumber = pickedDayNumber
                        secondDatePickedMonthNumber = pickedMonthNumber
                        secondDatePickedYearNumber = pickedYearNumber
                    }
                } else {
                    firstDatePickedDayNumber = pickedDayNumber
                    firstDatePickedMonthNumber = pickedMonthNumber
                    firstDatePickedYearNumber = pickedYearNumber
                }
                
                let calendar = Calendar.current
                
                if !isFirstDatePicked {
                    let dateComponents = DateComponents(calendar: calendar,
                                                        year: firstDatePickedYearNumber,
                                                        month: firstDatePickedMonthNumber,
                                                        day: firstDatePickedDayNumber)
                    
                    if let date = dateComponents.date {
                        firstDatePicked = date
                    }
                    
                    isFirstDatePicked = true
                    isSecondDatePicked = false
                } else {
                    let dateComponents = DateComponents(calendar: calendar,
                                                        year: secondDatePickedYearNumber,
                                                        month: secondDatePickedMonthNumber,
                                                        day: secondDatePickedDayNumber)
                    if let date = dateComponents.date {
                        secondDatePicked = date
                    }
                    
                    isSecondDatePicked = true
                    isFirstDatePicked = false
                }
                
                anyDateComponentChanged = false
            }
        }
    }
    
    @ViewBuilder
    func buildMonthChanger() -> some View {
        HStack {
            Button {
                // To be uncommented if we want month two buttons not to change actual selection but only displayed month if day picking is displayed
                
//                if !includeDayPicking {
//                    anyDateComponentChanged = true
//                }
                
                anyDateComponentChanged = true
                decrementMonthNumber()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                    .padding(.all, 10)
                    .background {
                        Circle().foregroundColor(.accentColor)
                    }
            }
            
            Spacer()
            
            HStack(spacing: 5) {
                Menu {
                    ForEach(monthSymbols, id: \.self) { monthSymbol in
                        Button(monthSymbol, action: {
                            for (index, symbol) in monthSymbols.enumerated() where symbol == monthSymbol {
                                anyDateComponentChanged = true
                                pickedMonthNumber = index + 1
                            }
                        })
                    }
                } label: {
                    Text("\(pickedMonthName),")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        .frame(minWidth: 130,
                               maxWidth: .infinity,
                               alignment: .trailing)
                }
                
                Menu {
                    ForEach(yearsRange, id: \.self) { yearNumber in
                        Button(String(yearNumber), action: {
                            anyDateComponentChanged = true
                            pickedYearNumber = yearNumber
                        })
                    }
                } label: {
                    Text(String(pickedYearNumber))
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        .frame(minWidth: 70,
                               maxWidth: .infinity,
                               alignment: .leading)
                }
            }
            .fixedSize()
            
            Spacer()
            
            Button {
                // To be uncommented if we want month two buttons not to change actual selection but only displayed month if day picking is displayed
                
//                if !includeDayPicking {
//                    anyDateComponentChanged = true
//                }
                
                anyDateComponentChanged = true
                incrementMonthNumber()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                    .padding(.all, 10)
                    .background {
                        Circle().foregroundColor(.accentColor)
                    }
            }
        }
    }
    
    @ViewBuilder
    func buildCalendar() -> some View {
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
                                
                                anyDateComponentChanged = true
                                pickedDayNumber = calendarDay.value
                            } label: {
                                ZStack {
                                    switch pickingDatesMethod {
                                    case .pickingOneDate:
                                        if calendarDay.value == pickedDayNumber && calendarDay.isCurrentMonth {
                                            Circle()
                                                .foregroundColor(.accentColor)
                                                .opacity(0.7)
                                                .frame(width: 40, height: 40)
                                        }
                                    case .pickingTwoDates:
                                        if ([firstDatePickedDayNumber, secondDatePickedDayNumber].contains(calendarDay.value)) && calendarDay.isCurrentMonth {
                                            Circle()
                                                .foregroundColor(.accentColor)
                                                .opacity(0.7)
                                                .frame(width: 40, height: 40)
                                        }
                                    }
                                    
                                    Text(String(calendarDay.value))
                                        .font(.system(size: 18, weight: .regular, design: .rounded))
                                        .foregroundColor(calendarDay.isCurrentMonth ? (colorScheme == .light ? .black : .ssWhite) : .ssGray)
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
    @State static var firstDatePicked: Date = Date()
    @State static var secondDatePicked: Date = Date()
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                CustomDatePicker(includeDayPicking: true,
                                 datePicked: $firstDatePicked)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                
                CustomDatePicker(firstDatePicked: $firstDatePicked,
                                 secondDatePicked: $secondDatePicked)
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

fileprivate enum PickingDatesMethod {
    case pickingOneDate
    case pickingTwoDates
}
