//
//  NSDate+Judo.swift
//  JudoKit
//
//  Created by Ashley Barrett on 28/10/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

import Foundation

public extension Date {

    func dateByAddingYears(_ years: Int) -> Date? {
        return Calendar.current.date(byAdding: .year, value: years, to: self)
    }

    func dateAtTheEndOfMonth() -> Date {
        //Create the date components
        var components = Date.components(fromDate: self)!
        //Set the last day of this month
        components.month! += 1
        components.day = 0
        
        //Builds the first day of the month
        let lastDayOfMonth = Calendar.current.date(from: components)!
        
        return lastDayOfMonth
    }

    private static func components(fromDate: Date) -> DateComponents! {
        return (Calendar.current as NSCalendar).components(Date.componentFlags(), from: fromDate)
    }

    private static func componentFlags() -> NSCalendar.Unit {
        return [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second, NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.weekOfYear]
    }
}
