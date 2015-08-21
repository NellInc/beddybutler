//
//  StartSlider.swift
//  
//
//  Created by David Garces on 15/08/2015.
//
//

import Cocoa

class StartSliderView: NSSlider {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        
        //self.doubleValue = 200
    }
    
    
//    override var doubleValue: Double {
//        didSet{
//            super.doubleValue = self.doubleValue
//           
//        }
//    }
    
    
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent)
        NSNotificationCenter.defaultCenter().postNotificationName("startKeyChanged", object: self)
           // NSLog("int value changed! \(self.doubleValue)")
        
    }
    
    override var doubleValue: Double {
        didSet{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "restrictStartValue:", name: "endKeyChanged", object: nil)
            NSLog("property call, new value for start: \(self.doubleValue)")
        }
    }
    
    
    @objc func restrictStartValue(notification: NSNotification) {
        if let slider = notification.object as? EndSliderView {
            // if the current start value is higher than the end value, reduce it to the same as end - 30 seconds
            if self.doubleValue > slider.doubleValue  {
                //Update the value we stored in the standard user defaults. This will trigger an update in our view through cocoa bindings
                NSUserDefaults.standardUserDefaults().setObject(slider.doubleValue - 30, forKey: UserDefaultKeys.startTimeValue.rawValue)
                // Notify observers so that timer updates too
                NSNotificationCenter.defaultCenter().postNotificationName(ObserverKeys.startTimeValueChanged.rawValue, object: self)
                NSLog("observer triggered for StartValue, new value: \(self.doubleValue)")
            }
        }

        
        
    }

    
}
