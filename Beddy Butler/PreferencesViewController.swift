//
//  ViewController.swift
//  Beddy Butler
//
//  Created by David Garces on 10/08/2015.
//  Copyright (c) 2015 QuantaCorp. All rights reserved.
//

import Cocoa
import ServiceManagement

class PreferencesViewController: NSViewController, NSTextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet var userDefaults: NSUserDefaultsController!
    
    var audioPlayer: AudioPlayer = AudioPlayer()

    @IBOutlet weak var startTimeTextValue: NSTextField!
    
    @IBOutlet weak var endTimeTextValue: NSTextField!
  
    @IBOutlet weak var doubleSlider: DoubleSliderView!
    @IBOutlet weak var doubleSliderHandler: DoubleSliderHandler!
    
//    var representedTimerRandomness: String {
//        let endRange = (self.timerRandomness * 0.7) + self.timerRandomness
//        return "\(self.timerRandomness) to \(endRange) min."
//    }
    
    //MARK: View Main Events
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadDoubleSliderValues()
        loadDoubleSliderHandler()
    }
    
    override func viewWillDisappear() {
        super.viewDidDisappear()
        // Removes self from all notifications that are observing
        NSNotificationCenter.defaultCenter().removeObserver(doubleSlider)
        // NSNotificationCenter.defaultCenter().removeObserver(self, name: "endKey", object: nil)
    }
    
     deinit {
        NSNotificationCenter.defaultCenter().removeObserver(doubleSlider)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
            
        }
    }
    
    func loadDoubleSliderValues() {

        self.doubleSlider.maxValue = 86400
        
         self.doubleSlider.bind("objectLoValue", toObject: self.userDefaults, withKeyPath: "values.startTimeValue", options: nil)
        
         self.doubleSlider.bind("objectHiValue", toObject: self.userDefaults, withKeyPath: "values.bedTimeValue", options: nil)
        
        self.doubleSlider.continuous = true
        
        self.doubleSlider.numberOfTickMarks = 24
        
        self.doubleSlider.tickMarkPosition = NSTickMarkPosition.Below
        
        self.doubleSlider.allowsTickMarkValuesOnly = false

    }
    
    func loadDoubleSliderHandler() {
        
        
        let value = { (valueIn: CGFloat) -> CGFloat in return valueIn }
        let invertedValue = { (valueIn: CGFloat) -> CGFloat in return valueIn }
        
        let startSlider = NSImage(named: "StartSlider")
        let bedSlider = NSImage(named: "BedSlider")
        bedSlider
        
        // Do any additional setup after loading the view.
        doubleSliderHandler.addHandle("BedHandler", image: bedSlider!, initRatio: 1.0, sliderValue: value,sliderValueChanged: invertedValue)
        
        doubleSliderHandler.addHandle("StartHandler", image: startSlider!, initRatio: 0.0, sliderValue: value,sliderValueChanged: invertedValue)
    

        // Add Bindings
        //self.doubleSliderHandler.bind("values.startValue", toObject: self.userDefaults, withKeyPath: "values.startTimeValue", options: nil)
        
        //self.doubleSliderHandler.bind("values.bedValue", toObject: self.userDefaults, withKeyPath: "values.bedTimeValue", options: nil)
        
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
    
    
    @IBAction func changedPreference(sender: AnyObject) {
         NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.userPreferenceChanged.rawValue, object: self)
    }
    
    
    @IBAction func changeRunStartup(sender: AnyObject) {
        
        if let theButton = sender as? NSButton {
            let runStartup = Bool(theButton.integerValue)
                    // Turn on launch at login
                    SMLoginItemSetEnabled("com.nellwatson.BeddyButlerHelperApp" as CFString, runStartup)
                    
        }
    }
    
    /// Updates the status title to the title of the selected cell (i.e. Shy, Insistent, or Zombie.
//    @IBAction func updateStatusTitle(sender: AnyObject) {
//        
//        if let selectedItem = sender as? NSMatrix {
//            if let _: NSButtonCell = selectedItem.selectedCell() as? NSButtonCell {
//                //AppDelegate.statusItem!.title = selectedCell.title
//            }
//            
//        }
//        
//    }

    

}

