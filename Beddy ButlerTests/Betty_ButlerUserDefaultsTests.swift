//
//  Betty_ButlerUserDefaultsTests.swift
//  
//
//  Created by David Garces on 18/08/2015.
//
//

import Cocoa
import XCTest
@testable import Beddy_Butler
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class Betty_ButlerUserDefaultsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValueforNonExistingKey() {
        let value: AnyObject? = UserDefaults.standard.object(forKey: "testKey") as AnyObject?
        XCTAssertNil(value, "value for testKey should always be nil because it does not exist")
    }

    func testValueForKeyBedTimeValue() {
        let value = UserDefaults.standard.object(forKey: UserDefaultKeys.bedTimeValue.rawValue) as? Double
        NSLog("The value is: \(value)")
        XCTAssert(value > 0, "User stored preference for bed time value can be accessed")
    }
    
    func testValueForKeyStartTimeValue() {
        let value = UserDefaults.standard.object(forKey: UserDefaultKeys.startTimeValue.rawValue) as? Double
        NSLog("The value is: \(value)")
        XCTAssert(value > 0, "User stored preference for start time value can be accessed")
    }
    
    func testValueForKeyrunStartupValue() {
        let value: AnyObject? = UserDefaults.standard.object(forKey: UserDefaultKeys.runStartup.rawValue)
        XCTAssert(value is Bool, "User stored preference for run at startup value can be accessed")
         NSLog("The value is: \(value as! Bool)")
    }
    
    func testValueForKeySelectedSound() {
        
        let value = UserDefaults.standard.object(forKey: UserDefaultKeys.selectedSound.rawValue) as? String
        
        NSLog("The value is: \(value)")
        XCTAssertNotEqual(value!,String(), "User stored preference for selected sound value can be accessed")
    }
    
    func testValueForKeyStartTimeCanBeConvertedToDate() {
        let value = UserDefaults.standard.object(forKey: UserDefaultKeys.startTimeValue.rawValue) as? Double
        let date = Date(timeIntervalSince1970: value!)
        NSLog("The date value is: \(date)")
        XCTAssertNotNil(value, "Start date can be converted to date")
    }
    
    

}
