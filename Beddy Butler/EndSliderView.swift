//
//  EndSlider.swift
//  
//
//  Created by David Garces on 15/08/2015.
//
//

import Cocoa

class EndSliderView: NSSlider {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent)
        NSNotificationCenter.defaultCenter().postNotificationName("endKeyChanged", object: self)
        //NSLog("int value changed! \(self.doubleValue)")
        
    }
    
    override var doubleValue: Double {
        didSet {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "restrictEndValue:", name: "startKeyChanged", object: nil)
        }
    }
    
    @objc func restrictEndValue(notification: NSNotification) {
        let slider = notification.object as! NSSlider
        // if the current start value is higher than the end value, increasethe end value to the same as start + 30 seconds
        //NSLog("endSlider current: \slider."
        if slider.doubleValue > self.doubleValue {
            self.doubleValue = slider.doubleValue + 30
            NSLog("observer triggered for endValue, new value: \(self.doubleValue)")
        }
        
        
    }
    
    
}
