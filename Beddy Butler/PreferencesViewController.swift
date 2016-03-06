//
//  ViewController.swift
//  Beddy Butler
//
//  Created by David Garces on 10/08/2015.
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//

import Cocoa
import ServiceManagement

class PreferencesViewController: NSViewController, NSTextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet var userDefaults: NSUserDefaultsController!
    
    var audioPlayer: AudioPlayer = AudioPlayer()

    @IBOutlet weak var startTimeTextValue: NSTextField!
    
    @IBOutlet weak var endTimeTextValue: NSTextField!
  
    
    @IBOutlet weak var doubleSliderHandler: DoubleSliderHandler!
    
    @IBOutlet weak var iconImageView: NSImageView!
    
    @IBOutlet weak var progressiveButton: NSButton!
    
    var userSelectedSound: String? {
        return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.selectedSound.rawValue) as? String
    }
    
    //MARK: View Main Events
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Disable popover initially
        
     //   loadDoubleSliderValues()
        loadDoubleSliderHandler()
        loadSelectedImage(self.userSelectedSound!)
        
        // load tracking area for progressive tooltip
        let progressiveButtonTrackingArea = NSTrackingArea(rect: progressiveButton.bounds, options: [NSTrackingAreaOptions.ActiveInKeyWindow, NSTrackingAreaOptions.MouseEnteredAndExited], owner: self, userInfo: nil)
        progressiveButton.addTrackingArea(progressiveButtonTrackingArea)

    }
    
    override func viewWillDisappear() {
        super.viewDidDisappear()
        // Removes self from all notifications that are observing
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
            
        }
    }
    
    func loadDoubleSliderHandler() {
        
        
        let value = { (valueIn: CGFloat) -> CGFloat in return valueIn }
        let invertedValue = { (valueIn: CGFloat) -> CGFloat in return valueIn }
        
        let startSlider = NSImage(named: SliderKeys.StartSlider.rawValue)
        let bedSlider = NSImage(named: SliderKeys.BedSlider.rawValue)
        bedSlider
        
        var userStartTime: Double? {
            return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.startTimeValue.rawValue) as? Double
        }
        
        var userBedTime: Double? {
            return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.bedTimeValue.rawValue) as? Double
        }
        
        // Format with no offset:
        //let startconvertedValue = newValue < 0.5 ? newValue * 86400 : (newValue + 0.080) * 86400
        //let bedconvertedValue = newValue > 0.5 ? newValue * 86400 : (newValue - 0.080) * 86400
        //let convertedStartValue = initialStartRadio < 0.5 ? initialStartRadio : (initialStartRadio - 0.080)
        //let convertedBedValue = initialBedRatio > 0.5 ? initialBedRatio : (initialBedRatio + 0.080)
        
        // Format with offset of 0.92 but a plain range between 00:00 and 0:00
        //let initialBedRatio = CGFloat(userBedTime!*0.92/86400)
        //let initialStartRadio = CGFloat(userStartTime!*0.92/86400)
        //let convertedStartValue = initialStartRadio + 0.5
        //let convertedBedValue = initialBedRatio + 0.080 - 0.5
        
        // Format with offset of 0.92 but a range having 00:00 in the middle
        let initialBedRatio = convertToRatio(userBedTime!)
        let initialStartRadio = convertToRatio(userStartTime!)
        let convertedStartValue = CGFloat(initialStartRadio)
        let convertedBedValue = CGFloat(initialBedRatio+0.08)
        

        
        // Do any additional setup after loading the view.
        doubleSliderHandler.addHandle(SliderKeys.BedHandler.rawValue, image: bedSlider!, iniRatio: convertedBedValue, sliderValue: value,sliderValueChanged: invertedValue)
        
        doubleSliderHandler.addHandle(SliderKeys.StartHandler.rawValue, image: startSlider!, iniRatio: convertedStartValue, sliderValue: value,sliderValueChanged: invertedValue)
    }
    
    //// Because offset is 0.08, we need to use a scale of 0...0.92. if we split this in two parts, each will have 0.46 for its calculations
    func convertToRatio(seconds: Double) -> Double {
        let rangeOnRight = 0.0...43200.0
        if rangeOnRight.contains(seconds) {
            return ( ( seconds * 0.46 / 43200.0 ) + 0.46 ).roundToPlaces(3)
        } else {
            return ( ( seconds * 0.46 / 43200.0 ) - 0.46 ).roundToPlaces(3)
        }
    }
    
    
    //MARK: View Controller Actions
    
    /// If the user clicks on any of the preview buttons, its audio file will play for them.
    @IBAction func previewAudio(sender: AnyObject) {
        
        if let button: NSButton = sender as? NSButton {
            
            if let identifier = button.identifier {
                switch identifier {
                case "Preview Shy":
                    audioPlayer.playFile(AudioPlayer.AudioFiles.Shy)
                case "Preview Insistent":
                    audioPlayer.playFile(AudioPlayer.AudioFiles.Insistent)
                case "Preview Zombie":
                    audioPlayer.playFile(AudioPlayer.AudioFiles.Zombie)
                default:
                    break
                }
            }
        }
    }
    
    var canPerformSegue = false
    
    @IBAction func performProgressiveToolTipSegue(sender: AnyObject) {
        self.canPerformSegue = true
        performSegueWithIdentifier("progressiveSegue", sender: sender)
        self.canPerformSegue = false
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "progressiveSegue" {
            return canPerformSegue
        }
        return true
    }
    
    /// Used to verify if the mouse enters the tracking area of the progressive button. If it does, the seague to the tooltip will be triggered
    override func mouseEntered(theEvent:NSEvent){
        if CGRectContainsPoint(self.progressiveButton.frame, theEvent.locationInWindow) {
            performProgressiveToolTipSegue(self)
        }
    }
    
    /// Once the mouse exits the tracking area of the progressive button, the view controller dismisses any presented children.
    override func mouseExited(theEvent:NSEvent){
        self.presentedViewControllers?.forEach { self.dismissViewController($0) }
    }
    
    
    @IBAction func changedRadioSelection(sender: NSMatrix) {
       loadSelectedImage(sender.selectedCell()!.title)
    }
    
    @IBAction func changedPreference(sender: AnyObject) {
         NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.userPreferenceChanged.rawValue, object: self)
    }
    
    @IBAction func changeRunStartup(sender: AnyObject) {
        
        if let theButton = sender as? NSButton {
            let runStartup = Bool(theButton.integerValue)
            let loginItems = LoginItems()
                    // Turn on launch at login
            if runStartup {
               loginItems.createLoginItem()
            } else {
                loginItems.deleteLoginItem()
            }
            
        }
    }
    
    // MARK: Other methods
    
    func loadSelectedImage(currentValue: String) {
        switch currentValue {
        case "Shy":
            self.iconImageView.image = NSImage(named: "ShyIcon")
        case "Insistent":
            self.iconImageView.image = NSImage(named: "InsistentIcon")
        case "Zombie":
            self.iconImageView.image = NSImage(named: "ZombieIcon")
        default:
            break
        }
    }
    
}

