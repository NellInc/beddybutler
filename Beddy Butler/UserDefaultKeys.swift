//
//  UserDefaultKeys.swift
//  Beddy Butler
//
//  Created by David Garces on 21/08/2015.
//  Copyright (c) 2015 David Garces. All rights reserved.
//

import Foundation

enum UserDefaultKeys: String {
    
    //Note: In swift 2.0 we may be able to remove the assignements: If the raw-value type is specified as String and you don’t assign values to the cases explicitly, each unassigned case is implicitly assigned a string with the same text as the name of that case.

    case bedTimeValue = "bedTimeValue"
    case startTimeValue = "startTimeValue"
    case runStartup = "runStartup"
    case selectedSound = "selectedSound"
    // keep an array of all the values to iterate through them
    static let allValues = [bedTimeValue, startTimeValue, runStartup, selectedSound]
}