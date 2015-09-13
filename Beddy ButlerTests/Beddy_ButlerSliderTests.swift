//
//  Beddy_ButlerTests.swift
//  Beddy ButlerTests
//
//  Created by David Garces on 10/08/2015.
//  Copyright (c) 2015 David Garces. All rights reserved.
//

import Cocoa
import XCTest
@testable import Beddy_Butler

class Beddy_ButlerSliderTests: XCTestCase {
    
    var startSlider: StartSliderView?
    var endSlider: EndSliderView?
    var preferencesViewController: PreferencesViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
       startSlider = StartSliderView()
        endSlider = EndSliderView()
        preferencesViewController = storyboard.instantiateControllerWithIdentifier("Preferences Storyboard") as? PreferencesViewController
        let _ = preferencesViewController?.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        startSlider = nil
    }
    
    func testStartSliderSetsValue() {
        startSlider?.doubleValue = 10
        XCTAssertTrue(startSlider?.doubleValue > 0, "Start Slider can set value")
    }
    
    func testEndSliderSetsValue() {
        endSlider?.doubleValue = 10
        NSLog("current value is: \(endSlider?.doubleValue)")
        XCTAssertTrue(endSlider?.doubleValue == 10, "End Slider can set value")
    }
    
    func testStartSliderChanges1() {
        
       //preferencesViewController?.startSliderView = StartSliderView()
        preferencesViewController?.doubleSlider.doubleValue = 30000
        XCTAssertTrue(startSlider?.doubleValue == 30000, "start time remains unchanged before setting end time > start time")
         endSlider?.doubleValue = 20000
        //XCTAssertTrue(startSlider?.doubleValue == 10, "start time remains unchanged after setting end time > start time")
    }
    
    func testStartSliderChanges2() {
        startSlider?.doubleValue = 10
        endSlider?.doubleValue = 9
        XCTAssertTrue(startSlider?.doubleValue < 10, "start time updates to < than end time if we set end time < than start time")
    }
    
    func testStartSliderChanges3() {
        startSlider?.doubleValue = 100
        endSlider?.doubleValue = 90
        XCTAssertTrue(startSlider?.doubleValue == (90 - 30), "start time updates to (end time - 30) if we set end time < start time ")
    }
    
    func testEndSliderChanges1() {
        startSlider?.doubleValue = 100
        endSlider?.doubleValue = 200
        startSlider?.doubleValue = 130
        XCTAssertTrue(endSlider?.doubleValue == 200, "end time remains unchanged after setting start time < end time")
    }
    
    func testEndSliderChanges2() {
        startSlider?.doubleValue = 100
        endSlider?.doubleValue = 200
        startSlider?.doubleValue = 300
        XCTAssertTrue(endSlider?.doubleValue > 300, "end time  updates to > than start time if we set start time > than end time")
    }
    
    func testEndSliderChanges3() {
        startSlider?.doubleValue = 100
        endSlider?.doubleValue = 200
        startSlider?.doubleValue = 300
        XCTAssertTrue(endSlider?.doubleValue == (300 + 30), "end time  updates to (start time + 30) if we set start time > than end time")
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
