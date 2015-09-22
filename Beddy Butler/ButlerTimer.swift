//
//  ButlerTimer.swift
//  Beddy Butler
//
//  Created by David Garces on 19/08/2015.
//  Copyright (c) 2015 QuantaCorp. All rights reserved.
//

import Foundation
import Cocoa

class ButlerTimer: NSObject {
    
    //MARK: Properties
    
    var numberOfRepeats = 5
    /// start date will be set to current date + user's default startTime
    //var startDate = NSDate()
    /// end date will be set to the end of the interval between startdate and main Interval
    //var bedDate = NSDate()
    /// The main interval will be set based on today's date and between the user default start and bed time
    var mainInterval: NSTimeInterval?
    /// Timers 1 and 2 will alternate to play the sound randomly throughout the parent interval
    var timer: NSTimer?
    //var timer2: NSTimer?
    /// the audio player that will be used in the play sound action
    var audioPlayer: AudioPlayer
    // the
    let butlerImage = NSImage(named: "Butler")
    
    //MARK: Computed properties
    
    var userStartTime: Double? {
        return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.startTimeValue.rawValue) as? Double
    }
    
    var userBedTime: Double? {
        return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.bedTimeValue.rawValue) as? Double
    }
    
    var userMuteSound: Bool? {
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: UserDefaultKeys.isMuted.rawValue)
        }
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.isMuted.rawValue) as? Bool
        }
    }
    
    /// Temporary frequency variable
    var userSelectedFrequency: Double? {
        return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.frequency.rawValue) as? Double
    }
    
    var userSelectedSound: AudioPlayer.AudioFiles {
        if let audioFile = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.selectedSound.rawValue) as? String {
            return AudioPlayer.AudioFiles(stringValue: audioFile)
        
        } else {
            return AudioPlayer.AudioFiles(stringValue: String())
        }
    }
    
    
    
    override init() {
        self.audioPlayer = AudioPlayer()
        super.init()
        
        //self.startDate = calculateStartDate
        //self.bedDate = calculateEndDate
        self.mainInterval = calculateMainInterval
    
        // may be used later to show a butler icon while butling
        //butlerImage?.setTemplate(true)
        
        // Not to be called directly...
        calculateNewTimer()
        
        // Register observers to recalculate the timer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "calculateNewTimer", name: NotificationKeys.userPreferenceChanged.rawValue , object: nil)
        
       
    }
    
    deinit {
        timer?.invalidate()
        //NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

    /// When the end time slider changes, it should post itself in a notification so that updateBedTime updates the userEndTime
    func updateBedTime(notification: NSNotification) {
        //if let _ = notification.object as? EndSliderView {
            // calculateEndDate will return a new value again as it has changed by the user
            //self.bedDate = calculateEndDate
            
        //}
    }
    
     /// When the start time slider changes, it should post itself in a notification so that updateStartTime updates the userStartTime
    func updateStartTime(notification: NSNotification) {
        //if let _ = notification.object as? StartSliderView {
            // calculateStartDate will return a new value again as it has changed by the user
            //self.startDate = calculateStartDate
            
        //}
    }
    
    /// calculates the start date based on the current user value
    var startDate: NSDate {
        
        let calendar = NSCalendar.currentCalendar()
        let startOfDay = calendar.startOfDayForDate(NSDate())
        // Convert seconds to int, we are sure we will not exceed max int value as we only have 86,000 seconds or less
        let seconds = Int(self.userStartTime!)
        return calendar.dateByAddingUnit(NSCalendarUnit.Second, value: seconds, toDate: startOfDay, options: NSCalendarOptions.MatchFirst)!
        
        //return NSDate(timeIntervalSinceNow: self.userStartTime!)
    }
    
    /// calculates the end date based on the current user value
    var bedDate: NSDate {
        let calendar = NSCalendar.currentCalendar()
        let startOfDay = calendar.startOfDayForDate(NSDate())
        // Convert seconds to int, we are sure we will not exceed max int value as we only have 86,000 seconds or less
        let seconds = Int(self.userBedTime!)
        return calendar.dateByAddingUnit(NSCalendarUnit.Second, value: seconds, toDate: startOfDay, options: NSCalendarOptions.MatchFirst)!
    }
    
    /// Calculates the main interval used for the timers, should only be used when both start and bed date have been calculated
    var calculateMainInterval: NSTimeInterval {
        return self.bedDate.timeIntervalSinceDate(self.startDate)
    }
    
    /// Play sound should invalidate the current timer and schedule the next timer
    func playSound() {
        //let previousImage = AppDelegate.statusItem?.image
        var result: String
        
        //AppDelegate.statusItem?.image = butlerImage
        if !userMuteSound! {
            audioPlayer.playFile(userSelectedSound)
            
            result = "Sound played: \(userSelectedSound), Current time is: \(NSDate()), Set Start Date: \(startDate), Set Bed Date: \(bedDate), Time between plays (frequency): \(userSelectedFrequency!) \n"
           
        } else {
            result = "Muted by user: \(userSelectedSound), Current time is: \(NSDate()), Set Start Date: \(startDate), Set Bed Date: \(bedDate), Time between plays (frequency): \(userSelectedFrequency!) \n"
           
        }
        writeToLogFile(result)
        NSLog(result)
        
        calculateNewTimer()
        //AppDelegate.statusItem?.image = previousImage
    }
    
    func calculateNewTimer() {
        //Invalidate curent timer
        if let theTimer = timer {
            theTimer.invalidate()
        }
        
        let currentDate = NSDate()
        
        var newInterval = randomInterval
        let dateAfterInterval = NSDate(timeInterval: randomInterval, sinceDate: currentDate)
        //Analyse interval:
        // 1. If Now + interval or Now alone are before start time (date), create interval from now until after start date + (5-20min)
        if self.startDate.isGreaterThan(dateAfterInterval) {
            newInterval = self.startDate.timeIntervalSinceDate(currentDate) + newInterval
            setNewTimer(newInterval)
        } else if dateAfterInterval.isGreaterThan(self.startDate) && self.bedDate.isGreaterThan(dateAfterInterval) {
            setNewTimer(newInterval)
        } else {
            //the date will be after the interval so we calculate a new interval for tomorrow
            let calendar = NSCalendar.currentCalendar()
            let components = NSDateComponents()
            components.day = 1
            components.second = Int(newInterval)
            let theNewDate = calendar.dateByAddingComponents(components, toDate: self.startDate, options: NSCalendarOptions.MatchFirst)
            newInterval = theNewDate!.timeIntervalSinceDate(currentDate)
            setNewTimer(newInterval)
            // finally we make sure that the sound is not muted anymore
            userMuteSound = false
        }
    }
    
    /// Invalidates the current timer and sets a new timer using the specified interval
    func setNewTimer(timeInterval: NSTimeInterval) {
        // Shcedule timer with the initial value
        self.timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "playSound", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        NSLog("Timer created for interval: \(timeInterval)")
    }
    
    func isIntvervalAfterUserBedTime(interval: NSTimeInterval) -> Bool {
        let dateAfterInterval = NSDate(timeIntervalSinceNow: interval)
        return dateAfterInterval.isGreaterThan(self.bedDate)
    }
    
    func isIntervalAfterUserStartTime(interval: NSTimeInterval) -> Bool {
        let dateBeforeInterval = NSDate(timeIntervalSinceNow: interval)
        return dateBeforeInterval.isGreaterThan(self.startDate)
    }
    
    /// Create a random number of seconds from the range of 5 to 20 minutes (i.e. 300 to 1200 secs)
    /// arc4random_uniform(upper_bound) will return a uniformly distributed random number less than upper_bound. arc4random_uniform() is recommended over constructions like ``arc4random() % upper_bound'' as it avoids "modulo bias" when the upper bound is not a power of two. 
    /// ref: http://stackoverflow.com/questions/3420581/how-to-select-range-of-values-when-using-arc4random
    /// ref: https://en.wikipedia.org/wiki/Fisher–Yates_shuffle#Modulo_bias
    var randomInterval: NSTimeInterval {
        
        var randomStart: UInt32
        var randomEnd: UInt32
        
        if let theKey = userSelectedFrequency {
            randomStart = UInt32(theKey * 60)
            randomEnd = UInt32( ( (theKey * 0.7) + theKey) * 60 )
        } else {
            randomStart = 300
            randomEnd = 901
        }
        
        let source = arc4random_uniform(randomEnd) // should return a random number between 0 and 900
        return NSTimeInterval(source + randomStart) // adding 300 will ensure that it will always be from 300 to 1200

    }
    
    var testInteval: NSTimeInterval {
        return NSTimeInterval(arc4random_uniform(100))
    }
    
    func writeToLogFile(message: String){
        //Create file manager instance
        let fileManager = NSFileManager()
        
        let URLs = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        
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
        
            
            //fileManager.createFileAtPath(file, contents: NSData, attributes: nil)
    }
    
        
    }




extension NSDate {
    class func randomTimeBetweenDates(lhs: NSDate, _ rhs: NSDate) -> NSDate {
        let lhsInterval = lhs.timeIntervalSince1970
        let rhsInterval = rhs.timeIntervalSince1970
        let difference = fabs(rhsInterval - lhsInterval)
        let randomOffset = arc4random_uniform(UInt32(difference))
        let minimum = min(lhsInterval, rhsInterval)
        let randomInterval = minimum + NSTimeInterval(randomOffset)
        return NSDate(timeIntervalSince1970: randomInterval)
    }
}
