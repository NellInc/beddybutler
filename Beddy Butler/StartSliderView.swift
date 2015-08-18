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
        let slider = notification.object as! NSSlider
        // if the current start value is higher than the end value, reduce it to the same as end - 30 seconds
        if self.doubleValue < slider.doubleValue  {
            self.doubleValue = slider.doubleValue - 30
            NSLog("observer triggered for StartValue, new value: \(self.doubleValue)")
        }
        
        
    }

    
}
