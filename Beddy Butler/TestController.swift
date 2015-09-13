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
        
        
        self.doubleSlider.maxValue = 86400
        
        self.doubleSlider.setDoubleHiValue(70.0)
        self.doubleSlider.setDoubleLoValue(30.0)
        
        self.doubleSlider.continuous = false
        
        self.doubleSlider.numberOfTickMarks = 11
        
        self.doubleSlider.tickMarkPosition = NSTickMarkPosition.Below
        
        self.doubleSlider.allowsTickMarkValuesOnly = true
        
        self.doubleSlider.numberOfTickMarks = 11
        
        self.doubleSlider.needsDisplay = true
    }
    @IBOutlet weak var doubleSlider: DoubleSliderView!
    
    
    @IBAction func changeLo(sender: AnyObject) {
        
         let random = arc4random_uniform(50000)
         self.doubleSlider.setDoubleLoValue(Double(random))
        NSLog("New Lo: \(random)")
        self.doubleSlider.needsDisplay = true
        
    }
    
    
    @IBAction func changeHi(sender: AnyObject) {
        let random = arc4random_uniform(86400)
        self.doubleSlider.setDoubleHiValue(Double(random))
        NSLog("New Hi: \(random)")
        self.doubleSlider.needsDisplay = true
    }
    
}
