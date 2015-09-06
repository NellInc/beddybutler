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
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.endSliderChanged.rawValue, object: self)
        //NSLog("int value changed! \(self.doubleValue)")
        //Notify observers so that timer updates too
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.userPreferenceChanged.rawValue, object: self)
        
    }
    
    override var doubleValue: Double {
        didSet {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "restrictEndValue:", name: NotificationKeys.startSliderChanged.rawValue, object: nil)
        }
    }
    
    func restrictEndValue(notification: NSNotification) {
        if let slider = notification.object as? StartSliderView {
            //if the current end value is lower than the start value, increase the end value to the same as start + 30 seconds
            if self.doubleValue < slider.doubleValue  {
                //Update the value we stored in the standard user defaults. This will trigger an update in our view through cocoa bindings
                NSUserDefaults.standardUserDefaults().setObject(slider.doubleValue + 30, forKey: UserDefaultKeys.bedTimeValue.rawValue)
                NSLog("observer triggered for endValue, new value: \(self.doubleValue)")
            }
        }
    }
    
    
}
