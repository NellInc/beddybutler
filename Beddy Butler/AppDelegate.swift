//
//  AppDelegate.swift
//  Beddy Butler
//
//  Created by David Garces on 10/08/2015.
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//

import Cocoa
import ServiceManagement
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var butlerTimer: ButlerTimer?
    
    static  var statusItem: NSStatusItem?
    
    @IBOutlet weak var menu: NSMenu!
    
    var preferencesController: PreferencesViewController?
    
    var sharedUserDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        if let theButlerTimer = butlerTimer {
            theButlerTimer.calculateNewTimer()
        } else {
            butlerTimer = ButlerTimer()
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Make a status bar that has variable length
        // (as opposed to being a standard square size)
        
        // -1 to indicate "variable length"
        AppDelegate.statusItem = NSStatusBar.system().statusItem(withLength: 20)
        
        // Set the text that appears in the menu bar
        //AppDelegate.statusItem!.title = "Beddy Butler"
        AppDelegate.statusItem?.image = NSImage(named: "IconBlack")
        AppDelegate.statusItem?.image?.size = NSSize(width: 18, height: 18)
        // image should be set as tempate so that it changes when the user sets the menu bar to a dark theme
        // TODO: feature disabled for now, this may possibly be the issue to why it is not showing in Nell's mac
        //AppDelegate.statusItem?.image?.setTemplate(true)
        
        // Set the menu that should appear when the item is clicked
        AppDelegate.statusItem!.menu = self.menu
        
        // Set if the item should ”
        //change color when clicked
        AppDelegate.statusItem!.highlightMode = true
        
        registerUserDefaultValues()
        
        //set the default time zone for the application
        NSTimeZone.resetSystemTimeZone()
        //let testTimeZone =  NSTimeZone(name: testTimeZoneName)!
        //NSTimeZone.setDefaultTimeZone(testTimeZone)
        NSTimeZone.setDefaultTimeZone(TimeZone.current)
        print("time zone at start is \(TimeZone.autoupdatingCurrent), local time is \(Date().localDate)")
        
        //create a new ButlerTimer
        self.butlerTimer = ButlerTimer()
        
        //register for Notifications
        registerForNotitications()
        
        //determine if helper app is running
        var startedAtLogin = false
        let apps = NSWorkspace.shared().runningApplications
        for app in apps {
            if app.bundleIdentifier == "com.nellwatson.BeddyButlerHelperApp" {
                startedAtLogin = true
            }
        }
        
        if startedAtLogin {
            DistributedNotificationCenter.default().post(name: "terminateApp", object: Bundle.main.bundleIdentifier)
        }
        
        
        
    }
    
    
    var testTimeZoneName: String {
        let knowTimeZones = TimeZone.knownTimeZoneIdentifiers
        
        return knowTimeZones.filter{ $0.contains("Krasnoyarsk") }.first!
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        self.butlerTimer = nil
        deRegisterFromNotifications()
    }
    
    @IBAction func quit(_ sender: AnyObject) {
        NSApplication.shared().terminate(nil)
    }
    
    
    /// This method ensures that the user default values are set when the user opens the app for the first time
    /// Subsequent launches of the app will not reset these values
    func registerUserDefaultValues() {
        
        for key in UserDefaultKeys.allValues {
            
            let registerValue = ({ self.sharedUserDefaults.set($0, forKey: $1) })
            
            switch key {
            case .startTimeValue:
                   let theKey = sharedUserDefaults.object(forKey: key.rawValue) as? Double
                   if theKey == nil || theKey < 0.0 || theKey > 86400.0 { registerValue(75000.00, key.rawValue) }
            case .bedTimeValue:
                let theKey = sharedUserDefaults.object(forKey: key.rawValue) as? Double
                if theKey == nil || theKey > 84600.00 || theKey < 0.0 { registerValue(84600.00, key.rawValue) }
            case .selectedSound:
                let theKey = sharedUserDefaults.object(forKey: key.rawValue) as? String
                if theKey == nil { registerValue(AudioPlayer.AudioFiles.shy.description(), key.rawValue) }
            case .runStartup:
                let theKey = sharedUserDefaults.object(forKey: key.rawValue) as? Bool
                if theKey == nil { registerValue(false, key.rawValue) }
            case .frequency:
                let theKey = sharedUserDefaults.object(forKey: key.rawValue) as? Double
                if theKey == nil { registerValue(5.00, key.rawValue) }
            case .isMuted:
                let theKey = sharedUserDefaults.object(forKey: key.rawValue) as? Double
                if theKey == nil { registerValue(false, key.rawValue) }
            case .progressive:
                let theKey = sharedUserDefaults.object(forKey: key.rawValue) as? Bool
                if theKey == nil { registerValue(false, key.rawValue) }
            }
        
        }
        
        
        
    }
    
    /// Beddy Butler should get notifified when it goes to sleep to handle the current timer
    func receiveSleepNotification(_ notification: Notification) {
        NSLog("Sleep nottification received: \(notification.name)")
        self.butlerTimer?.timer?.invalidate()
    }
    
    /// Beddy Butler should get notified when the PC wakes up from sleep so it can restart its timer
    func receiveWakeNotification(_ notification: Notification) {
        NSLog("Wake nottification received: \(notification.name)")
        NSTimeZone.resetSystemTimeZone()
        self.butlerTimer?.calculateNewTimer()
    }
    
    func registerForNotitications() {
        //These notifications are filed on NSWorkspace's notification center, not the default
        // notification center. You will not receive sleep/wake notifications if you file
        //with the default notification center.
        NSWorkspace.shared().notificationCenter.addObserver(self, selector: #selector(AppDelegate.receiveSleepNotification(_:)), name: NSNotification.Name.NSWorkspaceWillSleep, object: nil)
        NSWorkspace.shared().notificationCenter.addObserver(self, selector: #selector(AppDelegate.receiveWakeNotification(_:)), name: NSNotification.Name.NSWorkspaceDidWake, object: nil)
    }
    
    func deRegisterFromNotifications() {
        NSWorkspace.shared().notificationCenter.removeObserver(self)
    }
    
    
}

