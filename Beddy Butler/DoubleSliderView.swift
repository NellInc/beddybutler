//
//  DoubleSlider.swift
//  Beddy Butler
//
//  Created by David Garces on 09/09/2015.
//  Copyright © 2015 David Garces. All rights reserved.
//

import Cocoa

class DoubleSliderView: SMDoubleSlider {

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
