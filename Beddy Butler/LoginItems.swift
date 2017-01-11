//
//  LoginItems.swift
//  Beddy Butler
//
//  Created by David Garces on 23/10/2015.
//  Copyright © 2015 David Garces. All rights reserved.
//

import Foundation
import Cocoa

class LoginItems: NSObject {
    
    //MARK: Variables
    let fileManager = FileManager()
    let bundleIdentifier = Bundle.main.bundleIdentifier
    
    //MARK: Computed Variables
    
    fileprivate var plistPath: URL {
        
        //Create file manager instance
        let URLs = fileManager.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        
        // build file name
        let fileName = bundleIdentifier! + ".plist"
        
        let documentURL = URLs[0]
        let reviewedURL = documentURL.appendingPathComponent("LaunchAgents")
        let fileURL = reviewedURL.appendingPathComponent(fileName)
        
        return fileURL
        
    }
    
    fileprivate var appExecutePath: String {
        let bundlePath = Bundle.main.bundleURL
        let appName = NSString(string: bundlePath.lastPathComponent).deletingPathExtension
        return bundlePath.path + "/Contents/MacOS/" + appName
       
    }
    
    //MARK: Public login handling methods
    
    func deleteLoginItem(){
        
        let sharedFileListLoginItems = kLSSharedFileListSessionLoginItems
        let bundlePath = Bundle.main.bundleURL
        
        if let loginReference = LSSharedFileListCreate(kCFAllocatorDefault, sharedFileListLoginItems?.takeUnretainedValue(), nil) {
            let loginListValue = loginReference.takeUnretainedValue()
            let beforeFirstLoginItem = kLSSharedFileListItemBeforeFirst.takeUnretainedValue()
            if let loginItem = LSSharedFileListInsertItemURL(loginListValue, beforeFirstLoginItem, "Beddy Butler" as CFString, nil, bundlePath as CFURL!, nil, nil) {
                
                LSSharedFileListItemRemove(loginListValue, loginItem.takeUnretainedValue())
                
            }
        }
    }
    
    func createLoginItem() {
        
        let sharedFileListLoginItems = kLSSharedFileListSessionLoginItems
        let bundlePath = Bundle.main.bundleURL
        
        if let loginReference = LSSharedFileListCreate(kCFAllocatorDefault,  sharedFileListLoginItems?.takeUnretainedValue(), nil) {
            let loginListValue = loginReference.takeUnretainedValue()
            let beforeFirstLoginItem = kLSSharedFileListItemBeforeFirst.takeUnretainedValue()
            LSSharedFileListInsertItemURL(loginListValue, beforeFirstLoginItem, "Beddy Butler" as CFString, nil, bundlePath as CFURL!, nil, nil)

        }
        
    }
    
    //MARK: Alternative login methods
    
    fileprivate func createPlistFile(_ data: Data) {
        let theURL = plistPath
        deletePlistFile()
        fileManager.createFile(atPath: theURL.path, contents: data, attributes: nil)
    }
    
    fileprivate func deletePlistFile() {
        do {
            let theURL = plistPath
            if fileManager.fileExists(atPath: theURL.path) {
                try fileManager.removeItem(at: theURL)
            }
        } catch {
            let resultMessage = "Error while deleting the plist file"
            NSLog(resultMessage)
        }
    }
    
    fileprivate func deleteLoginItemV2() {
        deletePlistFile()
    }

    
    fileprivate func createLoginItemV2() {
        
        // NSApplication.ur
        let bundlePath = Bundle.main.bundleURL
        //let appName = NSString(string: bundlePath.lastPathComponent!).stringByDeletingPathExtension
        
        var plistDictionary: Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        // Create Key values
        let label = bundleIdentifier
        //let programArguments = ["/Applications/LaunchAtLoginExample.app/Contents/MacOS/LaunchAtLoginExample"]
        let programArguments = bundlePath.path //+ "/Contents/MacOS/" + appName
        let processType = "Interactive"
        let runAtLoad = true
        let keepAlive = true // This key specifies whether your daemon launches on-demand or must always be running. It is recommended that you design your daemon to be launched on-demand.
        
        // Assign Key values to keys
        plistDictionary["Label"] = label as AnyObject?
        plistDictionary["ProgramArguments"] = programArguments as AnyObject?
        plistDictionary["ProcessType"] = processType as AnyObject?
        plistDictionary["RunAtLoad"] = runAtLoad as AnyObject?
        plistDictionary["KeepAlive"] = keepAlive as AnyObject?
        
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: plistDictionary, format: PropertyListSerialization.PropertyListFormat.xml, options: PropertyListSerialization.WriteOptions.init())
            
            createPlistFile(data)
            
        } catch {
            let resultMessage = "Error while creating agent file"
            
            NSLog(resultMessage)
        }
    }
    
}
