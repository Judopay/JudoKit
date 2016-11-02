//
//  NSDate+Judo.swift
//  JudoKit
//
//  Created by Ashley Barrett on 28/10/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

import Foundation

public extension Date {
    public func dateByAddingYears(_ years: Int) -> Date? {
        return (Calendar.current as NSCalendar).date(byAdding: .year, value: years, to: self, options: NSCalendar.Options(rawValue: 0))
    }
    
    public func dateAtTheEndOfMonth() -> Date {
        //Create the date components
        var components = self.components()
        //Set the last day of this month
        components.month! += 1
        components.day = 0
        
        //Builds the first day of the month
        let lastDayOfMonth :Date = Calendar.current.date(from: components)!
        
        return lastDayOfMonth
    }
    
    fileprivate static func components(fromDate: Date) -> DateComponents! {
        return (Calendar.current as NSCalendar).components(Date.componentFlags(), from: fromDate)
    }
    
    fileprivate func components() -> DateComponents  {
        return Date.components(fromDate: self)!
    }
    
    fileprivate static func componentFlags() -> NSCalendar.Unit { return [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second, NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.weekOfYear]
    }
}
