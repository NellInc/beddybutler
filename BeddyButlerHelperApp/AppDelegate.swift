//
//  AppDelegate.swift
//  BeddyButlerHelperApp
//
//  Created by David Garces on 20/09/2015.
//  Copyright © 2015 David Garces. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: "terminateApp", name: "terminateApp", object: nil)
        
        // Check if main app is already running; if yes, do nothing and terminate helper app
        var isAlreadyRunning = false
        //var isActive = false
        
        let running = NSWorkspace.sharedWorkspace().runningApplications
        
        for app in running {
            if app.bundleIdentifier == "com.nellwatson.Beddy-Butler" {
                isAlreadyRunning = true
                //isActive = NSApp.active
            }
            
        }

        if !isAlreadyRunning {
        
        NSLog("are you reaching??")
            writeToLogFile("Helper finished launching...")
            
            let path = NSWorkspace.sharedWorkspace().absolutePathForAppBundleWithIdentifier("com.nellwatson.Beddy-Butler")
           
            let result = NSWorkspace.sharedWorkspace().launchApplication(path!)
            writeToLogFile("Run at startup executed result:\(result), path is: \(path!)")
        }
        
        terminateApp()
        
    }

    
    func terminateApp() {
        NSApp.terminate(nil)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        NSDistributedNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //TODO: Remove log file and logging functionality -
    func writeToLogFile(message: String){
        //Create file manager instance
        let fileManager = NSFileManager()
        
        let path = NSString(string: NSBundle.mainBundle().bundlePath).stringByDeletingLastPathComponent
        let reviewedPath = NSString(string: path).stringByDeletingLastPathComponent
        let reviewedPath2 = NSString(string: reviewedPath).stringByDeletingLastPathComponent
        let reviewedPath3 = NSString(string: reviewedPath2).stringByDeletingLastPathComponent
        let reviewedPath4 = NSString(string: reviewedPath3).stringByAppendingPathComponent("Resources")
        
        let newURL = NSURL(string: reviewedPath4)
        
        //let URL = fileManager.URLForDirectory(NSSearchPathDirectory.in, inDomain: <#T##NSSearchPathDomainMask#>, appropriateForURL: <#T##NSURL?#>, create: <#T##Bool#>)
        
        let URLs = fileManager.URLsForDirectory(NSSearchPathDirectory.DownloadsDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        
        let documentURL = URLs[0]
        let fileURL = documentURL.URLByAppendingPathComponent("BeddyButlerLog.txt")
        
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        
        //if !fileManager.fileExistsAtPath(fileURL) {
        do {
            if !fileManager.fileExistsAtPath(fileURL.path!) {
                
                if !fileManager.createFileAtPath(fileURL.path!, contents: data , attributes: nil) {
                    NSLog("File not created: \(fileURL.absoluteString)")
                }
            }
            
            let handle: NSFileHandle = try NSFileHandle(forWritingToURL: fileURL)
            handle.truncateFileAtOffset(handle.seekToEndOfFile())
            handle.writeData(data!)
            handle.closeFile()
            
        }
        catch {
            NSLog("Error writing to file: \(error)")
        }
        
    }


}

