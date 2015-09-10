//
//  TestController.swift
//  Beddy Butler
//
//  Created by David Garces on 09/09/2015.
//  Copyright © 2015 David Garces. All rights reserved.
//

import Cocoa

class TestController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        self.doubleSlider.maxValue = 100
        
        self.doubleSlider.setDoubleHiValue(70.0)
        self.doubleSlider.setDoubleLoValue(30.0)
        
        self.doubleSlider.continuous = false
        
        self.doubleSlider.numberOfTickMarks = 11
        
        self.doubleSlider.tickMarkPosition = NSTickMarkPosition.Below
        
        self.doubleSlider.allowsTickMarkValuesOnly = true
        
        self.doubleSlider.numberOfTickMarks = 11
        
        self.doubleSlider.needsDisplay = true
    }
    @IBOutlet weak var doubleSlider: DoubleSlider!
    
}
