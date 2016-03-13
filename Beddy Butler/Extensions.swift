//
//  Extensions.swift
//  Beddy Butler
//
//  Created by David Garces on 07/02/2016.
//  Copyright © 2016 David Garces. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

extension NSDate {
    class func randomTimeBetweenDates(lhs: NSDate, _ rhs: NSDate) -> NSDate {
        let lhsInterval = lhs.timeIntervalSince1970
        let rhsInterval = rhs.timeIntervalSince1970
        let difference = fabs(rhsInterval - lhsInterval)
        let randomOffset = arc4random_uniform(UInt32(difference))
        let minimum = min(lhsInterval, rhsInterval)
        let randomInterval = minimum + NSTimeInterval(randomOffset)
        return NSDate(timeIntervalSince1970: randomInterval)
    }
    
    /// Returns the date offset from GMT to show local date and time
    var localDate: NSDate {
        let localTimeZone = NSTimeZone.localTimeZone()
        let secondsFromGTM = NSTimeInterval.init(localTimeZone.secondsFromGMT)
        let resultDate = NSDate(timeInterval: secondsFromGTM, sinceDate: self)
        print("Today is \(resultDate) and the time zone is \(NSTimeZone.localTimeZone())")
        return resultDate
    }
    
    var localStartOfDay: NSDate {
        let calendar = NSCalendar.currentCalendar()
        let localTimeZone = NSTimeZone.localTimeZone()
        calendar.timeZone = localTimeZone
        let secondsFromGTM = NSTimeInterval.init(localTimeZone.secondsFromGMT)
        let startOfToday = calendar.startOfDayForDate(self.localDate)
        let resultDate = NSDate(timeInterval: secondsFromGTM, sinceDate: startOfToday)
        return resultDate
    }
    
    func addSecondsToLocalStartDate(seconds: Double) -> NSDate {
        return NSDate(timeInterval: NSTimeInterval.init(seconds), sinceDate: localStartOfDay)
    }
}