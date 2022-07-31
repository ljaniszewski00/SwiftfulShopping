//
//  CalculateEstimatedDeliveryDate.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 31/07/2022.
//

import Foundation

func calculateEstimatedDeliveryDate(orderDate: Date) -> Date {
    var dayComponent = DateComponents()
    dayComponent.day = 2
    var estimatedDeliveryDate = Calendar.current.date(byAdding: dayComponent, to: Date())
    
    dayComponent.day = 1
    while Calendar.current.isDateInWeekend(estimatedDeliveryDate!) {
        estimatedDeliveryDate = Calendar.current.date(byAdding: dayComponent, to: Date())
    }
    
    return estimatedDeliveryDate!
}
