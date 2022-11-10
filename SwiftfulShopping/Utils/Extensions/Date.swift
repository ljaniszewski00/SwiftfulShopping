//
//  Date.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 25/06/2022.
//

import Foundation
import texterify_ios_sdk

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

extension Date {
    func getRandomDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateFormat = "yyyy-MM-dd"
        let date1 = Date.parse("2010-06-24", format: dateFormat)
        let date2 = Date.parse(dateFormatter.string(from: Date()), format: dateFormat)
        return Date.randomBetween(start: date1, end: date2)
    }
    
    static func randomBetween(start: Date, end: Date) -> Date {
            var date1 = start
            var date2 = end
            if date2 < date1 {
                let temp = date1
                date1 = date2
                date2 = temp
            }
            let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
            return Date(timeIntervalSinceNow: span)
    }

    func dateString(_ format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getDateFrom(_ string: String) -> Date? {
        DateFormatter().date(from: string)
    }

    static func parse(_ string: String, format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: string)!
        return date
    }
    
    static func getMonthNameFor(monthNumber: Int) -> String {
        switch monthNumber {
        case 1:
            return TexterifyManager.localisedString(key: .months(.january))
        case 2:
            return TexterifyManager.localisedString(key: .months(.february))
        case 3:
            return TexterifyManager.localisedString(key: .months(.march))
        case 4:
            return TexterifyManager.localisedString(key: .months(.april))
        case 5:
            return TexterifyManager.localisedString(key: .months(.may))
        case 6:
            return TexterifyManager.localisedString(key: .months(.june))
        case 7:
            return TexterifyManager.localisedString(key: .months(.july))
        case 8:
            return TexterifyManager.localisedString(key: .months(.august))
        case 9:
            return TexterifyManager.localisedString(key: .months(.september))
        case 10:
            return TexterifyManager.localisedString(key: .months(.october))
        case 11:
            return TexterifyManager.localisedString(key: .months(.november))
        case 12:
            return TexterifyManager.localisedString(key: .months(.december))
        default:
            return ""
        }
    }
    
    static func getDayAndMonthFrom(date: Date) -> String {
        let day = date.get(.day)
        let month = date.get(.month)
        let monthName = getMonthNameFor(monthNumber: month)
        return "\(day) \(monthName)"
    }
    
    static func getMonthNameAndYearFrom(date: Date) -> String {
        let month = date.get(.month)
        let year = date.get(.year)
        let monthName = getMonthNameFor(monthNumber: month)
        return "\(monthName) \(year)"
    }
    
    static func getDayMonthYearFrom(date: Date) -> String {
        return "\(date.get(.day)) \(getMonthNameFor(monthNumber: date.get(.month))) \(date.get(.year))"
    }
}
