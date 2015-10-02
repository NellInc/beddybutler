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
    // TO DO: need to fix curRatio vs slidervalue
    var _curRatio: CGFloat {
        didSet {
            
            if self.name == SliderKeys.StartHandler.rawValue {
                NSUserDefaults.standardUserDefaults().setDouble(Double(_curRatio*86400), forKey: UserDefaultKeys.startTimeValue.rawValue)
            } else {
                NSUserDefaults.standardUserDefaults().setDouble(Double(_curRatio*86400), forKey: UserDefaultKeys.bedTimeValue.rawValue)
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
        
    required init(name: String, image: NSImage, curRatio: CGFloat, sliderValue: SliderValue, sliderValueChanged: SliderValue) {
            self.name = name
            self.handleImage = image
            self.sliderValue = sliderValue
            self.sliderValueChanged = sliderValueChanged
            self.handleView = NSView()
            self._curRatio = curRatio
        
        }
    
    func ratioForValue(value: CGFloat) -> CGFloat {
        var ratio = value
        if let theChangedValue = self.sliderValueChanged {
            ratio = theChangedValue(value: ratio)
        }
        return ratio
    }
    

}
