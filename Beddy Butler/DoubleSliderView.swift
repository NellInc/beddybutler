//
//  DoubleSlider.swift
//  Beddy Butler
//
//  Created by David Garces on 09/09/2015.
//  Copyright © 2015 David Garces. All rights reserved.
//

import Cocoa

class DoubleSliderView: NSSlider, NSCopying {
    
    // MARK: Properties
    
    var stringStartValue: String = ""
    //@NSCopying var attributedStringStartValue: NSAttributedString
    //@NSCopying var objectStartValue: AnyObject? /* id<NSCopying> */
    var intStartValue: Int32 = 0
    var integerStartValue: Int = 0
    var floatStartValue: Float = 0.0
    var doubleStartValue: Double = 0.0
    
    var stringBedValue: String = ""
    //@NSCopying var attributedStringBedValue: NSAttributedString
    //@NSCopying var objectBedValue: AnyObject? /* id<NSCopying> */
    var intBedValue: Int32 = 0
    var integerBedValue: Int = 0
    var floatBedValue: Float = 0.0
    var doubleBedValue: Double = 0.0

    override func keyDown(theEvent: NSEvent) {
        self.interpretKeyEvents([theEvent])
    }

    func copyWithZone(zone: NSZone) -> AnyObject {
        return self
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    override func mouseDown(theEvent: NSEvent) {
        //NSLog("Mouse down in slider! current values are lo: \(self.doubleLoValue()) and hi: \(self.doubleHiValue())")
        super.mouseDown(theEvent)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        // every time the user changes any knob, the system should recalculate the timer
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.userPreferenceChanged.rawValue, object: self)
        
        super.mouseUp(theEvent)
        
    }
    

    
    
}
