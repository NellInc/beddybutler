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
    func roundToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Date {
    static func randomTimeBetweenDates(_ lhs: Date, _ rhs: Date) -> Date {
        let lhsInterval = lhs.timeIntervalSince1970
        let rhsInterval = rhs.timeIntervalSince1970
        let difference = fabs(rhsInterval - lhsInterval)
        let randomOffset = arc4random_uniform(UInt32(difference))
        let minimum = min(lhsInterval, rhsInterval)
        let randomInterval = minimum + TimeInterval(randomOffset)
        return Date(timeIntervalSince1970: randomInterval)
    }
    
    /// Returns the date offset from GMT to show local date and time
    var localDate: Date {
        let localTimeZone = TimeZone.autoupdatingCurrent
        let secondsFromGTM = TimeInterval.init(localTimeZone.secondsFromGMT())
        let resultDate = Date(timeInterval: secondsFromGTM, since: self)
        print("Today is \(resultDate) and the time zone is \(TimeZone.autoupdatingCurrent)")
        return resultDate
    }
    
    var localStartOfDay: Date {
        var calendar = Calendar.current
        let localTimeZone = TimeZone.autoupdatingCurrent
        calendar.timeZone = localTimeZone
        let secondsFromGTM = TimeInterval.init(localTimeZone.secondsFromGMT())
        let startOfToday = calendar.startOfDay(for: self.localDate)
        let resultDate = Date(timeInterval: secondsFromGTM, since: startOfToday)
        return resultDate
    }
    
    func addSecondsToLocalStartDate(_ seconds: Double) -> Date {
        return Date(timeInterval: TimeInterval.init(seconds), since: localStartOfDay)
    }
}

extension Notification.Name {
    static let userPreferenceChanged = Notification.Name("userPreferenceChanged") // Used to notify the ButlerTimer that it should recalculate a timer
    static let startSliderChanged = Notification.Name("startSliderChanged") // Used to notify the end slider that it should change to a valid position
    static let endSliderChanged = Notification.Name("endSliderChanged") // Used to notify the start slider that it should changed to a valid position
    static let terminateApp = Notification.Name("terminateApp")
}
