//
//  CalculateEstimatedDeliveryDate.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 31/07/2022.
//

import Foundation

func calculateEstimatedDeliveryDate(orderDate: Date, shippingMethod: ShippingMethod) -> Date {
    var dayComponent = DateComponents()
    dayComponent.day = (shippingMethod == .parcel ? 2 : 3)
    var estimatedDeliveryDate = Calendar.current.date(byAdding: dayComponent, to: Date())
    
    dayComponent.day = 1
    while Calendar.current.isDateInWeekend(estimatedDeliveryDate!) {
        estimatedDeliveryDate = Calendar.current.date(byAdding: dayComponent, to: estimatedDeliveryDate!)
    }
    
    return estimatedDeliveryDate!
}
