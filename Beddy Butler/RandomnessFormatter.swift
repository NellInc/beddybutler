//
//  RandomnessFormatter.swift
//  
//
//  Created by David Garces on 29/08/2015.
//
//

import Cocoa

class RandomnessFormatter: NSFormatter {
    
    override func stringForObjectValue(obj: AnyObject) -> String? {
        
        let number = obj as! Double
        let secondNumber = (number * 0.7) + number
        
        var numberEndIndex = number < 10 ? 3 : 4
        var secondNumberEndIndex = secondNumber < 10 ? 3 : 4
        
        var stringForm = number.description.substringToIndex(advance(number.description.startIndex, numberEndIndex))
            
        stringForm = stringForm + " - "
        stringForm = stringForm + secondNumber.description.substringToIndex(advance(secondNumber.description.startIndex, secondNumberEndIndex)) + " min."
        
        return stringForm
        
    }
    
    
    override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>, forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
        
        
        var intResult: Int
        var scanner: NSScanner
        var returnValue: Bool
        
        var returnString = String()
        
        for char in string.generate() {
            if char != "-" {
                returnString = returnString + String(char)
            } else
            {
               break
            }
        }
        
        
        if let theInt =  returnString.toInt() {
            return true
        } else
        {
            return false
        }
    }

}
