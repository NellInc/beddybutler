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

    var selectedStartTime: NSDate?
    var selectedTimeInterval: NSTimeInterval?
    
    var audioPlayer: AudioPlayer = AudioPlayer()

    
    @IBOutlet weak var startSliderView: StartSliderView!
    
    @IBOutlet weak var endSliderView: EndSliderView!
    
    //MARK: View Main Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear() {
        super.viewDidDisappear()
        // Removes self from all notifications that are observing
        NSNotificationCenter.defaultCenter().removeObserver(startSliderView)
        NSNotificationCenter.defaultCenter().removeObserver(endSliderView)
        // NSNotificationCenter.defaultCenter().removeObserver(self, name: "endKey", object: nil)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
            
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
    
    /// Updates the status title to the title of the selected cell (i.e. Shy, Insistent, or Zombie.
    @IBAction func updateStatusTitle(sender: AnyObject) {
        
        if let selectedItem = sender as? NSMatrix {
            if let selectedCell: NSButtonCell = selectedItem.selectedCell() as? NSButtonCell {
                AppDelegate.statusItem!.title = selectedCell.title
            }
            
        }
        
    }

}

