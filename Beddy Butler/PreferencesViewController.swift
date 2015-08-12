//
//  ViewController.swift
//  Beddy Butler
//
//  Created by David Garces on 10/08/2015.
//  Copyright (c) 2015 David Garces. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    var selectedStartTime: NSDate?
    var selectedTimeInterval: NSTimeInterval?

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


}

