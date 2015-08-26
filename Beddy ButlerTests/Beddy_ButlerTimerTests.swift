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
    
    func testRandomTestIntervalGeneratesCorrectValues() {
        // "randomInterval should generate values between 300 and 1200"
        for x in 0...20 {
            let result = butlerTimer.testInteval
            NSLog("Randomly generated number \(x): \(result)")
            XCTAssertTrue((result > 0) && (result < 100) , "random testInterval should generate values between 0 and 100")
        }
    }
    
    /// Butler timer should update start time after user updates start time
    func testUpdateStartTime() {
        // Initially change the user setting so that it's different that what we will use for testing
        NSUserDefaults.standardUserDefaults().setValue(50000, forKey: UserDefaultKeys.startTimeValue.rawValue)
        let newButlerTimer = ButlerTimer()
        // read the current value from ButlerTimer
        let currentStartDate = newButlerTimer.startDate
        // emulate a new value set by the user
        NSUserDefaults.standardUserDefaults().setValue(65000, forKey: UserDefaultKeys.startTimeValue.rawValue)
        NSNotificationCenter.defaultCenter().postNotificationName(ObserverKeys.startTimeValueChanged.rawValue, object: StartSliderView())
        NSLog("previous date: \(currentStartDate) new date: \(newButlerTimer.startDate)")
        // Assert
        XCTAssertNotEqual(currentStartDate, self.butlerTimer.startDate, "Butler timer should update start time after user updates start time")
        
        
    }
    
    /// Butler timer should update end time after user updates end time
    func testUpdateEndTime() {
        // Initially change the user setting so that it's different that what we will use for testing
        NSUserDefaults.standardUserDefaults().setValue(67000, forKey: UserDefaultKeys.bedTimeValue.rawValue)
        let newButlerTimer = ButlerTimer()
        // read the current value from ButlerTimer
        let currentEndDate = newButlerTimer.bedDate
        // emulate a new value set by the user
        NSUserDefaults.standardUserDefaults().setValue(72000, forKey: UserDefaultKeys.bedTimeValue.rawValue)
        NSNotificationCenter.defaultCenter().postNotificationName(ObserverKeys.bedTimeValueChanged.rawValue, object: StartSliderView())
        NSLog("previous date: \(currentEndDate) new date: \(newButlerTimer.bedDate)")
        // Assert
        XCTAssertNotEqual(currentEndDate, self.butlerTimer.bedDate, "Butler timer should update end time after user updates end time")
        
        
    }
    
    func testTimerCalculates1() {
        // first set the user values for the test
        NSUserDefaults.standardUserDefaults().setValue(6000, forKey: UserDefaultKeys.startTimeValue.rawValue)
        NSUserDefaults.standardUserDefaults().setValue(12000, forKey: UserDefaultKeys.bedTimeValue.rawValue)
        
        let theButlerTimer = ButlerTimer()
        
        //Make a date before the current start date
        let calendar = NSCalendar.currentCalendar()
        let startOfDay = calendar.startOfDayForDate(NSDate())
        
        let simulatedCurrentDate = startOfDay.dateByAddingTimeInterval(NSTimeInterval(1000))
        
        theButlerTimer.calculateNewTimer(simulatedCurrentDate)
        
        var dateAfterInterval = NSDate(timeInterval: theButlerTimer.timer!.timeInterval, sinceDate: simulatedCurrentDate)
        NSLog("Timer interval: \(theButlerTimer.timer!.timeInterval)")
        NSLog("Simulated current date: \(simulatedCurrentDate)")
        NSLog("date after Inverval: \(dateAfterInterval)")
        NSLog("start date: \(startOfDay.dateByAddingTimeInterval(6000))")
        XCTAssertTrue(dateAfterInterval.isGreaterThan(startOfDay.dateByAddingTimeInterval(6000)), "When calculating timer before startDate, timer should execute after startDate")
        
        XCTAssertTrue(startOfDay.dateByAddingTimeInterval(12000).isGreaterThan(dateAfterInterval), "When calculating timer before startDate, timer should execute before bedDate")
    }
    
    
    func testTimer1Initialises() {
        NSLog("The timer 1 is: \(butlerTimer.timer)")
        XCTAssertTrue(butlerTimer.timer?.timeInterval > 0, "Timer1 should be initialized")
    }
    
    
    

}
