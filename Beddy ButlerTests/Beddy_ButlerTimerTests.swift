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
        NSNotificationCenter.defaultCenter().postNotificationName(ObserverKeys.startSliderChanged.rawValue, object: StartSliderView())
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
        NSNotificationCenter.defaultCenter().postNotificationName(ObserverKeys.endSliderChanged.rawValue, object: StartSliderView())
        NSLog("previous date: \(currentEndDate) new date: \(newButlerTimer.bedDate)")
        // Assert
        XCTAssertNotEqual(currentEndDate, self.butlerTimer.bedDate, "Butler timer should update end time after user updates end time")
        
        
    }
    
    func testTimerCalculates() {
        //Test 1: first set the user values for the test. Check the current time, run the app and change preferences so that you set the start timer about one hour AFTER now, and the end timer about two or three hours AFTER now.
        
        //Test 2: Check the current time, run the app and change preferences so that you set the start timer about one hour BEFORE now, and the end timer about one or two hours AFTER now.
        
        //Test 3: Check the current time, run the app and change preferences so that you set the start timer about two hours BEFORE now, and the end timer about one hours BEFORE now.
   
        let theButlerTimer = ButlerTimer()
        
        //Make a date before the current start date
        let calendar = NSCalendar.currentCalendar()
        let startOfDay = calendar.startOfDayForDate(NSDate())
        
        let currentDate = NSDate()
        
        theButlerTimer.calculateNewTimer()
        
        var dateAfterInterval = theButlerTimer.timer?.fireDate
        NSLog("Timer interval: \(theButlerTimer.timer!.fireDate.timeIntervalSinceDate(currentDate))")
        NSLog("Simulated current date: \(currentDate)")
        NSLog("date after Inverval: \(dateAfterInterval)")
        NSLog("start date: \(theButlerTimer.startDate)")
        XCTAssertTrue(dateAfterInterval!.isGreaterThan(theButlerTimer.startDate), "When calculating timer before startDate, timer should execute after startDate")
        
        if theButlerTimer.bedDate.isGreaterThan(currentDate) {
            XCTAssertTrue(theButlerTimer.bedDate.isGreaterThan(dateAfterInterval), "When calculating timer before endDate, timer should execute before endDate")
        } else
        {
             XCTAssertTrue(dateAfterInterval!.isGreaterThan(theButlerTimer.bedDate), "When calculating timer after startDate, timer should execute after today's bedDate")
            let components = NSDateComponents()
            components.day = 1
            let tomorrowsStartDate = calendar.dateByAddingComponents(components, toDate: theButlerTimer.startDate, options: nil)
             let tomorrowsEndDate = calendar.dateByAddingComponents(components, toDate: theButlerTimer.bedDate, options: nil)
             XCTAssertTrue(dateAfterInterval!.isGreaterThan(tomorrowsStartDate), "When calculating timer after startDate, timer should execute after startDate of next day and before enddate of next day")
             XCTAssertTrue(tomorrowsEndDate!.isGreaterThan(dateAfterInterval), "When calculating timer after startDate, timer should execute after startDate of next day and before enddate of next day")

            
        }
        
        
    }
    
    
    
    func testTimer1Initialises() {
        NSLog("The timer 1 is: \(butlerTimer.timer)")
        XCTAssertTrue(butlerTimer.timer?.timeInterval > 0, "Timer1 should be initialized")
    }
    
    
    

}
