//
//  DoubleSliderCellView.swift
//  Beddy Butler
//
//  Created by David Garces on 16/09/2015.
//  Copyright © 2015 David Garces. All rights reserved.
//

import Cocoa

class DoubleSliderCellView: NSSliderCell {
    
    //MARK: Properties
    
    var startValue: Double = 0.0
    var storeValue: Double = 0.0
    var trackingStartKnob: Bool {
        set {
            if self.sliderCellFlags.isTrackingStartKnob != newValue {
                (self.controlView as! NSControl).updateCell(self)
            }
        } get {
            return self.sliderCellFlags.isTrackingStartKnob
        }
    }
    var lockedSliders: Bool {
        set {
            if self.sliderCellFlags.lockedSliders != newValue {
                self.sliderCellFlags.lockedSliders = newValue
            }
            if newValue {
                self.doubleStartValue = self.doubleBedValue
            }
            
            (self.controlView as! NSControl).updateCell(self)
            
        } get {
            return self.sliderCellFlags.lockedSliders
        }
    }
    var sliderCellFlags: __sliderCellFlags
    
    //MARK: Carried from DoubleSliderView properties
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
    
    // MARK: Knob properties
    
    var startKnobRect: NSRect {
        var knobRect: NSRect
        var storeValue: Double
        
        storeValue = self.doubleValue
        self.doubleValue = self.startValue
        
        knobRect = self.knobRectFlipped((self.controlView?.flipped)!)
        self.doubleValue = storeValue
        
        return knobRect
    }
    
    //MARK: Overriden properties
    
    override var minValue: Double {
        set {
            if self.doubleStartValue < newValue {
                self.doubleStartValue = newValue
            }
            if self.doubleBedValue < newValue {
                self.doubleBedValue = newValue
            }
            super.minValue = newValue

        } get {
            return super.minValue
        }
    }
    
    
    override var maxValue: Double {
        set {
            if self.doubleStartValue > newValue {
                self.doubleStartValue = newValue
            }
            if self.doubleBedValue > newValue {
                self.doubleBedValue = newValue
            }
            super.maxValue = newValue
            
        } get {
            return super.maxValue
        }
    }
    //var doubleValue
    
    //MARK: Flags
    
    struct __sliderCellFlags {
        var lockedSliders: Bool = false
        var isTrackingStartKnob: Bool = false
        var mouseTrackingSwapped: Bool = false
        var removeFocusRingStyle: Bool = false
    }
    
    //MARK: Initialisers
    required init?(coder aDecoder: NSCoder) {
        // initialise the flags
        var decoderLockedSliders: Bool?
        sliderCellFlags = __sliderCellFlags()
        super.init(coder: aDecoder)
      
        
        if aDecoder.allowsKeyedCoding {
            self.startValue = aDecoder.decodeDoubleForKey("startValue")
            decoderLockedSliders = aDecoder.decodeBoolForKey("lockedSliders")
        } else
        {
            //TO DO: complete decoding when does not allow key coding.
           // aDecoder.decodeValueOfObjCType(@encode(Double), at: self.startValue)
        }
        
        sliderCellFlags.lockedSliders = decoderLockedSliders != nil ? (decoderLockedSliders?.boolValue)! : true
        sliderCellFlags.isTrackingStartKnob = true
        
        // values should be between min and max
        if self.minValue > self.startValue {
            self.startValue = self.minValue
        }
        if self.maxValue < self.startValue {
            self.startValue = self.maxValue
        }
        
    }
    
    //MARK: Drawing
    
    override func drawKnob() {
        var startKnob: NSRect
        let toStoreValue = super.doubleValue
        var savePressed = false //????
        
        // Draw the start knob
        
        if !sliderCellFlags.mouseTrackingSwapped {
            // tracking on the start know means that we already have the start knob value, if not, we need to assign it
            self.doubleValue = self.startValue
        }
        
        // focus ring style and pressed state of start knob
        self.sliderCellFlags.removeFocusRingStyle =  self.showsFirstResponder && !self.trackingStartKnob
        
        // TODO: flags code still pending for start knob
        // Figure out the focus ring style and pressed state of the start knob.
        //_sm_flags.removeFocusRingStyle = ( _cFlags.showsFirstResponder && ![ self trackingLoKnob ] );
        //_scFlags.isPressed = ( savePressed && [ self trackingLoKnob ] );
        startKnob = self.knobRectFlipped((self.controlView?.flipped)!)
        self.drawKnob(startKnob)
        
        // draw the bed knob
        if sliderCellFlags.mouseTrackingSwapped {
            // tracking the knob means we alreay have a value to save
            self.doubleValue = self.storeValue
        } else {
            // restore position of bed knob
            self.doubleValue = toStoreValue
        }
        
        // focus ring style
        self.sliderCellFlags.removeFocusRingStyle = self.showsFirstResponder && self.trackingStartKnob
    
        
        //TO DO : flags code still pending for bed knob
         //_scFlags.isPressed = ( savePressed && ![ self trackingLoKnob ] );
        
        super.drawKnob()
        
        // reset values
        self.doubleValue = toStoreValue
        // TO DO: flags again!
        //  _scFlags.isPressed = savePressed;
        self.sliderCellFlags.removeFocusRingStyle = false
        
    }
    
    override func drawKnob(knobRect: NSRect) {
        var focusRingType: NSFocusRingType = NSFocusRingType.None
        
        if self.sliderCellFlags.removeFocusRingStyle {
            
            if self.respondsToSelector("focusRingType:") {
                focusRingType = self.focusRingType
                self.focusRingType = NSFocusRingType.None
            }
            
            NSGraphicsContext.currentContext()?.restoreGraphicsState()
            
        }
        
        super.drawKnob(knobRect)
        
        if self.sliderCellFlags.removeFocusRingStyle {
            
            if self.respondsToSelector("focusRingType:") {
                self.focusRingType = focusRingType
            }
            
            NSGraphicsContext.currentContext()?.saveGraphicsState()
            NSSetFocusRingStyle(NSFocusRingPlacement.Above)
        }
    }
    
    override func startTrackingAt(startPoint: NSPoint, inView controlView: NSView) -> Bool {
        var theStartKnobRect: NSRect
        
        // are we tracking the start or the bed knob?
        theStartKnobRect = self.startKnobRect
        
        if self.vertical  == 1 {
            if controlView.flipped {
                self.trackingStartKnob = startPoint.y > theStartKnobRect.origin.y
            } else {
                self.trackingStartKnob = startPoint.y < theStartKnobRect.origin.y + theStartKnobRect.size.height
            }
        }
        
        // stop user from dragging start and bed knobs to minimum
        if self.trackingStartKnob && NSEqualRects(theStartKnobRect, self.knobRectFlipped(controlView.flipped)) {
            self.trackingStartKnob = self.startValue > self.minValue
        }
        
        // start knob should be redisplayed the first time
        if self.trackingStartKnob {
            controlView.setNeedsDisplayInRect(startKnobRect)
        }
        
        // save bed value
        self.storeValue = self.doubleValue
        
        // if user is tracking start knob revert back to the value of the start knob
        self.sliderCellFlags.mouseTrackingSwapped = self.trackingStartKnob
        
        if self.sliderCellFlags.mouseTrackingSwapped {
            self.doubleValue = self.startValue
        }
        
        return super.startTrackingAt(startPoint, inView: controlView)
        
    }
    
    override func continueTracking(lastPoint: NSPoint, at currentPoint: NSPoint, inView controlView: NSView) -> Bool {
        var trackingResult: Bool
        
        trackingResult = super.continueTracking(lastPoint, at: currentPoint, inView: controlView)
        
        if self.sliderCellFlags.mouseTrackingSwapped {
            // limit to maximum of bed value
            if self.doubleValue > self.storeValue {
                self.doubleValue = self.storeValue
            }
            
            if self.continuous {
                // TO DO: complete this call after DoubleSliderView implements updateBoundControllerStartValue
                //(controlView as! DoubleSliderView).updateBoundControllerStartValue(self.doubleValue)
            }
        } else {
            
            // limit to minimum of start value
            if self.doubleValue < self.startValue {
                self.doubleValue = self.startValue
            }
            
            if self.continuous {
                // TO DO: complete this call after DoubleSliderView implements updateBoundControllerBedValue
                //(controlView as! DoubleSliderView).updateBoundControllerBedValue(self.doubleValue)
            }
            
        }
        
        return trackingResult
    }
    
    override func stopTracking(lastPoint: NSPoint, at stopPoint: NSPoint, inView controlView: NSView, mouseIsUp flag: Bool) {
        if self.sliderCellFlags.mouseTrackingSwapped {
            
            // tracking start knob, so we will update values for that one
            self.startValue = self.doubleValue
            self.doubleValue = self.storeValue
            self.sliderCellFlags.mouseTrackingSwapped = false
            controlView.setNeedsDisplayInRect(self.startKnobRect)
            
            // always update controller
             // TO DO: complete this call after DoubleSliderView implements updateBoundControllerStartValue
            //(controlView as! DoubleSliderView).updateBoundControllerStartValue(self.startValue)
            
        } else {
            // TO DO: complete this call after DoubleSliderView implements updateBoundControllerBedValue
            //(controlView as! DoubleSliderView).updateBoundControllerBedValue(self.doubleValue)
            
        }
        
        super.stopTracking(lastPoint, at: stopPoint, inView: controlView, mouseIsUp: flag)
    }

}
