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
    var startDate = NSDate()
    /// end date will be set to the end of the interval between startdate and main Interval
    var bedDate = NSDate()
    /// The main interval will be set based on today's date and between the user default start and bed time
    var mainInterval: NSTimeInterval?
    /// Timers 1 and 2 will alternate to play the sound randomly throughout the parent interval
    var timer1: NSTimer?
    var timer2: NSTimer?
    /// the audio player that will be used in the play sound action
    var audioPlayer: AudioPlayer
    // the
    
    //MARK: Computed properties
    
    var userStartTime: Double? {
        return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.startTimeValue.rawValue) as? Double
    }
    
    var userBedTime: Double? {
        return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.bedTimeValue.rawValue) as? Double
    }
    
    var userSelectedSound: AudioPlayer.AudioFiles? {
        if let audioFile = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.selectedSound.rawValue) as? String {
            return AudioPlayer.AudioFiles(stringValue: audioFile)
        
        } else {return nil}
    }
    
    
    
    override init() {
        self.audioPlayer = AudioPlayer()
        super.init()
        
        self.startDate = calculateStartDate
        self.bedDate = calculateEndDate
        self.mainInterval = calculateMainInterval
    
        //timer1 = NSTimer.sch
        
        //self.userStartTime = NSDate(timeIntervalSince1970: self.userStartTime!)
        //self.userBedTime = NSDate(timeIntervalSince1970: self.userBedTime!)
        
        // Register observers to populate user start time and bed time with values when the value changes
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBedTime", name: ObserverKeys.bedTimeValueChanged.rawValue , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateStartTime", name: ObserverKeys.startTimeValueChanged.rawValue , object: nil)
       
    }
    

    /// When the end time slider changes, it should post itself in a notification so that updateBedTime updates the userEndTime
    func updateBedTime(notification: NSNotification) {
        if let theObject = notification.object as? EndSliderView {
            //if let userDefaultBedTimeValue = self.userDefaultBedTime {
              //  userBedTime = NSDate(timeIntervalSince1970: userDefaultBedTimeValue)
           // }
            
        }
    }
    
     /// When the start time slider changes, it should post itself in a notification so that updateStartTime updates the userStartTime
    func updateStartTime(notification: NSNotification) {
        if let theObject = notification.object as? StartSliderView {
           // if let userDefaultStartTimeValue = self.userDefaultStartTime {
             //   userBedTime = NSDate(timeIntervalSince1970: userDefaultStartTimeValue)
            //}
            
        }
    }
    
    /// calculates the start date based on the current user value
    var calculateStartDate: NSDate {
        return NSDate(timeIntervalSinceNow: self.userStartTime!)
    }
    
    /// calculates the end date based on the current user value
    var calculateEndDate: NSDate {
        return NSDate(timeIntervalSinceNow: self.userBedTime!)
    }
    
    /// Calculates the main interval used for the timers, should only be used when both start and bed date have been calculated
    var calculateMainInterval: NSTimeInterval {
        return self.bedDate.timeIntervalSinceDate(self.startDate)
    }

}
