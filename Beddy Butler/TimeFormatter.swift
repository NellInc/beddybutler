//
//  TimeFormatter.swift
//  Beddy Butler
//
//  Created by David Garces on 11/03/2016.
//  Copyright © 2016 David Garces. All rights reserved.
//

import Cocoa

class TimeFormatter: Formatter {
    
    
    override func string(for obj: Any?) -> String? {
        
        let doubleTime = obj as! Double
        
        
        var hours = doubleTime/3600
        
        if hours >= 24.0 {
            hours = 0.0
        }
        
        var hoursFormatted = String(format:"%.0f", hours)
        
        var minutes = (doubleTime - (Double(hoursFormatted)!*3600))/60
        
        minutes = minutes < 0.0 ? 0.0 : minutes
        
        var minutesFormatted = String(format:"%.0f", minutes)
        
        minutesFormatted = minutes < 10 ? "0\(minutesFormatted)" : minutesFormatted
        hoursFormatted = hours < 10 ? "0\(hoursFormatted)" : hoursFormatted
        
        let stringForm: String = "\(hoursFormatted):\(minutesFormatted)"
        
        return stringForm
        
    }
    
//
//    override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>, forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
//        
//        
//        let time = string
//        
//        let returnString = time.characters.split(":")
//            .flatMap { Int(String($0)) }
//            .reduce(0) {  $0 * 60 + $1 }
//        
//        }


    
}
