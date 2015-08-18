//
//  Betty_ButlerUserDefaultsTests.swift
//  
//
//  Created by David Garces on 18/08/2015.
//
//

import Cocoa
import XCTest

class Betty_ButlerUserDefaultsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testValueForKeyBedTimeValue() {
        // This is an example of a functional test case.
        let value = NSUserDefaults.standardUserDefaults().objectForKey("bedTimeValue") as? Double
        NSLog("The value is: \(value)")
        XCTAssert(value > 0, "Pass")
    }
    
    func testValueForKeyStartTimeValue() {
        // This is an example of a functional test case.
        let value = NSUserDefaults.standardUserDefaults().objectForKey("startTimeValue") as? Double
        NSLog("The value is: \(value)")
        XCTAssert(value > 0, "Pass")
    }
    
    func testValueForKeyrunStartupValue() {
        // This is an example of a functional test case.
        let value: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("runStartup")
        XCTAssert(value is Bool, "Pass")
         NSLog("The value is: \(value as! Bool)")
    }
    
    func testValueForKeySelectedSound() {
        // This is an example of a functional test case.
        let value = NSUserDefaults.standardUserDefaults().objectForKey("selectedSound") as? String
        
        NSLog("The value is: \(value)")
        XCTAssertNotEqual(value!,String(), "Pass")
    }

}
