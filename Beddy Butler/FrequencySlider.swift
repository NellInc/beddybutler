//
//  FrequencySlider.swift
//  
//
//  Created by David Garces on 29/08/2015.
//
//

import Cocoa

class FrequencySlider: NSSlider {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent)
        // Notify the timer to recalculate
        NSNotificationCenter.defaultCenter().postNotificationName(ObserverKeys.userPreferenceChanged.rawValue, object: self)
    }
    
}