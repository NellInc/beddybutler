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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.bind("objectLoValue", toObject: NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.startTimeValue.rawValue)!, withKeyPath: "objectLoValue", options: nil)
        
       // NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.startTimeValue.rawValue)?.bind(<#T##binding: String##String#>, toObject: <#T##AnyObject#>, withKeyPath: <#T##String#>, options: <#T##[String : AnyObject]?#>)
    }
    
    
    
}
