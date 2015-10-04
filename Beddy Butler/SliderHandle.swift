//
//  SliderHandle.swift
//  Beddy Butler
//
//  Created by David Garces on 21/09/2015.
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//

import Cocoa

class SliderHandle: NSObject {
    
    //MARK: Types
    typealias SliderValue = (value: CGFloat) -> CGFloat
    typealias SliderValueChanged  = [String: CGFloat]

    var sliderValue: SliderValue?
    var sliderValueChanged: SliderValue?
    var name: String
    var handleImage: NSImage
    var offset:CGFloat {
        let offsetValue: CGFloat = 0.0
        return self.name == SliderKeys.StartHandler.rawValue ? offsetValue : -offsetValue
    }
    var userTimeValue: Double {
        get {
            return Double(self._curRatio + offset) * 86400
        }
        set {
                self._curRatio = CGFloat (newValue / 86400) + offset
        }
    }
    // TO DO: need to fix curRatio vs slidervalue
    var _curRatio: CGFloat {
        didSet {
            
            if self.name == SliderKeys.StartHandler.rawValue {
                NSUserDefaults.standardUserDefaults().setDouble(userTimeValue, forKey: UserDefaultKeys.startTimeValue.rawValue)
            } else {
                NSUserDefaults.standardUserDefaults().setDouble(userTimeValue, forKey: UserDefaultKeys.bedTimeValue.rawValue)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.userPreferenceChanged.rawValue, object: self)
        }
    }
    var curValue: CGFloat {
        get {
            var value = self._curRatio
            if let theCurrentValue = sliderValue {
                value = theCurrentValue(value: value)
            }
            return value
        }
        set {
            self._curRatio = newValue
        }
        
    }

    var handleView: NSView
        
    required init(name: String, image: NSImage, timeValue: Double, sliderValue: SliderValue, sliderValueChanged: SliderValue) {
            self.name = name
            self.handleImage = image
            self.sliderValue = sliderValue
            self.sliderValueChanged = sliderValueChanged
            self.handleView = NSView()
            //let offset: CGFloat = name == SliderKeys.StartHandler.rawValue ? 0.01 : -0.01
            self._curRatio = CGFloat ( timeValue / 86400) 
 
        }
    
    
    func ratioForDoubleValue(value: Double) -> CGFloat {
        
        let offset: CGFloat = 0.02
        let isStartSlider = name == SliderKeys.StartHandler.rawValue
        
        //First calculate plain value
        let theValue = CGFloat ( value / 86400)
        
        if isStartSlider {
            let theNewValue = theValue  + offset
            if theNewValue <= offset || theNewValue >= (1 - offset) { return theValue } else {
                return theNewValue
            }
            
        } else {
            let theNewValue = theValue  - offset
            if theNewValue <= offset || theNewValue >= (1 - offset) { return theValue } else {
                return theNewValue
            }
        }
        
    }
    
    func ratioForValue(value: CGFloat) -> CGFloat {
        var ratio = value
        if let theChangedValue = self.sliderValueChanged {
            ratio = theChangedValue(value: ratio)
        }
        return ratio
    }
    

}
