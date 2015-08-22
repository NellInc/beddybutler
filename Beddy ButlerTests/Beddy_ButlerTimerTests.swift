//
//  Beddy_ButlerTimerTests.swift
//  
//
//  Created by David Garces on 21/08/2015.
//
//

import Cocoa
import XCTest

class Beddy_ButlerTimerTests: XCTestCase {
    
    var startSlider = StartSliderView()
    var endSlider = EndSliderView()
    var butlerTimer = ButlerTimer()
    
    let calendar = NSCalendar.currentCalendar()
    var startOfDay: NSDate {
        return calendar.startOfDayForDate(NSDate())
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInterval() {
        let theDate = NSDate()
        NSLog("Interval: \(theDate)")
        XCTAssertTrue(theDate.timeIntervalSince1970 > 1, "test")
    }
    
    
    func testStartDateInitialises() {
        let theDate = butlerTimer.startDate
        NSLog("Now: \(startOfDay)")
        NSLog("The date: \(theDate)")
        XCTAssertTrue(theDate.timeIntervalSinceDate(startOfDay) > 0, "the start date should be around now")
    }
    
    func testEndDateInitialises() {
        let theDate = butlerTimer.bedDate
        NSLog("Now: \(startOfDay)")
        NSLog("The date: \(theDate)")
        XCTAssertTrue(theDate.timeIntervalSinceDate(startOfDay) > 0, "the start date should be around now")
    }
    
    func testMainIntervalInitialises(){
        NSLog("The main interval: \(butlerTimer.mainInterval)")
        XCTAssertTrue(butlerTimer.mainInterval > 0, "Timer1 should be initialized")
    }
    
    
    func testRandomIntervalGeneratesCorrectValues() {
        // "randomInterval should generate values between 300 and 1200"
        for x in 0...20 {
            let result = butlerTimer.randomInterval
            NSLog("Randomly generated number \(x): \(result)")
            XCTAssertTrue((result > 300) && (result < 1200) , "randomInterval should generate values between 300 and 1200")
        }
    }
    
    func testTimer1Initialises() {
        NSLog("The timer 1 is: \(butlerTimer.timer)")
        XCTAssertTrue(butlerTimer.timer?.timeInterval > 0, "Timer1 should be initialized")
    }
    

    func testStartSliderUpdatesTimer() {
//        butlerTimer.timer1 
//        startSlider.doubleValue = 35000
//        let userDefaultValue = NSUserDefaults.standardUserDefaults().valueForKey(UserDefaultKeys.startTimeValue.rawValue) as? Double
//        XCTAssertEqual(butlerTimer.userStartTime!.timeIntervalSince1970, userDefaultValue!, "When start slider is updated, ButlerTimer start time updates (i.e. its value is equal to the value stored in user defaults")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
