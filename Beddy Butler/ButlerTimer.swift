//
//  ButlerTimer.swift
//  Beddy Butler
//
//  Created by David Garces on 19/08/2015.
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//

import Foundation
import Cocoa

class ButlerTimer: NSObject {
    
    //MARK: Properties

    var numberOfRepeats = 5
    var timer: Timer?
    /// the audio player that will be used in the play sound action
    var audioPlayer: AudioPlayer
    let butlerImage = NSImage(named: "Butler")
    // butler count reset limit will read the random limit to know when to reset butlerCount to 1
    var butlerReset = 3
    // butler count is a  number used to count the current number of utteraces in the same session, values should be 1, 2, or 3
    var butlerCount = 0 {
        didSet {
            // If it reaches the maximum then we should set the annoyance to a higher value, then we set the butlerCount back to 0 and we create a new value for butler reset (2-3)
            if butlerCount == butlerReset && self.userProgressiveButler == true {
                //print("Butler count is ready to set a new sound to \(self.userSelectedSound.progressiveDescription()) because butlerCount is \(butlerCount) and butlerReset is \(butlerReset)")
                self.progressiveSound = self.progressiveSound.progressiveDescription()
                butlerCount = 0
                butlerReset = randomProgressiveInterval
            }
        }
    }
    
    // TO DO: use this variable to remember the value before the progressive feature changes the value so that we can put it back to what it was
    var progressiveSound: AudioPlayer.AudioFiles = AudioPlayer.AudioFiles.shy
    
    //MARK: Computed properties
    
    //MARK: User Properties
    var userStartTime: Double? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultKeys.startTimeValue.rawValue) as? Double
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: UserDefaultKeys.startTimeValue.rawValue)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: .userPreferenceChanged, object: self)
        }
    }
    
    var userBedTime: Double? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultKeys.bedTimeValue.rawValue) as? Double
        }
        set {
            //print("userBedTime was set... oldValue = \(self.userBedTime), and newValue = \(newValue!)")
            UserDefaults.standard.set(newValue!, forKey: UserDefaultKeys.bedTimeValue.rawValue)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: .userPreferenceChanged, object: self)
        }
    }
    
    var userMuteSound: Bool? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.isMuted.rawValue)
        }
        get {
            return UserDefaults.standard.object(forKey: UserDefaultKeys.isMuted.rawValue) as? Bool
        }
    }
    
    var userProgressiveButler: Bool? {
        return UserDefaults.standard.object(forKey: UserDefaultKeys.progressive.rawValue) as? Bool
    }
    
    ///TODO: Delete Temporary frequency variable
    var userSelectedFrequency: Double? {
        return UserDefaults.standard.object(forKey: UserDefaultKeys.frequency.rawValue) as? Double
    }
    
    var userSelectedSound: AudioPlayer.AudioFiles {
        get {
            if let audioFile = UserDefaults.standard.object(forKey: UserDefaultKeys.selectedSound.rawValue) as? String {
                return AudioPlayer.AudioFiles(stringValue: audioFile)
        
            } else {
                return AudioPlayer.AudioFiles(stringValue: String())
            }
        }
    }
    
    var userCalendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.autoupdatingCurrent
        return calendar
    }
    
    /// Calculates the start date based on the current user value
    var startDate: Date {
        
        let startOfDay = startOfDayForSlider(self.userStartTime!)
        // Convert seconds to int, we are sure we will not exceed max int value as we only have 86,000 seconds or less
        // TO DO: check if seconds FROM GTM is the right way to handle calculations for multizone Apps
        let seconds = Int(self.userStartTime!) //+ NSTimeZone.localTimeZone().secondsFromGMT
        return (userCalendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: seconds, to: startOfDay, options: NSCalendar.Options.matchFirst)!
    }
    
    /// Gets today's date
    var currentDate: Date {
        /*
        let currentLocalDateComp = userCalendar.componentsInTimeZone(NSTimeZone.localTimeZone(), fromDate: NSDate())
        let currentLocalDate = currentLocalDateComp.date!
        let localTimeZone = NSTimeZone.localTimeZone()
        let secondsFromGTM = NSTimeInterval.init(localTimeZone.secondsFromGMT)
        let resultDate = NSDate(timeInterval: secondsFromGTM, sinceDate: currentLocalDate)
        print("Today is \(resultDate) and the time zone is \(NSTimeZone.localTimeZone())")
        return resultDate
        */
        return Date()
    }
    
    /// Calculates the end date based on the current user value
    var bedDate: Date {
        let startOfDay = startOfDayForSlider(self.userBedTime!)
        // Convert seconds to int, we are sure we will not exceed max int value as we only have 86,000 seconds or less
        let seconds = Int(self.userBedTime!) //+ NSTimeZone.systemTimeZone().secondsFromGMT
        return (userCalendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: seconds, to: startOfDay, options: NSCalendar.Options.matchFirst)!
        
    }
    
    func startOfDayForSlider(_ seconds: Double) -> Date {
        
        // 1. Calculate midnight of today and tomorrow
        let startOfToday = userCalendar.startOfDay(for: self.currentDate)
        let startOfTomorrow = userCalendar.startOfDay(for: (userCalendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: self.currentDate, options: NSCalendar.Options.matchFirst)!)
        let startOfYesterday = userCalendar.startOfDay(for: (userCalendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: -1, to: self.currentDate, options: NSCalendar.Options.matchFirst)!)
        
        // 2. Determine if current date is position to the left or right of the sliders to
        // Rule 1: If current time is position at the left side (43200.00...86400.00) then we should use startOfToday for any slider value on the range 43200.00...86400.00 AND startOfTomorrow for any slider value between 0.00...43200.00
        // Rule 2: Else: current time position is to the right side (0.00...43200.00) then we should use startOfYesterday for any slider value on the range 43200.00...86400.00 AND startOfToday for any slider value between 0.00...43200.00
        
        let secondsOfToday = self.currentDate.timeIntervalSince(startOfToday)
        if secondsOfToday > 43200.0 { // Rule 1 Apply (use startOfToday and startOfTomorrow)
            return seconds > 43200.0 ? startOfToday : startOfTomorrow
        } else { // Rule 2 Apply (use startOfYesterday and StartOfToday)
            return seconds > 43200.00 ? startOfYesterday : startOfToday
        }
    }
    
    //MARK: Initialisers and deinitialisers
    
    override init() {
        self.audioPlayer = AudioPlayer()
        super.init()
        
        // Not to be called directly...
        calculateNewTimer()
        // set the correct sound for the progressive feature
        self.progressiveSound = self.userSelectedSound
        // Register observers to recalculate the timer
        NotificationCenter.default.addObserver(self, selector: #selector(ButlerTimer.calculateNewTimer), name: .userPreferenceChanged , object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(ButlerTimer.validateUserTimeValue), name: UserDefaults.didChangeNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ButlerTimer.updateUserTimeValue(_:)), name: .startSliderChanged , object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(ButlerTimer.updateUserTimeValue(_:)), name: .endSliderChanged , object: nil)
        
       
    }
    
    deinit {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Timer methods
    
    /// Play sound should invalidate the current timer and schedule the next timer
    func playSound() {
        //let previousImage = AppDelegate.statusItem?.image
        var result: String
        
        //AppDelegate.statusItem?.image = butlerImage
        if !userMuteSound! {
            if userProgressiveButler == true {
                self.butlerCount += 1
                self.audioPlayer.playFile(self.progressiveSound)
                result = "[PROGRESSIVE] Sound played: \(progressiveSound), Current time is: \(currentDate), Set Start Date: \(startDate), Set Bed Date: \(bedDate), Time between plays (frequency): \(userSelectedFrequency!) \n"
            } else {
               self.audioPlayer.playFile(userSelectedSound)
                result = "Sound played: \(userSelectedSound), Current time is: \(currentDate), Set Start Date: \(startDate), Set Bed Date: \(bedDate), Time between plays (frequency): \(userSelectedFrequency!) \n"
            }
            // TO DO: Remove temporary log
            
           
        } else {
            // TO DO: Remove temporary log
            result = "Muted by user: \(userSelectedSound), Current time is: \(currentDate), Set Start Date: \(startDate), Set Bed Date: \(bedDate), Time between plays (frequency): \(userSelectedFrequency!) \n"
           
        }
        //writeToLog(result)
        ButlerTimer.writeToLog(result)
        
        calculateNewTimer()
        //AppDelegate.statusItem?.image = previousImage
    }
    
    func calculateNewTimer() {
        //Invalidate curent timer
        if let theTimer = timer {
            theTimer.invalidate()
        }
        
        var newInterval = randomInterval
        let dateAfterInterval = Date(timeInterval: randomInterval, since: self.currentDate)
        //Analyse interval:
        // 1. If Now + interval or Now alone are before start time (date), create interval from now until after start date + (5-20min)
        if (self.startDate as NSDate).isGreaterThan(dateAfterInterval) {
            newInterval = self.startDate.timeIntervalSince(self.currentDate) + newInterval
            setNewTimer(newInterval)
        } else if (dateAfterInterval as NSDate).isGreaterThan(self.startDate) && (self.bedDate as NSDate).isGreaterThan(dateAfterInterval) {
            setNewTimer(newInterval)
        } else {
            //the date will be after the interval so we calculate a new interval for tomorrow
            var components = DateComponents()
            components.day = 1
            components.second = Int(newInterval)
            let theNewDate = (userCalendar as NSCalendar).date(byAdding: components, to: self.startDate, options: NSCalendar.Options.matchFirst)
            newInterval = theNewDate!.timeIntervalSince(self.currentDate)
            setNewTimer(newInterval)
            // finally we make sure that the sound is not muted anymore
            self.userMuteSound = false
            // because we are now set for tomorrow, we also reset the progressiveSound to what the user originally has selected, so we do the progressive cycle once again.
            self.progressiveSound = self.userSelectedSound
        }
    }
    
    /// Invalidates the current timer and sets a new timer using the specified interval
    func setNewTimer(_ timeInterval: TimeInterval) {
        // Shcedule timer with the initial value
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(ButlerTimer.playSound), userInfo: nil, repeats: false)
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
        //TODO: Remove log entry
        ButlerTimer.writeToLog("Timer created for interval: \(timeInterval)")
    }

    /**
        Create a random number of seconds from the range of 5 to 20 minutes (i.e. 300 to 1200 secs) arc4random_uniform(upper_bound) will return a uniformly distributed random number less than upper_bound. arc4random_uniform() is recommended over constructions like ``arc4random() % upper_bound'' as it avoids "modulo bias" when the upper bound is not a power of two.
     
     - Returns: If the user has selected a frequency, a random number in that frequency, otherwise a random number between 5 and 20 minutes.
     
     ref: http://stackoverflow.com/questions/3420581/how-to-select-range-of-values-when-using-arc4random
     ref: https://en.wikipedia.org/wiki/Fisher–Yates_shuffle#Modulo_bias
     */
    var randomInterval: TimeInterval {
        
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
        return TimeInterval(source + randomStart) // adding 300 will ensure that it will always be from 300 to 1200

    }
    
    var randomProgressiveInterval: Int {
        let source = arc4random_uniform(2)
        return Int(source + 2)
    }
    
    //MARK: Ratio handling
    func updateUserTimeValue(_ notification: Notification) {
        if let newValue = notification.object as? NSNumber {
        switch notification.name {
        case Notification.Name.startSliderChanged:
            // Format 1: no offset
            //let convertedValue = newValue < 0.5 ? newValue * 86400 : (newValue + 0.080) * 86400
            
            // Format 2: offset but plain range
            //let convertedValue = newValue * 86400 / 0.92
            
            // Format 3: offset but range with 00:00 in the middle
            let convertedValue = convertToSeconds(ratio: newValue.doubleValue)
            self.userStartTime = convertedValue
            //print("Ratio is: \(newValue), New user start time is: \(convertedValue)")
        case Notification.Name.endSliderChanged:
            // Format 1: no offset
            //let convertedValue = newValue > 0.5 ? newValue * 86400 : (newValue - 0.080) * 86400
            
            // Format 2: offset but plain range
            // let convertedValue = (newValue - 0.080) * 86400 / 0.92
            
            // Format 3: offset but range with 0:00 in the middle
            
            let convertedValue = convertToSeconds(ratio: newValue.doubleValue - 0.08)
            
            self.userBedTime = convertedValue
            //print("Ratio is: \(newValue), New user bed time is: \(convertedValue)")
        default:
            break;
            }
        }
    }
    
    /// Converts the given value to seconds. The method will apply a different formula if the value falls in the range 0...0.5 or 0.5...1.0
    func convertToSeconds(ratio newValue: Double) -> Double {
        
        //let newValue = compensateRatioGap(ratio)
        
        let lowerRange = 0...0.46
        if lowerRange.contains(newValue) {
            return ( ( newValue * 43200.0 / 0.46 ) + 43200 ).roundToPlaces(3)
        } else {
            return ( ( newValue * 43200.0 / 0.46 ) - 43200 ).roundToPlaces(3)
        }
    }
    
    
    func validateUserTimeValue() {
//        let timeGap = 7200.00
//        let maxTime = 86400.00
//        if userBedTime < userStartTime {
//            if userStartTime! + timeGap > maxTime {
//                userStartTime = userBedTime! - timeGap
//            } else {
//                userBedTime! = userStartTime! + timeGap
//            }
//        }
    }
    
    // TODO: Remove test interval -
    var testInteval: TimeInterval {
        return TimeInterval(arc4random_uniform(100))
    }
    
    // MARK: Log

    static func writeToLog(_ message: String){
        print(message)
 
        if var log = AppDelegate.userDefaultsLog {
            let logEntry = LogEntry(date: Date(), message: message)
            log.append(logEntry)
            saveUserDefaults(log: log)
        }
        
    }
    
    static func saveUserDefaults(log: Log) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: log)
        UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.log.rawValue)
    }
    

    
    /// Retains the top 100 entries of the log and removes the rest
    ///
    /// - Parameter log: log dictionary
    /// - Returns: returns a cleaned log
    static func cleanUpLog(log: Log) -> Log {
        if log.count >= 100 {
            // leave recent 100 entries
            var newLog = log.sorted(by: { $0.0.date > $0.1.date })
            let range = 100...(log.count - 1)
            newLog.removeSubrange(range)
            return newLog
        } else {
            return oldLogEntries(log: log)
        }
    }
    
    
    /// Removes entries older than 100 days from the log
    ///
    /// - Parameter log: log
    /// - Returns: a new dictionary containing entries that are newer than 100 days ago
    static func oldLogEntries(log: Log) -> Log {
        let oldDate = Calendar.current.date(byAdding: .day, value: -100, to: Date())!
        if log.contains(where: { $0.date < oldDate }) {
            return log.filter({ $0.date > oldDate } )
        } else {
           return log
        }
        
    }
    
    static func writeLogToFile(log: Log) -> String {
        return log.map({ "\($0.date) - \($0.message)" }).joined(separator: " - ")
    }
    
    
}


