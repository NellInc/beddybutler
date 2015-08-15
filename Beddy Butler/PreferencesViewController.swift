//
//  ViewController.swift
//  Beddy Butler
//
//  Created by David Garces on 10/08/2015.
//  Copyright (c) 2015 David Garces. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController, NSTextFieldDelegate {

    var selectedStartTime: NSDate?
    var selectedTimeInterval: NSTimeInterval?

    
    @IBOutlet weak var startSliderView: StartSliderView!
    
    @IBOutlet weak var endSliderView: EndSliderView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
            
        }
    }
    
    @IBAction func test1Pressed(sender: AnyObject) {
         AppDelegate.statusItem!.title = "hi!"
        
    }
    
    override func viewWillDisappear() {
        super.viewDidDisappear()
        // Removes self from all notifications that are observing
        NSNotificationCenter.defaultCenter().removeObserver(startSliderView)
        NSNotificationCenter.defaultCenter().removeObserver(endSliderView)
       // NSNotificationCenter.defaultCenter().removeObserver(self, name: "endKey", object: nil)
    }


}

