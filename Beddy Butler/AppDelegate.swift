//
//  AppDelegate.swift
//  Beddy Butler
//
//  Created by David Garces on 10/08/2015.
//  Copyright (c) 2015 David Garces. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    static  var statusItem: NSStatusItem?
    
    @IBOutlet weak var menu: NSMenu!
    
    var preferencesController: PreferencesViewController?


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Make a status bar that has variable length
        // (as opposed to being a standard square size)
        
        // -1 to indicate "variable length"
        AppDelegate.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        
        // Set the text that appears in the menu bar
        AppDelegate.statusItem!.title = "My Item"
        
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
    
    //    @IBAction func openPreferences(sender: AnyObject) {
    //        if preferencesController == nil {
    //            preferencesController = PreferencesWindowController()
    //            let storyboard = NSStoryboard(name: "Main", bundle: nil)
    //            preferencesController = PreferencesWindowController(windowNibName: "Preferences Window")
    //            //preferencesController = storyboard!.instantiateControllerWithIdentifier("Preferences Storyboard") as? PreferencesWindowController
    //        }
    //        preferencesController?.showWindow(sender)
    //    }



}

