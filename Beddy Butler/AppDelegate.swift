//
//  AppDelegate.swift
//  Beddy Butler
//
//  Created by David Garces on 10/08/2015.
//  Copyright (c) 2015 QuantaCorp. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    static  var statusItem: NSStatusItem?
    
    @IBOutlet weak var menu: NSMenu!
    
    var preferencesController: PreferencesViewController?
    
    var sharedUserDefaults: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Make a status bar that has variable length
        // (as opposed to being a standard square size)
        
        // -1 to indicate "variable length"
        AppDelegate.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        
        // Set the text that appears in the menu bar
        AppDelegate.statusItem!.title = "Beddy Butler"
        
        // Set the menu that should appear when the item is clicked
        AppDelegate.statusItem!.menu = self.menu
        
        // Set if the item should ”
        //change color when clicked
        AppDelegate.statusItem!.highlightMode = true

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func quit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(nil)
    }

}

