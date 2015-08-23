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

    var butlerTimer: ButlerTimer?
    
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
        
        registerUserDefaultValues()
        
        //create a new ButlerTimer
        self.butlerTimer = ButlerTimer()

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        self.butlerTimer = nil
    }
    
    @IBAction func quit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(nil)
    }
    
    
    /// This method ensures that the user default values are set when the user opens the app for the first time
    /// Subsequent launches of the app will not reset these values
    func registerUserDefaultValues() {
        
        for key in UserDefaultKeys.allValues {
            
            let registerValue = ({ self.sharedUserDefaults.setObject($0, forKey: $1) })
            
            switch key {
            case .startTimeValue:
                   let theKey = sharedUserDefaults.objectForKey(key.rawValue) as? Double
                   if theKey == nil { registerValue(NSDate(timeIntervalSince1970: 75000), key.rawValue) }
            case .bedTimeValue:
                let theKey = sharedUserDefaults.objectForKey(key.rawValue) as? Double
                if theKey == nil { registerValue(NSDate(timeIntervalSince1970: 85000), key.rawValue) }
            case .selectedSound:
                let theKey = sharedUserDefaults.objectForKey(key.rawValue) as? String
                if theKey == nil { registerValue(AudioPlayer.AudioFiles.Shy.description(), key.rawValue) }
            case .runStartup:
                let theKey = sharedUserDefaults.objectForKey(key.rawValue) as? Bool
                if theKey == nil { registerValue(false, key.rawValue) }
            default:
                break

            }
        
        
        }
        
    }

}

