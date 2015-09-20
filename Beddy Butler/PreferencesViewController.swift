//
//  ViewController.swift
//  Beddy Butler
//
//  Created by David Garces on 10/08/2015.
//  Copyright (c) 2015 QuantaCorp. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController, NSTextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet var userDefaults: NSUserDefaultsController!
    
    var audioPlayer: AudioPlayer = AudioPlayer()

    @IBOutlet weak var startTimeTextValue: NSTextField!
    
    @IBOutlet weak var endTimeTextValue: NSTextField!
  
    @IBOutlet weak var doubleSlider: DoubleSliderView!
    
//    var representedTimerRandomness: String {
//        let endRange = (self.timerRandomness * 0.7) + self.timerRandomness
//        return "\(self.timerRandomness) to \(endRange) min."
//    }
    
    //MARK: View Main Events
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadDoubleSliderValues()
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
                if runStartup {
                // creat plist
                    
                    /*
                    let plist = ["Label": "com.nellwatson.Beddy-Butler",
                        "ProgramArguments: "
                    
                    
                    
                    ]
                    
                    
                    <key>Label</key>
                    <string>my.everydaytasks</string>
                    <key>ProgramArguments</key>
                    <array>
                    <string>/Applications/EverydayTasks.app/Contents/MacOS/EverydayTasks</string>
                    </array>
                    <key>ProcessType</key>
                    <string>Interactive</string>
                    <key>RunAtLoad</key>
                    <true/>
                    <key>KeepAlive</key>
                    <false/>
                    
                    */
                    
                    var plistDictionary: Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
  
                    // Create Key values
                    let label = "com.nellwatson.Beddy-Butler"
                    let programArguments = ["/Applications/EverydayTasks.app/Contents/MacOS/EverydayTasks"]
                    let processType = "Interactive"
                    let runAtLoad = true
                    let keepAlive = true
                    
                    // Assign Key values to keys
                    plistDictionary["Label"] = label
                    plistDictionary["ProgramArguments"] = programArguments
                    plistDictionary["ProcessType"] = processType
                    plistDictionary["RunAtLoad"] = runAtLoad
                    plistDictionary["KeepAlive"] = keepAlive
                    
                    do {
                       try  _ = NSPropertyListSerialization.dataWithPropertyList(plistDictionary, format: NSPropertyListFormat.XMLFormat_v1_0, options: NSPropertyListWriteOptions.init())
                    } catch {
                        NSLog("Error while creating agent file")
                    }
                   
                                       /*
                    NSMutableDictionary *rootObj = [NSMutableDictionary dictionaryWithCapacity:2];
                    NSDictionary *innerDict;
                    NSString *name;
                    NSDate *dob;
                    NSArray *scores;
                    
                    scores = [NSArray arrayWithObjects:[NSNumber numberWithInt:6],
                        [NSNumber numberWithFloat:4.6], [NSNumber numberWithLong:6.0000034], nil];
                    name = @"George Washington";
                    dob = [NSDate dateWithString:@"1732-02-17 04:32:00 +0300"];
                    innerDict = [NSDictionary dictionaryWithObjects:
                    [NSArray arrayWithObjects: name, dob, scores, nil]
                    forKeys:[NSArray arrayWithObjects:@"Name", @"DOB", @"Scores"]];
                    [rootObj setObject:innerDict forKey:@"Washington"];
                    
                    scores = [NSArray arrayWithObjects:[NSNumber numberWithInt:8],
                    [NSNumber numberWithFloat:4.9],
                    [NSNumber numberWithLong:9.003433], nil];
                    name = @"Abraham Lincoln";
                    dob = [NSDate dateWithString:@"1809-02-12 13:18:00 +0400"];
                    innerDict = [NSDictionary dictionaryWithObjects:
                    [NSArray arrayWithObjects: name, dob, scores, nil]
                    forKeys:[NSArray arrayWithObjects:@"Name", @"DOB", @"Scores"]];
                    [rootObj setObject:innerDict forKey:@"Lincoln"];
                    
                    id plist = [NSPropertyListSerialization dataFromPropertyList:(id)rootObj
                    format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
                    */
                    
                } else {
                // disable plist
            }
           
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

