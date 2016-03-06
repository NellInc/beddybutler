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
    
    var preferencesViewController: PreferencesViewController?
    var doubleSliderHandler: DoubleSliderHandler? {
        get {
            return preferencesViewController?.doubleSliderHandler
        }
        set {
            preferencesViewController?.doubleSliderHandler = newValue
        }
        
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        
       
        preferencesViewController = storyboard.instantiateControllerWithIdentifier("Preferences Storyboard") as? PreferencesViewController
        let _ = preferencesViewController?.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        doubleSliderHandler = nil
    }
    
    func testStartSliderSetsValue() {
        doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue = 0.1
        XCTAssertTrue(doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue > 0, "Start Slider can set value")
    }
    
    func testBedSliderSetsValue() {
        doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue = 0.5
        XCTAssertTrue(doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue > 0, "Bed Slider can set value")
    }
    
    func testStartSliderChanges2() {
        doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue = 0.7
        doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue = 0.9
        XCTAssertTrue(doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue < 10, "start time updates to < than end time if we set end time < than start time")
    }
    
    /// Actually possible only in UI Tests (restrictions to start or low value only happen during dragging
    func testStartSliderChange3() {
        doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue = 0.9
        doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue = 0.7
        Swift.print(doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue)
        XCTAssertTrue(doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue == ( (0.9 - 0.7)/2 + 0.9 ), "start time updates to < than end time if we set end time < than start time")
    }
    
    /// Values between 0 and 43200 should render a converted value between 0.5 and 1
    func testSliderValuesAbove43200() {

        func calculateRatio(value:Double) -> Double {
            return ( value * 0.5 / 43200.0 ) + 0.5
        }
        
        for item in 0...43200 {
            let converted = calculateRatio(Double(item))
            
            XCTAssertTrue(converted >= 0.5 && converted <= 1)
            
        }
    }
    
    /// Values between 43200 and 86400
    func testSliderValuesBelow43200() {
 
        func calculateRatio(value:Double) -> Double {
            return ( value * 0.5 / 43200.0 ) - 0.5
        }
        
        
        for item in 43200...86400 {
            let converted = calculateRatio(Double(item))
            
            XCTAssertTrue(converted >= 0 && converted <= 0.5)
           
        }
        
        
    }
    
    /// Values between 0 and 0.5 should render a converted value between 0.5 and 1
    func testSliderValuesFromRatioBelow() {
        
        func calculateRatio(value:Double) -> Double {
            return ( value * 43200.0 / 0.5 ) + 43200
        }
        
        let secondsInterval = 43200.0...86400.0
        //let interval = 0...0.5
        
        for var i = 0.0; i <= 0.5; i = i + 0.01 {
            let converted = calculateRatio(Double(i))
             print("original is: \(i), converted is: \(converted)")
            XCTAssertTrue(secondsInterval.contains(converted))
            
        }
    }
    
    /// Values between 0.5 and 1 should render converted values between 0 and 43200
    func testSliverValuesFromRatioAbove() {
        
        func calculateRatio(value:Double) -> Double {
            return ( value * 43200.0 / 0.5 ) - 43200
        }
        
        let secondsInterval = 0.0...43200.0
        //let interval = 0.5...1
        
        for var i = 0.5; i <= 1.0; i = i + 0.01 {
            let converted = calculateRatio(Double(i))
            print("original is: \(i), converted is: \(converted)")
            XCTAssertTrue(secondsInterval.contains(converted))
            
        }
        
        
    }
    

    
    func testSliderBidirectionalValueConvertion() {
        func convertToRatio(seconds: Double) -> Double {
            let lowerRange = 0.0...43200.0
            if lowerRange.contains(seconds) {
                return ( seconds * 0.5 / 43200.0 ) + 0.5
            } else {
                return ( seconds * 0.5 / 43200.0 ) - 0.5
            }
        }
        func convertToSeconds(value: Double) -> Double {
            let lowerRange = 0...0.5
            if lowerRange.contains(value) {
                let value =  ( value * 43200.0 / 0.5 ) + 43200
                return value.roundToPlaces(3)
            } else {
                let value = ( value * 43200.0 / 0.5 ) - 43200
                return value.roundToPlaces(3)
            }
        }
        

        
        let originalSecs = 25469.9680259824.roundToPlaces(3)
        
        let convertedRatio = convertToRatio(originalSecs)
        let convertedSeconds = convertToSeconds(convertedRatio)
        
        XCTAssertEqual(originalSecs, convertedSeconds)
        
        
        
        
        
//        let leftSecondsArray = [Double]() // for left values (from 43200.01 to 86400.0)
//        let rightSecondsArray = [Double]() // for right values (from 0.0 to 43200.0)
//        
//
//        
//        let rightConvertedSecondsArray = [Double]()
//        let leftConvertedSecondsArray = [Double]()
//        
//        // LEFT
//        for var i = 0.0; i <= 0.5; i = i + 0.01 {
//            let converted = calculateRatio(Double(i))
//            print("original is: \(i), converted is: \(converted)")
//            XCTAssertTrue(secondsInterval.contains(converted))
//            
//        }
//        
//        // RIGHT
//        for var i = 0.5; i <= 1.0; i = i + 0.01 {
//            let converted = calculateRatio(Double(i))
//            print("original is: \(i), converted is: \(converted)")
//            XCTAssertTrue(secondsInterval.contains(converted))
//            
//        }
        
        
    }

    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
